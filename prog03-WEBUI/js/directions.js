$(document).ready(function() {
  var theUrl = "https://v2118pjf9i.execute-api.us-east-1.amazonaws.com/prod/RecipeUpdate?TableName=Recipes";
  var recipe_ingredients;
  var json_obj;
  var count;
  $.when($.get(theUrl, function(data, status){
    json_obj = data;
    count = data.Count;
  })).then(function() {
    var query_name = window.location.search.substring(1);
    var parsed = decodeURIComponent((query_name+'').replace(/\+/g, '%20'));
    // parsed.split('=');
    console.log(parsed.split('=')[1])
    var recipe_name  = parsed.split('=')[1];
    var html = "<em>" + "List of Ingredients for " + recipe_name + "</em> <br><em><br></em>";
    var html4 = "<em>" + "Directions for " + recipe_name + "</em> <br><em><br></em>";
    $("#ingT").append(html);

    
    for (var i = 0; i < count; i++) {
      if (json_obj.Items[i].RecipeName == recipe_name) {
        recipe_ingredients = json_obj.Items[i].Ingredients;
        recipe_directions = json_obj.Items[i].Directions;
        recipe_image = json_obj.Items[i].Image;
      }
    }

    $("#msg-box8-1e").css({"background-image": "url(" + recipe_image + ")"});

    // add ingredients
    var push = recipe_ingredients.split("\n");
    var html2 = "<ol>";
    $.each(push, function(index, str) {
      html2 += "<li>" + str + "</li>";  
    })
    html2 += "</olv>";


    // add directions
    var push2 = recipe_directions.split("\n");
    var html5 = "<ol>";
    $.each(push2, function(index, str) {
      html5 += "<li>" + str + "</li>";  
    })
    html5 += "</ol>";

    $("#ingX").append(html2);
    var html3 = "</div><br>";
    $("#ingX").append(html3);
    $("#dirT").append(html4);
    $("#dirX").append(html5)
  })
});