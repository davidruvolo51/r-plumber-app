#' ////////////////////////////////////////////////////////////////////////////
#' FILE: plumber.R
#' AUTHOR: David Ruvolo
#' CREATED: 2020-01-26
#' MODIFIED: 2021-01-09
#' PURPOSE: create APIs
#' STATUS: working
#' PACKAGES: plumber
#' COMMENTS: NA
#' ////////////////////////////////////////////////////////////////////////////

# source utils
source("R/datatable.R")

# load data
df <- dplyr::starwars

#* @get /data
#* @post /data
#* @serializer json
function(req, value = 0) {

    # process request
    if (value == "all") {
        data <- df
    }
    if (value != "all") {
        data <- dplyr::slice(df, 1:value)
    }

    # build html table
    tbl <- as.character(
        datatable(
            data = data,
            id = "starwars_data",
            caption = "Starwars dataset from the `dplyr` package"
        )
    )

    # return
    list(html = tbl)
}
