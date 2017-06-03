$(document).ready(function() {
  // populate table with all database entries
  var theUrl = "https://v2118pjf9i.execute-api.us-east-1.amazonaws.com/prod/RecipeUpdate?TableName=Recipes";
  var Recipes;
  var length;
  var recipe_name;
  var recipe_directions;
  $.get(theUrl, function(data, status){
    Recipes = data;
    count = data.Count;
  }).then(function() {
    for (var i = 0; i < count; i++) {
      var actual_recipe = Recipes.Items[i];
      var name = actual_recipe.RecipeName;
      var directions = actual_recipe.Directions;
      var image = actual_recipe.Image;
      var ingredients_list = actual_recipe.Ingredients;

      // add to grid
      var html =  "<div class='mbr-gallery-item mbr-gallery-item__mobirise3 mbr-gallery-item--p1'>";
      html += "<div href='#lb-gallery2-1l' data-toggle='modal'>";
      html += "<img alt= '' src='" + image + "'>";
      html += "<span class='mbr-gallery-title'>";
      html += name + "<div class='card-img iconbox'>";
      // icons
      html += "<a  class='mbri-cart-add mbr-iconfont mbr-iconfont-features7' style='font-size: 20px; color: rgb(255, 255, 255);' id ='" + name + "'>"
      html += "</a> </div>";
      html += "<div class='card-img iconbox'>";
      html += "<a class='mbri-contact-form mbr-iconfont mbr-iconfont-features7'  style ='font-size: 20px; color: rgb(255, 255, 255);' id ='" + name + "'>";
      html += "</a></div></span></div></div>";
      $(".mbr-gallery-layout-default").append(html);
    }
    var html2 = "<div class='clearfix'></div>";
    html
    $(".mbr-gallery-layout-default").append(html2);
  });

  $(".mbr-gallery-layout-default").on('click', '.mbri-cart-add', function() {
    var recipe_name = $(this).attr('id');
    window.location.href = "ingredients.html?id=" + recipe_name;
  });

  $(".mbr-gallery-layout-default").on('click', '.mbri-contact-form', function() {
    var recipe_name = $(this).attr('id');
    window.location.href = "directions.html?id=" + recipe_name;
  });


})


