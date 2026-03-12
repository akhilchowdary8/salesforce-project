({
  // Function to generate random number
  generateRandomNumber: function (component) {
    var randomNumber = Math.floor(Math.random() * 1000);
    component.set("v.randomNumber", randomNumber);
  }
});