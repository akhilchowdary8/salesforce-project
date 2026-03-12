({
  myAction: function (component, event, helper) {},
  Handledata: function (component, event, helper) {
    console.log(event.getParam("message"));
    component.set("v.title", event.getParam("message"));
  }
});