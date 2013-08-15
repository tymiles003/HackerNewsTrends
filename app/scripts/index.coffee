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

data.toWordsArray = (dataObj) ->
  year = _.keys dataObj
  wordArr = []
  console.log year
  onedayexample = dataObj["2011"]["10"]["10"]
  for i in onedayexample
    wordArr = _.union wordArr, i.title.split(" ")
    console.log wordArr
  wordArr

$(document).ready ()->
  # graphic.create()
  d3.json "data.json", (dataObj)->
    # data = data
    wordsToVisualize = data.toWordsArray dataObj
    fill = d3.scale.category20

    draw = (words)->
      console.log words
      d3.select("#graphic").append("svg")
      .attr("width", 500)
      .attr("height", 500)
      .append("g")
      .attr("transform", "translate(150,150)")
      .selectAll("text")
      .data(words)
      .enter().append("text")
      .style("font-size", (d) -> return d.size + "px")
      .style("font-family", "Impact")
      .style("fill", (d, i) -> return fill(i))
      .attr("text-anchor", "middle")
      .attr("transform", 
         (d) ->
           return "translate(" + [d.x, d.y] + ")rotate(" + d.rotate + ")"
      )
      .text((d) -> return d.text);

    d3.layout.cloud().size([300, 300])
    .words(
      wordsToVisualize.map(
        (d)->
          {text: d, size: 10 + Math.random() * 90}
      ))
      .padding(5)
      .rotate(
        () -> 
          return ~~(Math.random() * 2) * 90
      )
      .font("Impact")
      .fontSize(
        (d) -> 
          d.size
      )
      .on("end", draw)
      .start()
     

  $(window).resize ()->
    graphic.destroy()
    graphic.create()
