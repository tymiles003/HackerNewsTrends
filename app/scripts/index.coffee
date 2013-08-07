graphic = new Object
data = new Object
graphic.create = ()->
  width = $(document).width()/2
  height = $(document).height()*.85
  size = d3.min([width,height])
  graphic.svg = d3.select("#graphic")
    .append("svg")
      .attr("width",size)
      .attr("height",size)

  g = graphic.svg.append("g")

  for i in _.range(size/10)
    graphic.svg.append("rect")
      .attr("width",size-i*10)
      .attr("height",size-i*10)
      .attr("fill",if i%2 is 0 then "black" else "white")

graphic.update = ()->

graphic.destroy = ()->
  graphic.svg.remove()
  delete graphic.svg

data.toWordsArray = () ->

$(document).ready ()->
  graphic.create()
  d3.json "data.json", (data)->
    data = data
    console.log("data type: " + typeof data)

  $(window).resize ()->
    graphic.destroy()
    graphic.create()
