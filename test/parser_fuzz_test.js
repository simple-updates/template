(function() {
  var Template;

  Template = require('../build/template').Template;

  console.log(Template)

  exports.fuzz = (input) => {
    var e, isJSON, isPJSON, isTemplate;
    console.log(input)
    input = input.toString('utf8');
    isPJSON = true;
    isTemplate = true;
    try {
      JSON.parse(input);
    } catch (error) {
      e = error;
      isJSON = false;
    }
    try {
      Template.parse(`{{${input}}}`);
    } catch (error) {
      e = error;
      isTemplate = false;
    }
    if (isJSON && !isTemplate) {
      throw new Error('found json that is not template interpolation');
    }
    return isJSON != null ? isJSON : {
      1: 0
    };
  };

}).call(this);
