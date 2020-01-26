#' ////////////////////////////////////////////////////////////////////////////
#' FILE: plumber.R
#' AUTHOR: David Ruvolo
#' CREATED: 2020-01-26
#' MODIFIED: 2020-01-26
#' PURPOSE: create APIs
#' STATUS: working
#' PACKAGES: plumber
#' COMMENTS: NA
#' ////////////////////////////////////////////////////////////////////////////

# load pkg - via github: davidruvolo51/accessibleshiny
suppressPackageStartupMessages(library(accessibleshiny))
suppressPackageStartupMessages(library(dplyr))

# load data
df <- readRDS("server/data/birds_summary.RDS")

#' @get /data
#' @post /data
#' @json
function(req, value = 0) {

    # process request
    rows <- value
    data <- dplyr::slice(df, 1:rows)

    # build html table
    tbl <- as.character(
        accessibleshiny::datatable(
            data = data,
            id = "birds",
            caption = "Reporting Rates of Australian Birds in 2018"
        )
    )

    # return
    list(
        html = tbl
    )
}
