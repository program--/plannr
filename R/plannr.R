#' @title Print
#' @description Print method for `plannr` class
#' @param x Object of class `plannr`
#' @param \dots further arguments passed to or from other methods
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
print.plannr <- function(x, ...) {
    orange <- crayon::make_style("darkorange3")
    cat(orange("=======>> PLANNER <<=======\n"))
    cat(paste0(
        crayon::bold("   Plan Name: "),
        crayon::cyan(x$plan_name),
        "\n"
    ))
    cat(paste0(
        crayon::bold(" Export Date: "),
        crayon::cyan(x$export_date),
        "\n"
    ))
    cat(orange("===========================\n"))
}

#' @title Summary
#' @description Summary method for `plannr` class
#' @param object Object of class `plannr`
#' @param \dots further arguments passed to or from other methods
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
summary.plannr <- function(object, ...) {
    orange <- crayon::make_style("darkorange3")
    cat(orange("=======>> PLANNER <<=======\n"))
    cat(paste0(
        crayon::bold("   Plan Name: "),
        crayon::cyan(object$plan_name),
        "\n"
    ))
    cat(paste0(
        crayon::bold(" Export Date: "),
        crayon::cyan(object$export_date),
        "\n"
    ))

    cat(orange("========>> TASKS <<========\n"))
    cat(paste0(
        crayon::bold("      Total: "),
        crayon::underline(object$tasks$Total, "Tasks\n")
    ))
    cat(paste0(
        crayon::bold("  Completed: "),
        crayon::green(object$tasks$Completed),
        paste(rep(" ", 5 - nchar(object$tasks$Completed)), collapse = ""),
        crayon::green(paste0(
            "(",
            formatC(
                object$tasks$Completed  / object$tasks$Total * 100,
                digits = 2,
                format = "f"
            ),
            "%)\n"
        ))
    ))
    cat(paste0(
        crayon::bold("In Progress: "),
        crayon::yellow(object$tasks$In.Progress),
        paste(rep(" ", 5 - nchar(object$tasks$In.Progress)), collapse = ""),
        crayon::yellow(paste0(
            "(",
            formatC(
                object$tasks$In.Progress / object$tasks$Total * 100,
                digits = 2,
                format = "f"
            ),
            "%)\n"
        ))
    ))
    cat(paste0(
        crayon::bold("Not Started: "),
        crayon::red(object$tasks$Not.Started),
        paste(rep(" ", 5 - nchar(object$tasks$Not.Started)), collapse = ""),
        crayon::red(paste0(
            "(",
            formatC(
                object$tasks$Not.Started / object$tasks$Total * 100,
                digits = 2,
                format = "f"
            ),
            "%)\n"
        ))
    ))

    cat(orange("===>> CHECKLIST TASKS <<===\n"))
    cat(paste0(
        crayon::bold("      Total:",
        crayon::underline(object$checklists$Total, "Tasks\n"))
    ))
    cat(paste0(
        crayon::bold("  Completed: "),
        crayon::green(object$checklists$Completed),
        paste(rep(" ", 5 - nchar(object$checklists$Completed)), collapse = ""),
        crayon::green(paste0(
            "(",
            formatC(
                object$checklists$Completed  / object$checklists$Total * 100,
                digits = 2,
                format = "f"
            ),
            "%)\n"
        ))
    ))
    cat(paste0(
        crayon::bold("Not Started: "),
        crayon::red(object$checklists$Not.Started),
        paste(rep(" ", 5 - nchar(object$checklists$Not.Started)), collapse = ""),
        crayon::red(paste0(
            "(",
            formatC(
                object$checklists$Not.Started / object$checklists$Total * 100,
                digits = 2,
                format = "f"
            ),
            "%)\n"))
    ))
    cat(orange("===========================\n\n"))
}