return {
  {
    "mattn/calendar-vim",
    init = function()
      vim.g.calendar_options = "nornu" --allow calendar to be full width
      vim.g.calendar_monday = 1 --make calendar start on mondays
      vim.g.calendar_number_of_months = 6 --pretty much self explanatory lol
    end,
  },
}
