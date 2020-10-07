filter_planner <- function(planner, ...) {
    new_planner <- list()
    new_planner[[1]] <- planner[[1]]
    new_planner[[2]] <- planner[[2]]
    new_planner[[3]] <- dplyr::filter(planner[[3]], ...)
    
    return(new_planner)
}