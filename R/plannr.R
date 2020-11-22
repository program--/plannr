#' @title Print
#' @description Print method for `plannr` class
#' @param planner Object of class `plannr`
#' @return The planner name and export date.
#' @examples
#' \dontrun{
#'     ## Basic Usage
#'     planner <- read_planner("path/to/planner.xlsx")
#'     print(planner)
#' }
#' @importFrom crayon bold
#' @importFrom crayon cyan
#' @importFrom crayon make_style
#' @export

print.plannr <- function(planner) {
    orange <- crayon::make_style("darkorange3")
    cat(orange("=======>> PLANNER <<=======\n"))
    cat(paste0(
        crayon::bold("   Plan Name: "),
        crayon::cyan(planner$plan_name),
        "\n"
    ))
    cat(paste0(
        crayon::bold(" Export Date: "),
        crayon::cyan(planner$export_date),
        "\n"
    ))
    cat(orange("===========================\n"))
}

#' @title Summary
#' @description Summary method for `plannr` class
#' @param planner Object of class `plannr`
#' @return A summary of the planner.
#' @examples
#' \dontrun{
#'     ## Basic Usage
#'     planner <- read_planner("path/to/planner.xlsx")
#'     summary(planner)
#' }
#' @importFrom crayon bold
#' @importFrom crayon underline
#' @importFrom crayon red
#' @importFrom crayon yellow
#' @importFrom crayon green
#' @importFrom crayon make_style
#' @export

summary.plannr <- function(planner) {
    orange <- crayon::make_style("darkorange3")
    cat(orange("=======>> PLANNER <<=======\n"))
    cat(paste0(
        crayon::bold("   Plan Name: "),
        crayon::cyan(planner$plan_name),
        "\n"
    ))
    cat(paste0(
        crayon::bold(" Export Date: "),
        crayon::cyan(planner$export_date),
        "\n"
    ))

    cat(orange("========>> TASKS <<========\n"))
    cat(paste0(
        crayon::bold("      Total: "),
        crayon::underline(planner$tasks$Total, "Tasks\n")
    ))
    cat(paste0(
        crayon::bold("  Completed: "),
        crayon::green(planner$tasks$Completed),
        paste(rep(" ", 5 - nchar(planner$tasks$Completed)), collapse = ""),
        crayon::green(paste0(
            "(",
            formatC(
                planner$tasks$Completed  / planner$tasks$Total * 100,
                digits = 2,
                format = "f"
            ),
            "%)\n"
        ))
    ))
    cat(paste0(
        crayon::bold("In Progress: "),
        crayon::yellow(planner$tasks$In.Progress),
        paste(rep(" ", 5 - nchar(planner$tasks$In.Progress)), collapse = ""),
        crayon::yellow(paste0(
            "(",
            formatC(
                planner$tasks$In.Progress / planner$tasks$Total * 100,
                digits = 2,
                format = "f"
            ),
            "%)\n"
        ))
    ))
    cat(paste0(
        crayon::bold("Not Started: "),
        crayon::red(planner$tasks$Not.Started),
        paste(rep(" ", 5 - nchar(planner$tasks$Not.Started)), collapse = ""),
        crayon::red(paste0(
            "(",
            formatC(
                planner$tasks$Not.Started / planner$tasks$Total * 100,
                digits = 2,
                format = "f"
            ),
            "%)\n"
        ))
    ))

    cat(orange("===>> CHECKLIST TASKS <<===\n"))
    cat(paste0(
        crayon::bold("      Total:",
        crayon::underline(planner$checklists$Total, "Tasks\n"))
    ))
    cat(paste0(
        crayon::bold("  Completed: "),
        crayon::green(planner$checklists$Completed),
        paste(rep(" ", 5 - nchar(planner$checklists$Completed)), collapse = ""),
        crayon::green(paste0(
            "(",
            formatC(
                planner$checklists$Completed  / planner$checklists$Total * 100,
                digits = 2,
                format = "f"
            ),
            "%)\n"
        ))
    ))
    cat(paste0(
        crayon::bold("Not Started: "),
        crayon::red(planner$checklists$Not.Started),
        paste(rep(" ", 5 - nchar(planner$checklists$Not.Started)), collapse = ""),
        crayon::red(paste0(
            "(",
            formatC(
                planner$checklists$Not.Started / planner$checklists$Total * 100,
                digits = 2,
                format = "f"
            ),
            "%)\n"))
    ))
    cat(orange("===========================\n\n"))
}