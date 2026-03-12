({
  getWords: function (count) {
    var words = [
      "Apple",
      "Banana",
      "Cherry",
      "Dates",
      "Elderberry",
      "Fig",
      "Grape",
      "Honeydew",
      "Iceberg",
      "Jackfruit",
      "Kiwi",
      "Lemon",
      "Mango",
      "Nectarine",
      "Orange",
      "Papaya",
      "Quince",
      "Raspberry",
      "Strawberry",
      "Tangerine",
      "Ugli",
      "Vanilla",
      "Watermelon",
      "Xigua",
      "Yam",
      "Zucchini",
      "Almond",
      "Brazilnut",
      "Cashew",
      "Durian",
      "Eggplant",
      "Fennel",
      "Garlic",
      "Hazelnut",
      "Icecream",
      "Jalapeno",
      "Kale",
      "Lettuce",
      "Mushroom",
      "Nutmeg",
      "Olive",
      "Pistachio",
      "Quinoa",
      "Radish",
      "Spinach",
      "Tomato",
      "Udon",
      "Vinegar",
      "Walnut",
      "Xylitol",
      "Yogurt",
      "Zest",
      "Avocado",
      "Blueberry",
      "Cantaloupe",
      "Dragonfruit",
      "Endive",
      "Fava",
      "Guava",
      "Huckleberry",
      "Indianfig",
      "Jujube",
      "Kumquat",
      "Lime",
      "Mulberry",
      "Nance",
      "Olive",
      "Peach",
      "Rambutan",
      "Sapodilla",
      "Tamarind",
      "Ugni",
      "Voavanga",
      "Waxapple",
      "Ximenia",
      "Yellowpassionfruit",
      "Ziziphus",
      "Artichoke",
      "Broccoli",
      "Carrot",
      "Daikon",
      "Escarole",
      "Fiddlehead",
      "Ginger",
      "Horseradish",
      "Iceplant",
      "Jicama",
      "Kohlrabi",
      "Leek",
      "Mustard",
      "Okra",
      "Parsnip",
      "Rutabaga",
      "Squash",
      "Turnip",
      "Ulluco",
      "Vidalia",
      "Watercress",
      "Xoconostle",
      "Zingiber"
    ];
    this.shuffleArray(words);
    // Use the shuffled array as needed
    console.log(words);
    return words.slice(0, count);
  },

  shuffleArray: function (array) {
    for (let i = array.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [array[i], array[j]] = [array[j], array[i]];
    }
  },
  getWinWords: function (arr) {
    let index = Math.floor(Math.random() * arr.length);
    return arr[index];
  },
  boardDisabled: function (component) {
    component.set("v.boardDisabled", true);
  },
  boardEnabled: function (component) {
    component.set("v.boardDisabled", false);
  },

  resetBoard: function (component) {
    component.set("v.result", "");
    component.set("v.clickCount", 0);
    this.boardEnabled(component);
  }
});