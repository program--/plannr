#' @title Plot or get plottable data from Planner
#' @description Allows the ability to quickly
#'              filter plottable data by column or
#'              directly plot with \code{ggplot2}/\code{plotly}.
#' @param planner Planner data returned from read_planner()
#' @param by Column to filter planner data by.
#'           Either: "tasks", "checklists", "priority",
#'                   "late", "assigned_to", or "completed_by"
#' @param data_only If \code{TRUE}, makes function return plottable data as a tibble.
#' @param plot_type Character of plot type. Supports: \code{NA}, \code{basic}.
#' @param interactive If \code{TRUE}, returns a \code{plotly} interactive plot.
#' @param \dots Extra arguments for ggplot labs()
#' @return Either plottable data as a \code{tibble}, \code{ggplot} object, or \code{plotly} object.
#' @examples
#' \dontrun{
#'      ## Basic Usage
#'      plot_planner(plan_xlsx, by = "checklists")
#'
#'      ## Filtered Plottable Plan Data
#'      plot_planner(plan_xlsx, by = "priority", data_only = TRUE)
#'
#'      ## Extended with ggplot2
#'      plot_planner(
#'          plan_xlsx,
#'          by = "tasks",
#'          plot_type = "basic",
#'          title = "Tasks Progress"
#'      ) +
#'      geom_bar() +
#'      theme_bw()
#'
#'     ## Extended with plotly
#'     plot_planner(
#'         plan_xlsx,
#'         by = "checklists",
#'         interactive = TRUE,
#'         title = "Interactive Donut Chart"
#'     )
#' }
#' @import ggplot2
#' @import dplyr
#' @importFrom magrittr %>%
#' @importFrom stringr str_sub
#' @importFrom utils head
#' @rawNamespace import(plotly, except = last_plot)
#' @export

plot_planner <- function(planner, by = "tasks",
                         data_only = FALSE,
                         plot_type = NA,
                         interactive = FALSE,
                         ...) {

    # Exception
    if (class(planner) != "plannr") {
        message(paste0(deparse(substitute(planner))), " not of class `plannr`. Reading as `plannr`...")
        planner <- plannr::read_planner(planner)
    }

    # Instantiate variable
    plot_data <- NA

    # Switch type of plot
    switch(tolower(by),
           "tasks" = {
               plot_data <- data.frame(
                   category  = c("Not Started", "In Progress", "Completed"),
                   task_data = c(planner$tasks$Not.Started,
                                 planner$tasks$In.Progress,
                                 planner$tasks$Completed)
               )
           },
           "checklists" = {
               plot_data <- data.frame(
                   category  = c("Not Started", "Completed"),
                   task_data = c(planner$checklists$Not.Started,
                                 planner$checklists$Completed
                   )
               )
           },
           "priority" = {
               plot_data <- data.frame(
                   category  = c("Urgent", "Important", "Medium", "Low"),
                   task_data = c(planner$priority$Urgent,
                                 planner$priority$Important,
                                 planner$priority$Medium,
                                 planner$priority$Low
                   )
               )
           },
           "late" = {
               plot_data <- data.frame(
                   category  = c("Late", "On.Time"),
                   task_data = c(planner$tasks$Late,
                                 planner$tasks$Total - planner$tasks$Late)
               )
           },
           "assigned_to" = {
               plot_data <- planner$assignment %>%
                            setNames(c("category", "task_data"))
           },
           "completed_by" = {
               plot_data <- planner$completion %>%
                            setNames(c("category", "task_data"))
           }
    )

    # Prepare for plotting (fractional)
    plot_data$fraction <- plot_data$task_data / sum(plot_data$task_data)
    plot_data          <- plot_data[order(plot_data$fraction), ]
    plot_data$ymax     <- cumsum(plot_data$fraction)
    plot_data$ymin     <- c(0, head(plot_data$ymax, n = -1))

    if (data_only) {
        return(plot_data)
    }

    gg <- ggplot2::ggplot(plot_data,
                          ggplot2::aes(
                              ymax = .data$ymax,
                              ymin = .data$ymin,
                              xmax = 4,
                              xmin = 3,
                              fill = .data$category
                          )
        )

    if (!is.na(plot_type) & plot_type == "basic") {
        final_plot <- gg + ggplot2::labs(...)
    } else if (!interactive & is.na(plot_type)) {
        final_plot <- gg +
                      geom_rect() +
                      coord_polar(theta = "y") +
                      xlim(c(0, 4)) +
                      theme_void() +
                      labs(...)
    }

    if (interactive & !is.na(plot_type)) {
        final_plot <- plotly::ggplotly(final_plot)
    } else if (interactive) {
        final_plot <- plotly::plot_ly(plot_data, labels = ~category, values = ~task_data) %>%
                      plotly::add_pie(hole = 0.5) %>%
                      plotly::layout(
                          xaxis = list(
                              showgrid = FALSE,
                              zeroline = FALSE,
                              showticklabels = FALSE
                          ),
                          yaxis = list(
                              showgrid = FALSE,
                              zeroline = FALSE,
                              showticklabels = FALSE
                          ),
                          ...
                      )
    }

    return(final_plot)
}