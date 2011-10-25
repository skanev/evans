# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  renderColumnChart = (tableSelector, target) ->
    table   = $(tableSelector)
    caption = table.find('caption').text()
    yAxis   = table.find('thead th:eq(1)').text()
    data    = []

    table.find('tbody tr').each ->
      row = $(this)
      data.push [row.find('td:eq(0)').text(), parseInt(row.find('td:eq(1)').text(), 10)]

    new Highcharts.Chart
      chart:
        renderTo: target
        defaultSeriesType: 'column'
        type: 'column'
      title:
        text: caption
      xAxis:
        categories: (row[0] for row in data)
      yAxis:
        min: 0
        title:
          text: yAxis
      legend:
        enabled: false
      tooltip:
        formatter: ->
          pluralized = if this.y is 1 then 'решение' else 'решения'
          "#{this.y} #{pluralized}"
      series: [
        data: (row[1] for row in data)
      ]

  renderColumnChart '#task-metrics .passed-tests', 'passed-tests-chart'
  renderColumnChart '#task-metrics .submission-day', 'submission-day-chart'
