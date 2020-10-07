#' @title Get Planner Data
#' @description Read in Microsoft Planner data from .xlsx file
#' @param xlsx A Microsoft Excel spreadsheet exported from Planner
#' @return A list of plan name, plan export date, and tibble of plan data
#' @examples
#' \dontrun{
#' ## Basic Usage
#'      read_planner("path/to/planner.xlsx")
#' }
#' @export

read_planner <- function(xlsx) {
    # Read .xlsx
    plan_data <- readxl::read_excel(xlsx)

    # Read Planner Name
    plan_name <- colnames(plan_data[2])

    # Read Planner Export Date
    plan_date <- plan_data[[2]][2]

    # Change tibble column names to 
    filtered_data <- setNames(plan_data, plan_data[4, ])
    filtered_data <- filtered_data[-c(1,2,3,4), ]

    # Create Planner List with name, data, and data
    planner <- list()
    planner[[1]] <- plan_name
    planner[[2]] <- plan_date
    planner[[3]] <- filtered_data

    # Return organized Planner data
    return(planner)
}