# <img src="man/figures/logo.png" alt="R Planner Parser" width=75% />

**R Planner Parser (RPLP)** is an in-development package used for parsing Microsoft Planner data into R via exported Excel spreadsheets to create beautiful **ggplot** graphs.

Usage of RPLP is farily simple:

1. Open your planner in the Microsoft Planner web application.
2. Export plan to Excel (as `.xlsx`).
3. Read using RPLP's `read_planner()` function.

Now you have your Planner data in *tibble* form!

### Plotting with RPLP
Using the `plot_planner()` function, you can quickly create a **donut chart** using `ggplot` to your specifications. `plot_planner()` supports filtering by:

- `tasks`: Tasks (w/o Checklists)
- `checklists`: Tasks (w/ Checklists)
- `priority`: Priority
- `late`: Late Tasks
- `assigned_to`: Assigned To
- `completed_by`: Completed By

#### Examples:

**Basic Usage**

```r
# Print a donut plot taking into account checklists on tasks
plan_xlsx <- read_planner("path/to/planner.xlsx")

plot_planner(plan_xlsx, by = "checklists")
```

**Getting *filtered* plot data**

```r
# Return a easy-plottable-tibble of the planner data filtered by priority
plot_planner(plan_xlsx, by = "priority", data_only = TRUE)
```

**Extending with `ggplot`**

```r
# Easy customizability via `basic_plot` argument.
#
# labs() parameters can be added to the end of the argument list
# for plot_planner() calls.
plot_planner(plan_xlsx,
             by = "tasks",
             basic_plot = TRUE,
             title = "Tasks Progress"
) +
    geom_bar() +
    theme_bw()
```

### Using dplyr with Planner data

Currently there's two supported ways of using `dplyr` functions via RPLP.

1. Using `filter_planner()` for `dplyr::filter()`.
2. Using `plot_planner(..., data_only = TRUE, ...)` with `tidyverse` piping.