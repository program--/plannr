library(tidyverse)

# Control Data ------------------------------------------------
control_data_read <- list()
control_data_read[[1]] <- "Test Plan"
control_data_read[[2]] <- "10/06/2020"
control_data_read[[3]] <- readr::read_csv(system.file("inst","testdata","test_plan.csv", package="plannr")) %>%
  convert(chr(`Start Date`, Late, Description, Labels))
control_data_read[[3]][11] <- sapply(control_data_read[[3]][11], tolower)

control_data_filter <- control_data_read
control_data_filter[[3]] <- control_data_filter[[3]] %>%
  dplyr::filter(Progress == "Not started", `Assigned To` == "Other Person 2")

# Test Data ---------------------------------------------------
test_data_read <- plannr::read_planner(system.file("inst","testdata","test_plan.xlsx", package="plannr"))

test_data_filter <- plannr::filter_planner(test_data_read, Progress == "Not started", `Assigned To` == "Other Person 2")