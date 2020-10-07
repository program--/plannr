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
               plan_completed_tasks <- planner %>%
                   filter(`Progress` == "Completed") %>%
                   count()

               plan_in_progress_tasks <- planner %>%
                   filter(`Progress` == "In progress") %>%
                   count()

               plan_notstarted_tasks <- count(planner) - (plan_completed_tasks + plan_in_progress_tasks)

               plot_data <- data.frame(
                   category = c("Not Started", "In Progress", "Completed"),
                   task_data = c(plan_notstarted_tasks,
                                 plan_in_progress_tasks,
                                 plan_completed_tasks)
               )
           },
           "checklists" = {
               plan_completed_tasks <- 
                   stringr::str_sub(sub("\\/.*", "", as.data.frame(planner[15])[[1]]),
                                   start = 1) %>%
                   as.numeric() %>%
                   sum(na.rm = TRUE)
            
               plan_total_tasks <- 
                   sub(".*\\/", "", as.data.frame(planner[15])[[1]]) %>%
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
               plan_urgent_tasks <- filter(planner, `Priority` == "Urgent") %>%
                   count()
               plan_important_tasks <- filter(planner, `Priority` == "Important") %>%
                   count()
               plan_medium_tasks <- filter(planner, `Priority` == "Medium") %>%
                   count()
               plan_low_tasks <- filter(planner, `Priority` == "Low") %>%
                   count()

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
               plan_late_tasks <- filter(planner, `Late` == "true") %>%
                   count()

               plan_not_late_tasks <- count(planner) - plan_late_tasks

               plot_data <- data.frame(
                   category = c("Late", "On Time"),
                   task_data = c(plan_late_tasks,
                                 plan_not_late_tasks)
               )
           },
           "assigned_to" = {
               plot_data <- planner %>%
                  group_by(`Assigned To`) %>%
                  summarize(n) %>%
                  setNames(c("category", "task_data"))
           },
           "completed_by" = {
               plot_data <- planner %>%
                  group_by(`Completed By`) %>%
                  summarize(n) %>%
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

    gg <- ggplot(plot_data, 
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