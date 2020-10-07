#' @title Plot or get plottable data from Planner
#' @description Allows the ability to quickly filter plottable data by column or directly plot with ggplot2.
#' @param planner Planner data returned from read_planner()
#' @param by Column to filter planner data by. Either: "tasks", "checklists", "priority", "late", "assigned_to", or "completed_by"
#' @param data_only If TRUE, makes function return plottable data as a tibble. Must be FALSE if basic_plot is set to TRUE
#' @param basic_plot If TRUE, makes function return a basic ggplot. Must be FALSE if data_only is set to TRUE
#' @param ... Extra arguments for ggplot labs()
#' @return Either plottable data as a tibble, a simple ggplot, or a ggplot donut chart.
#' @examples
#' \dontrun{
#' ## Basic Usage
#'      plot_planner(plan_xlsx, by = "checklists")
#' 
#' ## Filtered Plottable Plan Data
#'      plot_planner(plan_xlsx, by = "priority", data_only = TRUE)
#' 
#' ## Extended with ggplot2
#'      plot_planner(
#'          plan_xlsx,
#'          by = "tasks",
#'          basic_plot = TRUE,
#'          title = "Tasks Progress"
#'      ) +
#'          geom_bar() +
#'          theme_bw()
#' }
#' @export

plot_planner <- function(planner, by = "tasks", data_only = FALSE, basic_plot = FALSE, ...) {
    
    # Exception
    if (!missing(data_only) && !missing(basic_plot)) {
        print("Use only 'data_only' or 'basic_plot' but not both.")
    }
    
    # Instantiate variable
    plot_data <- NA

    # Switch type of plot
    switch(by,
           "tasks" = {
               plan_completed_tasks <- planner[[3]] %>%
                   dplyr::filter(Progress == "Completed") %>%
                   dplyr::count()

               plan_in_progress_tasks <- planner[[3]] %>%
                   dplyr::filter(Progress == "In progress") %>%
                   dplyr::count()

               plan_notstarted_tasks <- count(planner[[3]]) - (plan_completed_tasks + plan_in_progress_tasks)

               plot_data <- data.frame(
                   category = c("Not Started", "In Progress", "Completed"),
                   task_data = c(plan_notstarted_tasks,
                                 plan_in_progress_tasks,
                                 plan_completed_tasks)
               )
           },
           "checklists" = {
               plan_completed_tasks <- 
                   stringr::str_sub(sub("\\/.*", "", as.data.frame(planner[[3]][15])[[1]]),
                                   start = 1) %>%
                   as.numeric() %>%
                   sum(na.rm = TRUE)
            
               plan_total_tasks <- 
                   sub(".*\\/", "", as.data.frame(planner[[3]][15])[[1]]) %>%
                   as.numeric() %>%
                   sum(na.rm = TRUE)

               plan_notstarted_tasks <- plan_total_tasks - plan_completed_tasks

               plot_data <- data.frame(
                   category = c("Not Started", "Completed"),
                   task_data = c(plan_notstarted_tasks,
                                 plan_completed_tasks
                   )
               )
           },
           "priority" = {
               plan_urgent_tasks <- dplyr::filter(planner[[3]], Priority == "Urgent") %>%
                   dplyr::count()
               plan_important_tasks <- dplyr::filter(planner[[3]], Priority == "Important") %>%
                   dplyr::count()
               plan_medium_tasks <- dplyr::filter(planner[[3]], Priority == "Medium") %>%
                   dplyr::count()
               plan_low_tasks <- dplyr::filter(planner[[3]], Priority == "Low") %>%
                   dplyr::count()

               plot_data <- data.frame(
                   category = c("Urgent", "Important", "Medium", "Low"),
                   task_data = c(plan_urgent_tasks,
                                 plan_important_tasks,
                                 plan_medium_tasks,
                                 plan_low_tasks
                   )
               )
           },
           "late" = {
               plan_late_tasks <- dplyr::filter(planner[[3]], Late == "true") %>%
                   dplyr::count()

               plan_not_late_tasks <- count(planner[[3]]) - plan_late_tasks

               plot_data <- data.frame(
                   category = c("Late", "On Time"),
                   task_data = c(plan_late_tasks,
                                 plan_not_late_tasks)
               )
           },
           "assigned_to" = {
               plot_data <- planner[[3]] %>%
                  dplyr::group_by(`Assigned To`) %>%
                  dplyr::summarize(n) %>%
                  setNames(c("category", "task_data"))
           },
           "completed_by" = {
               plot_data <- planner[[3]] %>%
                  dplyr::group_by(`Completed By`) %>%
                  dplyr::summarize(n) %>%
                  setNames(c("category", "task_data"))
           }
    )

    # Prepare for plotting (fractional)
    plot_data$fraction <- plot_data$task_data / sum(plot_data$task_data)
    plot_data <- plot_data[order(plot_data$fraction), ]
    plot_data$ymax <- cumsum(plot_data$fraction)
    plot_data$ymin <- c(0, head(plot_data$ymax, n = -1))

    if(data_only) {
        return(plot_data)
    }

    gg <- ggplot2::ggplot(plot_data, 
                          aes(
                              ymax = ymax,
                              ymin = ymin,
                              xmax = 4,
                              xmin = 3,
                              fill = category
                          )
        )

    if(basic_plot) {
        return(gg + labs(...))
    }

    gg <- gg +
          geom_rect() +
          coord_polar(theta = "y") +
          xlim(c(0,4)) +
          theme_void() +
          labs(...)
    
    return(gg)
}