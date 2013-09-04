graphic = new Object
data = new Object
stopwords = ["a","about","above","across","after","again","against","all","almost","alone","along","already","also","although","always","among","an","and","another","any","anybody","anyone","anything","anywhere","are","area","areas","around","as","ask","asked","asking","asks","at","away","b","back","backed","backing","backs","be","became","because","become","becomes","been","before","began","behind","being","beings","best","better","between","big","both","but","by","c","came","can","cannot","case","cases","certain","certainly","clear","clearly","come","could","d","did","differ","different","differently","do","does","done","down","down","downed","downing","downs","during","e","each","early","either","end","ended","ending","ends","enough","even","evenly","ever","every","everybody","everyone","everything","everywhere","f","face","faces","fact","facts","far","felt","few","find","finds","first","for","four","from","full","fully","further","furthered","furthering","furthers","g","gave","general","generally","get","gets","give","given","gives","going","good","goods","got","great","greater","greatest","group","grouped","grouping","groups","h","had","has","have","having","he","her","here","herself","high","high","high","higher","highest","him","himself","his","how","however","i","if","important","in","interest","interested","interesting","interests","into","is","it","its","itself","j","just","k","keep","keeps","kind","knew","know","known","knows","l","large","largely","last","later","latest","least","less","let","lets","like","likely","long","longer","longest","m","made","make","making","man","many","may","me","member","members","men","might","more","most","mostly","mr","mrs","much","must","my","myself","n","necessary","need","needed","needing","needs","never","new","new","newer","newest","next","no","nobody","non","noone","not","nothing","now","nowhere","number","numbers","o","of","off","often","old","older","oldest","on","once","one","only","open","opened","opening","opens","or","order","ordered","ordering","orders","other","others","our","out","over","p","part","parted","parting","parts","per","perhaps","place","places","point","pointed","pointing","points","possible","present","presented","presenting","presents","problem","problems","put","puts","q","quite","r","rather","really","right","right","room","rooms","s","said","same","saw","say","says","second","seconds","see","seem","seemed","seeming","seems","sees","several","shall","she","should","show","showed","showing","shows","side","sides","since","small","smaller","smallest","so","some","somebody","someone","something","somewhere","state","states","still","still","such","sure","t","take","taken","than","that","the","their","them","then","there","therefore","these","they","thing","things","think","thinks","this","those","though","thought","thoughts","three","through","thus","to","today","together","too","took","toward","turn","turned","turning","turns","two","u","under","until","up","upon","us","use","used","uses","v","very","w","want","wanted","wanting","wants","was","way","ways","we", "we’re","well","wells","went","were","what","when","where","whether","which","while","who","whole","whose","why","will","with","within","without","work","worked","working","works","would","x","y","year","years","yet","you", "you’re","young","younger","youngest","your","yours","z"]
languages = ["coffeescript","ruby","python","tex","javascript","java","groovy","scss","c++","php","haskell","erlang","markdown","scss","nemerle","objectivec","scala","cs","actionscript","applescript","bash","clojure","cmake","d","delphi","dos","go","ini","lisp","lua","mel","perl","r","rust","sql","vala","vbscript","vhdl"]

graphic.create = (wordsToVisualize)->
  fill = d3.scale.category20
  tooltip = CustomTooltip("tooltip", 240)

  draw = (words)->
    console.log words
    d3.select("#graphic")
    .append("svg")
      .attr("width", 1000)
      .attr("height", 1000)
        .append("g")
        .attr("transform", "translate(500,500)")
        .selectAll("text")
        .data(words)
        .enter().append("text")
        .style("font-size", (d) -> return d.size + "px")
        .style("fill", (d, i) -> return fill(i))
        .attr("text-anchor", "middle")
        .attr("transform", 
           (d) ->
             return "translate(" + [d.x, d.y] + ")rotate(" + d.rotate + ")"
        )
        .text((d) -> return d.text)
        .attr("class", "keywords")
        .on("mouseover", ()->
          d3.select(@).style("fill","red")
          showDetails(@)
          )
        .on("mouseout", ()->
          d3.select(@).style("fill","black")
          hideDetails(@)
          )

  showDetails = (element) =>
    d3.select(element).attr("stroke", "yellow")
    content = "<div class='tooltip title'>Sources</div>"
    tooltip.showTooltip(content,d3.event)

  hideDetails = (element) =>
    d3.select(element).attr("stroke", "none")
    tooltip.hideTooltip()

  d3.layout.cloud().size([1000, 1000])
  .words(wordsToVisualize)
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

graphic.update = ()->

graphic.destroy = ()->
  $("#graphics svg").remove()
  $("#graphic").empty()

data.toWordsArray = (dataObj, startDate) ->

  console.log startDate
  wordArr = []

  for i in [startDate.month..startDate.month+2] by 1
    for j in [1..31] by 1
      i = ('0' + j).slice(-2)
      if dataObj[startDate.year][i]
        j = ('0' + j).slice(-2)
        if dataObj[startDate.year][i][j]
          onedayexample = dataObj[startDate.year][i][j]
          for o in onedayexample
            wordArr = wordArr.concat o.title.split(" ")

  # console.log wordArr
  console.log wordArr.length
  wordArr = _.difference(wordArr.map((d)-> d.toLowerCase()), stopwords)
  wordArr = wordArr.reduce(
    (acc, curr) ->
      if (typeof acc[curr] == 'undefined')
        acc[curr] = 1;
      else
        acc[curr] += 1;
      acc;
  ,{});
  wordArr = _.map(wordArr, (num, key)-> 
    if _.contains(languages, key)
      num = num*2
    {text:key, size:10+num*2}
    );
  wordArr

$(document).ready ()->
  d3.json "data.json", (dataObj)->
    $( "#from" ).datepicker(
      # defaultDate: new Date(2010, 10, 10),
      minDate: new Date(2010, 10, 10),
      maxDate: new Date(2013, 7, 20),
      changeMonth: true,
      changeYear: true,
      numberOfMonths: 3,
      dateFormat: 'mm/yy'
      )

    $(".dd").change(
      () ->
        if $("#from").val()
          @fromArr = $("#from").val().split("/")
          # @toArr = $("#to").val().split("/")
          graphic.destroy()
          @w = data.toWordsArray dataObj,
            {
              year: @fromArr[1],
              month: parseInt(@fromArr[0],10),
              }
          $("#graphicLabel").text("Trends on HN from month "+parseInt(@fromArr[0],10)+" to "+ (parseInt(@fromArr[0],10)+2));
          graphic.create(@w)
      )
