<script>
  $(document).ready(function(){
    $("#getReq").click(function(){
       var rn = $('body').find("#recipeName").val();
            var ing = $('body').find("#ingredients").val();
            var dir = $('body').find("#directions").val();
            var img = $('body').find("#imageUpload").val();
            var obj = {
              "RecipeName": rn,
              "Ingredients": ing,
              "Directions": dir,
              "Image": img,
          };
      $.ajax({
        url: 'https://v2118pjf9i.execute-api.us-east-1.amazonaws.com/prod/RecipeUpdate?TableName=Recipes',
        type: 'POST',
        data: JSON.stringify({"TableName": "Recipes", "Item": obj }),
        success: function(data) {
        alert("Recipe added successfully");
        location.reload();
        },
        error: function(xhr, ajaxOptions, thrownError) {
          alert("Couldn't add recipe. Please try again.");
        }
      });
    });
  });

</script>