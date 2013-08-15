(function() {
  var data, graphic;

  graphic = new Object;

  data = new Object;

  graphic.create = function() {
    var g, height, i, size, width, _i, _len, _ref, _results;
    width = $(document).width() / 2;
    height = $(document).height() * .85;
    size = d3.min([width, height]);
    graphic.svg = d3.select("#graphic").append("svg").attr("width", size).attr("height", size);
    g = graphic.svg.append("g");
    _ref = _.range(size / 10);
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      i = _ref[_i];
      _results.push(graphic.svg.append("rect").attr("width", size - i * 10).attr("height", size - i * 10).attr("fill", i % 2 === 0 ? "black" : "white"));
    }
    return _results;
  };

  graphic.update = function() {};

  graphic.destroy = function() {
    graphic.svg.remove();
    return delete graphic.svg;
  };

  data.toWordsArray = function(dataObj) {
    var i, onedayexample, wordArr, year, _i, _len;
    year = _.keys(dataObj);
    wordArr = [];
    console.log(year);
    onedayexample = dataObj["2011"]["10"]["10"];
    for (_i = 0, _len = onedayexample.length; _i < _len; _i++) {
      i = onedayexample[_i];
      wordArr = _.union(wordArr, i.title.split(" "));
      console.log(wordArr);
    }
    console.log(typeof wordArr);
    return wordArr;
  };

  $(document).ready(function() {
    d3.json("data.json", function(dataObj) {
      var draw, fill, wordsToVisualize;
      wordsToVisualize = data.toWordsArray(dataObj);
      fill = d3.scale.category20;
      draw = function(words) {
        console.log(words);
        return d3.select("#graphic").append("svg").attr("width", 500).attr("height", 500).append("g").attr("transform", "translate(150,150)").selectAll("text").data(words).enter().append("text").style("font-size", function(d) {
          return d.size + "px";
        }).style("font-family", "Impact").style("fill", function(d, i) {
          return fill(i);
        }).attr("text-anchor", "middle").attr("transform", function(d) {
          return "translate(" + [d.x, d.y] + ")rotate(" + d.rotate + ")";
        }).text(function(d) {
          return d.text;
        });
      };
      return d3.layout.cloud().size([300, 300]).words(wordsToVisualize.map(function(d) {
        return {
          text: d,
          size: 10 + Math.random() * 90
        };
      })).padding(5).rotate(function() {
        return ~~(Math.random() * 2) * 90;
      }).font("Impact").fontSize(function(d) {
        return d.size;
      }).on("end", draw).start();
    });
    return $(window).resize(function() {
      graphic.destroy();
      return graphic.create();
    });
  });

}).call(this);
