({
  handleChange: function (component, event, helper) {
    let gamemode = component.find("GameMode").get("v.value");
    component.set("v.GameModes", gamemode);
  },
  handleClickSubmit: function (component, event, helper) {
    console.log("handleClickSubmit called");
    let Mode = component.get("v.GameModes");
    if (Mode) {
      component.set("v.startGame", true);
      let startGamechild = component.find("startGamechild");
      startGamechild.startNewGame();
    }
  },
  handleClickReset: function (component, event, helper) {
    console.log("handleClickReset called");
  }
});