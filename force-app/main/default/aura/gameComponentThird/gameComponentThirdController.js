({
  blockClickHandler: function (component, event, helper) {
    let val = component.get("v.label");
    const click = component.get("v.clicked");
    if (!click) {
      component.set("v.clicked", true);
      component.getEvent("blockClick").setParams({ value: val }).fire();
    }
  }
  // scriptsLoaded: function (component, event, helper) {
  //   const boardElement = document.getElementsByClassName("board"); // example dynamic width
  //   textFit(boardElement);
  // }
});