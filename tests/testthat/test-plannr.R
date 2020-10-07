test_that("Planner is read correctly", {
  expect_true(test_data_read[[1]] == control_data_read[[1]])

  expect_true(test_data_read[[2]] == control_data_read[[2]])

  expect_true(dplyr::all_equal(test_data_read[[3]], control_data_read[[3]]))
})

test_that("Planner is filtered correctly", {
  expect_true(test_data_filter[[1]] == control_data_filter[[1]])

  expect_true(test_data_filter[[2]] == control_data_filter[[2]])

  expect_true(dplyr::all_equal(test_data_filter[[3]], control_data_filter[[3]]))
})
