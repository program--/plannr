#' @title Get Planner Data
#' @description Read in Microsoft Planner data from .xlsx file
#' @param xlsx A Microsoft Excel spreadsheet exported from Planner
#' @param plan_name String of preferred plan name. If `NA`, name of planner will be used.
#' @param plan_date String of preferred plane date. If `NA`, export date of planner will be used.
#' @return A list of plan name, plan export date, and tibble of plan data
#' @examples
#' \dontrun{
#' ## Basic Usage
#'      read_planner("path/to/planner.xlsx")
#' }
#' @importFrom stats setNames
#' @importFrom magrittr %>%
#' @export

read_planner <- function(xlsx, plan_name = NA, plan_date = NA) {
    if (class(xlsx) == "character") {
        # Read .xlsx
        plan_data <- tryCatch({
            readxl::read_excel(xlsx)
        },
        error = function(cond) {
            message(cond, "\n")
            stop("Couldn't read planner. Is it a .xlsx?\n")
        })

        # Read Planner Name
        plan_name <- ifelse(is.na(plan_name), names(plan_data[2]), plan_name)

        # Read Planner Export Date
        plan_date <- ifelse(is.na(plan_date), plan_data[[2]][2], plan_date)

        # Change tibble column names to
        filtered_data <- setNames(plan_data, preferred_colnames)
        filtered_data <- filtered_data[-c(1:4), ]

    } else if (class(xlsx) == "list") {
        if (!identical(names(xlsx$data), planner_colnames) & !identical(names(xlsx$data), preferred_colnames)) {
            warning(paste0(
                deparse(substitute(xlsx)),
                " column names do not match planner/preferred names."
            ))
        }

        plan_name     <- ifelse(is.na(plan_name), xlsx$plan_name, plan_name)
        plan_date     <- ifelse(is.na(plan_date), xlsx$plan_date, plan_date)
        filtered_data <- xlsx$data %>%
                         setNames(preferred_colnames)

    } else if (class(xlsx) == "data.frame") {
        if (!identical(names(xlsx), planner_colnames) & !identical(names(xlsx), preferred_colnames)) {
            warning(paste0(
                deparse(substitute(xlsx)),
                " column names do not match planner/preferred names."
            ))
        }

        plan_name <- plan_name
        plan_date <- plan_date
        filtered_data <- xlsx %>%
                         setNames(preferred_colnames)

    } else if (class(xlsx) == "plannr") {
        plan_name     <- xlsx$plan_name
        plan_date     <- xlsx$export_date
        filtered_data <- xlsx$data
    }
    else {
        stop(
            paste0(
                "`",
                deparse(substitute(xlsx)),
                "`",
                "passed to `read_planner()` is not of class ",
                "`character`, `list`, `data.frame`, or `plannr`."
            )
        )
    }

    # Create Planner Class
    planner <- list()
    planner$plan_name   <- plan_name
    planner$export_date <- plan_date
    planner$data        <- filtered_data

    # Add specific attributes
    planner$tasks <- data.frame(
                         Total       = length(filtered_data[[4]]),
                         Completed   = sum(filtered_data[[4]] == "Completed"),
                         In.Progress = sum(filtered_data[[4]] == "In progress"),
                         Not.Started = sum(filtered_data[[4]] == "Not started"),
                         Late        = sum(filtered_data$Late == "true")
                     )

    planner$buckets <- length(unique(filtered_data[[3]]))

    planner$checklists <- data.frame(
                              Total       = sum(as.numeric(sub(".*\\/", "", as.data.frame(filtered_data[15])[[1]])), na.rm = TRUE),
                              Completed   = sum(as.numeric(stringr::str_sub(sub("\\/.*", "", as.data.frame(filtered_data[15])[[1]]), start = 1)), na.rm = TRUE)
                          ) %>%
                          dplyr::mutate(Not.Started = Total - Completed)

    planner$priority <- data.frame(
                            Urgent    = sum(filtered_data[[5]] == "Urgent"),
                            Important = sum(filtered_data[[5]] == "Important"),
                            Medium    = sum(filtered_data[[5]] == "Medium"),
                            Low       = sum(filtered_data[[5]] == "Low")
                        )

    planner$assignment  <- dplyr::count(filtered_data, Assigned.To) %>%
                           dplyr::rename(Tasks = n)

    planner$completion  <- dplyr::count(filtered_data, Completed.By) %>%
                           dplyr::rename(Tasks = n)

    # Make plannr class
    class(planner) <- "plannr"

    # Return organized Planner data
    planner
}