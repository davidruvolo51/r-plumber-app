#' Accessible and Responsive Datatables
#'
#' The `datatable` function creates an accessible, responsive table from a
#' dataset. The function returns a shiny tagList object which can
#' be used in shiny applications or markdown documents. This function
#' can also be used as an html table generator and the output can be
#' written to file. This function takes the following arguments.
#'
#'
#' @param data A data object used to render the table (required)
#' @param caption A short description (1-2 lines) for the table (optional)
#' @param caption_placement change the position of the caption in relation to
#'      the table. Choices are "top" (default) or "bottom".
#' @param id a unique ID for the table
#' @param classnames a string containing one or more css classes
#' @param row_highlighting If `TRUE` (default), whenever the mouse hovers over
#'      a cell, the entire row will be highlighted
#' @param row_headers If `TRUE`, the first cell in each table row will be
#'      rendered as a row header (default: `FALSE`).
#' @param is_responsive If `TRUE` (default), the HTML structure of the table
#'      will be responsive.
#' @param html_escape If `TRUE` (default), all cell content will be rendered
#'      as plain text.
#'
#' @examples
#'
#' ```{r}
#' datatable(data = iris)
#'
#' datatable(data = iris, id = "iris-table", classnames = "dark-theme")
#'
#' datatable(data = iris, is_responsive = FALSE)
#'
#' datatable(data = iris, id = "iris", row_headers = TRUE)
#'
#' df <- dplyr::starwars
#' df$link <- paste0(
#'     "<a href='https://www.google.com/search?q=",
#'     gsub(" ", "+", df$character),
#'     "'>",
#'     df$character,
#'     "</a>"
#' )
#' tbl <- datatable(data = df, html_escape = FALSE)
#' writeLines(as.character(tbl), "~/Desktop/table.html")
#' ```
#'
#' @return Create a responsive datatable
#'
#' @export
datatable <- function(
    data,
    caption = NULL,
    caption_placement = NULL,
    id = NULL,
    classnames = NULL,
    row_highlighting = TRUE,
    row_headers = FALSE,
    is_responsive = TRUE,
    html_escape = TRUE
) {

    # validate input args
    stopifnot(
        "`row_highlighting` must be TRUE or FALSE" = is.logical(row_highlighting),
        "`row_headers` must be TRUE or FALSE" = is.logical(row_headers),
        "`is_responsive` must be TRUE or FALSE" = is.logical(is_responsive),
        "`html_escape` must be TRUE or FALSE" = is.logical(html_escape)
    )

    if (!is.null(caption_placement)) {
        stopifnot(
            "`caption_placement` must be 'top' or 'bottom'" = {
                caption_placement %in% c("top", "bottom")
            }
        )
    }

    # build value for class attribute
    css <- .datatable__helpers$validate__classnames(
        caption_status = ifelse(is.null(caption), FALSE, TRUE),
        caption_placement = ifelse(
            is.null(caption_placement),
            "top",
            caption_placement
            ),
        row_highlighting = row_highlighting,
        is_responsive = is_responsive
    )

    # gather options
    config <- list(
        is_responsive = is_responsive,
        html_escape = html_escape,
        row_headers = row_headers
    )

    # generate table markup
    tbl <- htmltools::tags$table(
        class = css,
        .datatable__helpers$ui__thead(data, config = config),
        .datatable__helpers$ui__tbody(data, config = config)
    )

    # append caption
    if (length(caption) > 0) {
        tbl$children <- list(
            htmltools::tags$caption(
                as.character(caption)
            ),
            tbl$children
        )
    }

    # add `id` and `class`
    if (!is.null(id)) {
        tbl$attribs$id <- id
    }
    if (!is.null(classnames)) {
        tbl$attribs$class <- paste0(tbl$attribs$class, " ", classnames)
    }

    # return
    return(tbl)
}

#' Data Table Helpers
#'
#' @noRd
.datatable__helpers <- list()


#' Validate CSS Classes
#'
#' Return css classnames based on argument values
#'
#' @param caption_status if TRUE, then caption is used
#' @param caption_placement string indicating how the caption is positioned
#' @param row_highlighting if TRUE, rows will be highlighted when hovered
#' @param is_responsive If `TRUE` (default), responsive markup will be returned
#'
#' @examples
#' .datatable__helpers$validate__classnames(
#'   caption_status = TRUE,
#'   caption_placement = "top",
#'   row_highlighting = TRUE
#' )
#'
#' @noRd
.datatable__helpers$validate__classnames <- function(
    caption_status,
    caption_placement,
    row_highlighting,
    is_responsive
) {
    base <- c("datatable")
    if (is_responsive) {
        base[length(base) + 1] <- "datatable__responsive"
    }

    if (caption_status) {
        base[length(base) + 1] <- paste0("caption__side__", caption_placement)
    }
    if (row_highlighting) {
        base[length(base) + 1] <- "row__highlighting"
    }

    paste0(base, collapse = " ")
}


#' Define Table Cell Attributes
#'
#' This function generates cell-level attributes based on a
#' given data point. Two input arguments are required: index
#' and value. The index is a counter that represents the column
#' index. This is used to generate the css classes ".column-1".
#' The data point is passed into the value argument. The returned
#' object is a list that is used to add attributes to the cell.
#'
#' @param index an integer value indicating `nth of max` (from parent func)
#' @param value the value of the current data point (row, col)
#'
#' @examples
#' .datatable__helpers$set__cell__attribs(1, "test-value")
#'
#' @noRd
.datatable__helpers$set__cell__attribs <- function(index, value) {
    value_class <- class(value)
    attr <- list(
        `data-col` = index,
        `data-col-align` = "left",
        `data-value` = value,
        `data-value-class` = value_class,
        `data-value-num-type` = "NaN"
    )

    if (!is.na(value)) {
        if (value_class %in% c("integer", "numeric", "double")) {
            attr$`data-col-align` <- "right"
            if (value > 0) {
                attr$`data-value-num-type` <- "positive"
            }
            if (value < 0) {
                attr$`data-value-num-type` <- "negative"
            }
            if (value == 0) {
                attr$`data-value-num-type` <- "zero"
            }
        }
    }

    return(attr)
}


#' Build Table body cells
#'
#' This function generates the cell markup for the current row
#' based on user defined options. Passed on the options, the
#' returned cell may have an span for responsive layouts, a custom
#' data attribute for selecting cells in css, and classnames based on
#' the data type and column index. Cells may also be returned as a
#' row header if the option is TRUE.
#'
#' @param ... input data from map
#' @param config internal configuration object
#'
#' @noRd
.datatable__helpers$ui__tbody__td <- function(..., config) {
    args <- rlang::list2(...)
    index <- 1
    alignment <- c()
    cells <- purrr::imap(args, function(d, .x) {
        colname <- as.character(.x)


        if (!config$html_escape) {
            cell_value <- htmltools::HTML(d)
        }

        if (config$html_escape) {
            cell_value <- htmltools::htmlEscape(d)
        }

        # Is the option row_headers set to TRUE
        # and is the current column index 1?
        if (config$row_headers && index == 1) {
            cell <- htmltools::tags$th(cell_value)
            cell$attribs$role <- "rowheader"
        } else {
            cell <- htmltools::tags$td(cell_value)
            cell$attribs$role <- "gridcell"
        }


        if (config$is_responsive) {
            cell$children <- list(
                htmltools::tags$span(
                    class = "hidden__colname",
                    `aria-hidden` = "true",
                    colname
                ),
                cell$children
            )
        }


        attr <- .datatable__helpers$set__cell__attribs(index, d)
        cell$attribs$`data-col` <- attr$`data-col`
        cell$attribs$`data-col-name` <- colname
        cell$attribs$`data-col-align` <- attr$`data-col-align`
        cell$attribs$`data-value` <- attr$`data-value`
        cell$attribs$`data-value-class` <- attr$`data-value-class`
        if (attr$`data-value-num-type` != "NaN") {
            cell$attribs$`data-value-num-type` <- attr$`data-value-num-type`
        }

        index <<- index + 1
        return(cell)
    })
    return(cells)
}

#' Generate Table Rows
#'
#' This function generates the markup for each row. User defined
#' options are passed into the lower-level function `ui__tbody__td`
#'
#' @param ... input data from map
#' @param config internal configuration object
#'
#' @noRd
.datatable__helpers$ui__tbody__tr <- function(..., config) {
    args <- rlang::list2(...)
    cells <- purrr::pmap(
        args,
        ~ .datatable__helpers$ui__tbody__td(..., config = config)
    )
    return(htmltools::tags$tr(cells, role = "row"))
}

#' Generate Table Body
#'
#' This function generates the html markup for the table body based
#' on the input dataset. Markup is generated by rows and cells and
#' returned in a tbody element.
#'
#' @param data input data
#' @param config internal configuration object
#'
#' @examples
#' d <- as.data.frame(dplyr::starwars[1:10, 1:11])
#' c <- list(
#'   is_responsive = TRUE,
#'   html_escape = TRUE,
#'   row_headers = FALSE
#' )
#' .datatable__helpers$ui__tbody(d, c)
#'
#' @noRd
.datatable__helpers$ui__tbody <- function(data, config) {
    body <- purrr::pmap(
        data,
        ~ .datatable__helpers$ui__tbody__tr(..., config = config)
    )
    return(htmltools::tags$tbody(role = "presentation", body))
}

#' Generate Table Head
#'
#' This function generates the html markup for the table header element
#' based on user defined options. Class for the column is determined by
#' assessing the class of each cell in the first row of the input dataset.
#'
#' @param data input dataset
#' @param config internal configuration object
#'
#' @noRd
.datatable__helpers$ui__thead <- function(data, config) {
    index <- 1
    headers <- purrr::map(names(data), function(c) {
        col <- as.character(c)


        if (!config$html_escape) {
            cell_value <- htmltools::HTML(c)
        }
        if (config$html_escape) {
            cell_value <- htmltools::htmlEscape(c)
        }

        c <- htmltools::tags$th(
            role = "columnheader",
            scope = "col",
            cell_value
        )

        # attr <- .datatable__helpers$set__cell__attribs(index, data[1, index])
        # c$attribs$`data-col` <- attr$`data-col`
        # c$attribs$`data-col-name` <- col
        # c$attribs$`data-col-align` <- attr$`data-col-align`

        index <<- index + 1
        return(c)
    })
    row <- htmltools::tags$tr(role = "row", headers)
    return(htmltools::tags$thead(role = "presentation", row))
}

