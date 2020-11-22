#' @title Filter Planner Data
#' @description Using dplyr, quickly filter planner data from read_planner()
#' @param planner Planner data returned from read_planner()
#' @param ... dplyr::filter arguments
#' @return A new Planner object with original plan name,
#'         original plan export date, and filtered plan data
#' @examples
#' \dontrun{
#' ## Basic Usage
#'      filter_planner(plan, Progress == "Not started", Priority == "Urgent")
#' }
#' @importFrom dplyr filter
#' @export

filter_planner <- function(planner, ...) {

    if (class(planner) == "plannr") {
        planner$plan_name <- paste0(planner$plan_name, " (Filtered)")
        planner$data <- dplyr::filter(planner$data, ...)
        new_planner <- planner
    } else {
        new_planner <- list()
        new_planner$plan_name   <- planner$plan_name
        new_planner$export_date <- planner$export_date
        new_planner$data        <- dplyr::filter(planner$data, ...)
    }

    plannr::read_planner(new_planner)
}