#' @title Filter Planner Data
#' @description Using dplyr, quickly filter planner data from read_planner()
#' @param planner Planner data returned from read_planner()
#' @param ... dplyr::filter arguments
#' @return A new Planner list with original plan name,
#'         original plan export date, and filtered plan data
#' @examples
#' \dontrun{
#' ## Basic Usage
#'      filter_planner(plan, Progress == "Not started", Priority == "Urgent")
#' }
#' @export
filter_planner <- function(planner, ...) {
    new_planner <- list()
    new_planner[[1]] <- planner[[1]]
    new_planner[[2]] <- planner[[2]]
    new_planner[[3]] <- dplyr::filter(planner[[3]], ...)
    
    return(new_planner)
}