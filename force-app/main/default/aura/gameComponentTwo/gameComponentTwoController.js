({
  doInit: function (component, event, helper) {
    let mode = component.get("v.mode");
    var column = 0;
    if (!mode) {
      return;
    } else if (mode === "Low") {
      column = 3;
    } else if (mode === "Medium") {
      column = 4;
    } else if (mode === "Difficult") {
      column = 6;
    }
    let sizeValue = 12 / column;
    component.set("v.size", sizeValue);
    let ar = helper.getWords(column * column);
    let winWord = helper.getWinWords(ar);
    component.set("v.words", ar);
    component.set("v.winWord", winWord);
    helper.resetBoard(component);
  },
  blockClickHandler: function (component, event, helper) {
    let blockWord = event.getParam("value");
    let clicked = component.get("v.clickCount") + 1;
    if (component.get("v.winWord") === blockWord) {
      component.set("v.result", "you win");
      helper.boardDisabled(component);
    } else if (clicked === 3) {
      component.set("v.result", "you lose");
      helper.boardDisabled(component);
    }
    component.set("v.clickCount", clicked);
  }
});