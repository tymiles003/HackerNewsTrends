graphic = new Object
data = new Object
stopwords = ["a","about","above","across","after","again","against","all","almost","alone","along","already","also","although","always","among","an","and","another","any","anybody","anyone","anything","anywhere","are","area","areas","around","as","ask","asked","asking","asks","at","away","b","back","backed","backing","backs","be","became","because","become","becomes","been","before","began","behind","being","beings","best","better","between","big","both","but","by","c","came","can","cannot","case","cases","certain","certainly","clear","clearly","come","could","d","did","differ","different","differently","do","does","done","down","down","downed","downing","downs","during","e","each","early","either","end","ended","ending","ends","enough","even","evenly","ever","every","everybody","everyone","everything","everywhere","f","face","faces","fact","facts","far","felt","few","find","finds","first","for","four","from","full","fully","further","furthered","furthering","furthers","g","gave","general","generally","get","gets","give","given","gives","going","good","goods","got","great","greater","greatest","group","grouped","grouping","groups","h","had","has","have","having","he","her","here","herself","high","high","high","higher","highest","him","himself","his","how","however","i","if","important","in","interest","interested","interesting","interests","into","is","it","its","itself","j","just","k","keep","keeps","kind","knew","know","known","knows","l","large","largely","last","later","latest","least","less","let","lets","like","likely","long","longer","longest","m","made","make","making","man","many","may","me","member","members","men","might","more","most","mostly","mr","mrs","much","must","my","myself","n","necessary","need","needed","needing","needs","never","new","new","newer","newest","next","no","nobody","non","noone","not","nothing","now","nowhere","number","numbers","o","of","off","often","old","older","oldest","on","once","one","only","open","opened","opening","opens","or","order","ordered","ordering","orders","other","others","our","out","over","p","part","parted","parting","parts","per","perhaps","place","places","point","pointed","pointing","points","possible","present","presented","presenting","presents","problem","problems","put","puts","q","quite","r","rather","really","right","right","room","rooms","s","said","same","saw","say","says","second","seconds","see","seem","seemed","seeming","seems","sees","several","shall","she","should","show","showed","showing","shows","side","sides","since","small","smaller","smallest","so","some","somebody","someone","something","somewhere","state","states","still","still","such","sure","t","take","taken","than","that","the","their","them","then","there","therefore","these","they","thing","things","think","thinks","this","those","though","thought","thoughts","three","through","thus","to","today","together","too","took","toward","turn","turned","turning","turns","two","u","under","until","up","upon","us","use","used","uses","v","very","w","want","wanted","wanting","wants","was","way","ways","we", "we’re","well","wells","went","were","what","when","where","whether","which","while","who","whole","whose","why","will","with","within","without","work","worked","working","works","would","x","y","year","years","yet","you", "you’re","young","younger","youngest","your","yours","z"]
languages = ["coffeescript","ruby","python","tex","javascript","java","groovy","scss","c++","php","haskell","erlang","markdown","scss","nemerle","objectivec","scala","cs","actionscript","applescript","bash","clojure","cmake","d","delphi","dos","go","ini","lisp","lua","mel","perl","r","rust","sql","vala","vbscript","vhdl"]

graphic.create = (wordsToVisualize)->
  fill = d3.scale.category20

  draw = (words)->
    console.log words
    d3.select("#graphic").append("svg")
    .attr("width", 1500)
    .attr("height", 1500)
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

  d3.layout.cloud().size([1500, 1500])
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

data.toWordsArray = (dataObj) ->
  year = _.keys dataObj
  wordArr = []
  console.log year
  onedayexample = dataObj["2012"]["10"]["11"]
  for i in onedayexample
    wordArr = wordArr.concat i.title.split(" ")
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
      num = num*10
    {text:key, size:20+num*5}
    );
  console.log wordArr
  wordArr

$(document).ready ()->
  d3.json "data.json", (dataObj)->
    @w = data.toWordsArray dataObj
    console.log @w
    graphic.create(@w)     

$(window).resize ()->
    # graphic.destroy()
    # graphic.create()
