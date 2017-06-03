'use strict';

var Alexa = require('alexa-sdk');
var APP_ID = undefined;
//var databaseHelper = require('./dbHelper');
console.log('Loading function');
const doc = require("dynamodb-doc");
const dynamo = new doc.DynamoDB();
var ok = "nope";



exports.handler = function(event, context, callback) {

  if (event.httpMethod) {
    console.log('Received event:', JSON.stringify(event, null, 2));

    const done = (err, res) => callback(null, {
        statusCode: err ? '400' : '200',
        body: err ? err.message : JSON.stringify(res),
        headers: {
            'Content-Type': 'application/json',
        },
    });

    switch (event.httpMethod) {
        case 'DELETE':
            dynamo.deleteItem(JSON.parse(event.body), done);
            break;
        case 'GET':
            dynamo.scan({ TableName: "Recipes" }, done);
            break;
        case 'POST':
            dynamo.putItem(JSON.parse(event.body), done);
            break;
        case 'PUT':
            dynamo.updateItem(JSON.parse(event.body), done);
            break;
        default:
            done(new Error(`Unsupported method "${event.httpMethod}"`));

          }
  } else {
        var alexa = Alexa.handler(event, context);
        alexa.APP_ID = "123";
        alexa.resources = languageStrings;
        alexa.registerHandlers(handlers);
        alexa.execute();
  }
};

var IngredientsList = ["salt", "pepper", "eggs"]; //will be replaced with actual list of ingredients when RecipeName is found
var RecipeSteps = ["one", "two", "three"];
var IngInd = -1;
var RecipeInd = -1;
var inIngredients = false;
var RecipeName = "Name";

var bombmacarons = ["bomb macarons", ["Line a baking sheet with a silicone baking mat.",
"Beat egg whites in the bowl of a stand mixer fitted with a whisk attachment until whites are foamy; beat in white sugar and continue beating until egg whites are glossy, fluffy, and hold soft peaks.",
"Sift confectioners' sugar and ground almonds in a separate bowl and quickly fold the almond mixture into the egg whites, about 30 strokes.",
"Spoon a small amount of batter into a plastic bag with a small corner cut off and pipe a test disk of batter, about 1 1/2 inches in diameter, onto prepared baking sheet. If the disk of batter holds a peak instead of flattening immediately, gently fold the batter a few more times and retest.",
"When batter is mixed enough to flatten immediately into an even disk, spoon into a pastry bag fitted with a plain round tip. Pipe the batter onto the baking sheet in rounds, leaving space between the disks. Let the piped cookies stand out at room temperature until they form a hard skin on top, about 1 hour.",
"Preheat oven to 285 degrees F (140 degrees C).",
"Bake cookies until set but not browned, about 10 minutes; let cookies cool completely before filling."],
["1 3/4 cups confectioners' sugar", "1 cup almond flour", "3 large egg whites, at room temperature",
"4 teaspoon cream of tartar", "Pinch of salt", "1/4 cup superfine sugar", "2 to 3 drops gel food coloring",
"1/2 teaspoon vanilla, almond or mint extract"]]
var organicpestopasta = ["organic pesto pasta", ["Cook pasta in a large pot of boiling water until done. Drain.", "Meanwhile, heat the oil in a frying pan over medium low heat. Add pesto, onion, and salt and pepper.", "Cook about five minutes, or until onions are soft.", "In a large bowl, mix pesto mixture into pasta. Stir in grated cheese. Serve."],
["1/2 cup chopped onion", "2 1/2 tablespoons pesto", "2 tablespoons olive oil", "2 tablespoons grated Parmesan cheese", "1 (16 ounce) package pasta salt to taste", "ground black pepper"]];
var pizza = ["pizza", ["In large bowl, mix first 4 ingredients.", "Mix water and oil; add to flour mixture.", "Turn onto floured surface; knead for 2 minutes.",
"Place in a greased bowl; turning to grease top.", "Cover and let rise for 20 minutes.", "Punch down; place on 12in, greased pizza pan.", "Pat into a circle.",
"Topping: Mix first 5 ingredients and spread over crust.", "Put a few pepperoni slices on top of sauce.",
"Sprinkle with 1/2 the mozzeralla; 1/2 the monterey jack, and 1/2 the parmesan.", "Put the rest of the pepperoni on.",
"Repeat the cheese layer.", "Bake at 400* for 20 minutes or until light brown."],
["2 1⁄2 cups flour", "1 teaspoon salt", "1 teaspoon sugar", "1 tablespoon fast rise yeast", "1 cup water (120*)", "1 tablespoon oil"]]
var simpletacos = [ "simple tacos", ["Cook beef in 10-inch skillet over medium heat 8 to 10 minutes, stirring occasionally, until brown; drain.", "Stir salsa into beef. Heat to boiling, stirring constantly; reduce heat to medium-low. Cook 5 minutes, stirring occasionally. Pour beef mixture into large serving bowl.", "Heat taco shells as directed on package. Serve taco shells with beef mixture, lettuce, tomato and cheese"], ["1 pound lean (at least 80%) ground beef", "1 cup Old El Pasoâ„¢ Thick 'n Chunky salsa", "10 Old El Pasoâ„¢ taco shells", "1/2 head lettuce, shredded", "1 medium tomato, chopped (3/4 cup)", "1 cup shredded Cheddar cheese (4 ounces)"]];
var testingsteak = [ "testing steak", ["Remove the steak from the refrigerator and let it come to room temperature, about 30 to 45 minutes.", "Season the steak on both sides with the salt and pepper. Rub both sides with the olive oil and set aside.", "Heat a medium heavy-bottomed frying pan (not nonstick!) over high heat until very hot but not smoking, about 3 to 4 minutes. (If the pan gets too hot and starts to smoke, take it off the heat to cool a bit.) Place the steak in the pan and let it cook undisturbed until a dark crust forms on the bottom, about 3 to 4 minutes.", "Flip the steak using tongs or a spatula and cook until itâ€™s medium rare, about 3 to 4 minutes more. To check for doneness, use your finger to press on the steak: It should be firm around the edges but still give in the center. You can also use an instant-read thermometer; it should read about 125Â°F to 130Â°F.",
"Transfer the steak to a cutting board and let it rest for at least 5 minutes before serving"], ["1 (1-1/4- to 1-1/2-inch-thick) New York strip steak (about 8 ounces)", "1 1/2 teaspoons kosher salt", "1/4 teaspoon freshly ground black pepper", "1 teaspoon olive oil"]];
var masterList = [bombmacarons, organicpestopasta, pizza, simpletacos, testingsteak];




var handlers = {
    'LaunchRequest': function () {
        var welcome = this.t("WELCOME_MESSAGE");
        this.emit(':tell', welcome);
    },
    'StartRecipeIntent': function () {
        var itemSlot = this.event.request.intent.slots.Food;
        var itemName;
        if (itemSlot && itemSlot.value) {
            itemName = itemSlot.value.toLowerCase();
        }
        RecipeName = itemName;
        var rightList;
        var found = false;
        for (var i = 0; i < masterList.length; i++) {
          // if (found === false) {
          //   break;
          // }
            if (masterList[i][0] == RecipeName) {
                rightList = masterList[i];
                found = true;
                break;
              }
        }
        // for (i in masterList) {
        //   if (i[0]) {
        //     rightList = i;
        //     found = true;
        //     break;
        //   }
        // }
        if (found === false) {
          this.emit(':tell', "Recipe not found.")
        }
        // this.emit(':tell', rightList[0]);
        IngredientsList = rightList[2];
        RecipeSteps = rightList[1];
        // IngredientsList = masterList[0][0];
        // RecipeSteps = rightList[1];
        this.emit(':tell', "Recipe found. Say read recipe to start recipe or ask for ingredients.");
        // var params = {
        //     TableName: "Recipes"
        //    };
      //  function foo(params, something) {
      //    dynamo.scan(params, function(err, data) {
      //         something = data;
      //    })
      //  };
      //  output = foo(params, output);
           //THIS DOESN'T WORK:
      //   var func = function(params, something) {dynamo.scan(params, function(err, data) {
      //       if (err) {
      //         return something = "maybe";
      //       } else {
      //         return something = "maybe";
      //       }
      //   })};
       //
      //   var testvar = func(params, testvar);
       //
      //  this.emit(':tell', testvar);
    },
    'InRecipeIntent': function () {
      var itemSlot = this.event.request.intent.slots.Item;
      var itemName;
      if (itemSlot && itemSlot.value) {
          itemName = itemSlot.value.toLowerCase();
      }

      if (itemName == "ingredients") {
          inIngredients = true;
          IngInd = 0;
          this.emit(':tell', IngredientsList[IngInd] + " " + "...Say next ingredient, last ingredient, or start again to hear the list of ingredients");
      } else if (itemName == "next ingredient") {
          IngInd = IngInd + 1;
          if (IngredientsList.length <= IngInd) {
            this.emit(':tell', "You have reached the last ingredient. Say read recipe to start the recipe.")
          }
          this.emit(':tell', IngredientsList[IngInd]);
      } else if (itemName == "last ingredient") {
          IngInd = IngInd - 1;
          this.emit(':tell', IngredientsList[IngInd]);
      } else if (itemName == ("read recipe")) {
          inIngredients = false;
          RecipeInd = 0;
          this.emit(':tell', RecipeSteps[RecipeInd] + " " + "...Say next step, last step, or start again to navigate the recipe steps.");

      } else if (itemName == ("start")) {
          if (inIngredients == true) {
            IngInd = 0;
            this.emit(':tell', IngredientsList[IngInd] + " " + "...Say next ingredient, last ingredient, or start again to hear the list of ingredients");
          } else {
            inIngredients = false;
            RecipeInd = 0;
            this.emit(':tell', RecipeSteps[RecipeInd] + " " + "...Say next step, last step, or start again to navigate the recipe steps.");
          }
      } else if (itemName == "next step") {
          RecipeInd = RecipeInd + 1;
          if (RecipeSteps.length <= RecipeInd) {
            this.emit(':tell', "Congratulations! You have finished the recipe. Say exit recipe to quit this recipe or say last step or start over to continue the recipe.")
          }
          this.emit(':tell', RecipeSteps[RecipeInd]);
      } else if (itemName == "last step") {
          RecipeInd = RecipeInd - 1;
          this.emit(':tell', RecipeSteps[RecipeInd]);
      }

    },
    'AMAZON.HelpIntent': function () {
        var help = this.t("HELP_MESSAGE");
        this.emit(':tell', help)
    },
    'HelpIntent': function () {
        var help = this.t("HELP_MESSAGE");
        this.emit(':tell', help)
    },
    'StopIntent': function () {
        if (RecipeName == "Name") {
            this.emit('SessionEndedRequest');
        } else {
            RecipeName = "Name";
            this.emit(':tell', "Quitting current recipe and returning to main menu.");
        }
    },
    'AMAZON.CancelIntent': function () {
        if (RecipeName == "Name") {
            this.emit('SessionEndedRequest');
        } else {
            RecipeName = "Name";
            this.emit(':tell', "Quitting current recipe and returning to main menu.");
        }
    },
    'SessionEndedRequest':function () {
      this.emit(':tell', this.t("Bye!"));

    }
};


var languageStrings = {
    "en-US": {
        "translation": {
            "WELCOME_MESSAGE": "Recipe assistant, what recipe would you like to make?",
            "HELP_MESSAGE": "You can search for recipes by saying find item or I'd like to make item or say exit recipe to quit and return to main menu.",
        }
    }
};
