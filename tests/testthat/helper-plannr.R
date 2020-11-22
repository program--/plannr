# Control Data ------------------------------------------------
control_data_read <- list()
control_data_read$plan_name <- "Test Plan"
control_data_read$export_date <- "10/06/2020"
control_data_read$data <- readr::read_csv("../testdata/test_plan.csv") %>%
                          setNames(preferred_colnames) %>%
                          hablar::convert(
                              hablar::chr(Start.Date, Late, Description, Labels)
                          )

control_data_read$data[11] <- lapply(control_data_read$data[11], tolower)

control_data_filter      <- control_data_read
control_data_filter$plan_name <- paste0(
                                    control_data_filter$plan_name,
                                    " (Filtered)"
                                 )
control_data_filter$data <- control_data_filter$data %>%
                            setNames(preferred_colnames) %>%
                            dplyr::filter(
                                Progress == "Not started",
                                Assigned.To == "Other Person 2"
                            )

# Test Data ---------------------------------------------------
test_data_read <- plannr::read_planner("../testdata/test_plan.xlsx")

test_data_filter <- plannr::filter_planner(
                        test_data_read,
                        Progress == "Not started",
                        Assigned.To == "Other Person 2"
                    )