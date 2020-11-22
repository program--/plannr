test_that("Planner is read correctly", {
  expect_s3_class(test_data_read, "plannr")

  expect_true(test_data_read$plan_name == control_data_read$plan_name)

  expect_true(test_data_read$export_date == control_data_read$export_date)

  expect_true(dplyr::all_equal(test_data_read$data, control_data_read$data))

  expect_error(plannr::read_planner(NA))

  expect_output(summary(test_data_read))

  expect_output(print(test_data_read))
})

test_that("Planner is filtered correctly", {
  expect_s3_class(test_data_filter, "plannr")

  expect_true(test_data_filter$plan_name == control_data_filter$plan_name)

  expect_true(test_data_filter$export_date == control_data_filter$export_date)

  expect_true(dplyr::all_equal(test_data_filter$data, control_data_filter$data))
})

test_that("Planner plotting function returns correctly", {
  # ggplot2
  expect_s3_class(
    plot_planner(test_data_read),
    c("gg", "ggplot")
  )

  expect_s3_class(
    plot_planner(test_data_read, by = "checklists"),
    c("gg", "ggplot")
  )

  expect_s3_class(
    plot_planner(test_data_read, by = "priority"),
    c("gg", "ggplot")
  )

  expect_s3_class(
    plot_planner(test_data_read, by = "late"),
    c("gg", "ggplot")
  )

  expect_s3_class(
    plot_planner(test_data_read, by = "assigned_to"),
    c("gg", "ggplot")
  )

  expect_s3_class(
    plot_planner(test_data_read, by = "completed_by"),
    c("gg", "ggplot")
  )

  # plotly
  expect_s3_class(
    plot_planner(test_data_read, interactive = TRUE),
    c("plotly", "htmlwidget")
  )

  expect_s3_class(
    plot_planner(test_data_read, interactive = TRUE, by = "checklists"),
    c("plotly", "htmlwidget")
  )

  expect_s3_class(
    plot_planner(test_data_read, interactive = TRUE, by = "priority"),
    c("plotly", "htmlwidget")
  )

  expect_s3_class(
    plot_planner(test_data_read, interactive = TRUE, by = "late"),
    c("plotly", "htmlwidget")
  )

  expect_s3_class(
    plot_planner(test_data_read, interactive = TRUE, by = "assigned_to"),
    c("plotly", "htmlwidget")
  )

  expect_s3_class(
    plot_planner(test_data_read, interactive = TRUE, by = "completed_by"),
    c("plotly", "htmlwidget")
  )

  # data.frame
  expect_s3_class(
    plot_planner(test_data_read, data_only = TRUE),
    "data.frame"
  )

  expect_s3_class(
    plot_planner(test_data_read, data_only = TRUE, by = "checklists"),
    "data.frame"
  )

  expect_s3_class(
    plot_planner(test_data_read, data_only = TRUE, by = "priority"),
    "data.frame"
  )

  expect_s3_class(
    plot_planner(test_data_read, data_only = TRUE, by = "late"),
    "data.frame"
  )

  expect_s3_class(
    plot_planner(test_data_read, data_only = TRUE, by = "assigned_to"),
    "data.frame"
  )

  expect_s3_class(
    plot_planner(test_data_read, data_only = TRUE, by = "completed_by"),
    "data.frame"
  )
})