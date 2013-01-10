$(document).ready ->
  renderPollsChart = ->
    $('.js-chart').each ->
      container = $(this)

      data = new google.visualization.DataTable()
      data.addColumn 'string', 'Отговор'
      data.addColumn 'number', 'Пъти избран'
      data.addRows container.data('source')

      chartType = {
        column: google.visualization.ColumnChart,
        pie: google.visualization.PieChart,
      }[container.data('type')]

      chart = new chartType(this)
      chart.draw data,
        title: container.data('title')
        width: 600
        height: 400
        axisTitlesPosition: 'none'
        chartArea: {left: '5%', width: '95%', top: '5%', height: '80%'}
        legend: 'in'

  google.load 'visualization', '1.0', packages: ['corechart'], callback: ->
    renderPollsChart()
