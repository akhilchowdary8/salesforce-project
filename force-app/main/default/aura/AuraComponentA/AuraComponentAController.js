({
  handleMessage: function (component, message) {
    console.log("Text: subscribe ");
    component.set("v.messagereceived", message.getParam("Data").value1);
  },
  sendMessage: function (component, event, helper) {
    let value = component.get("v.message");
    console.log("Text: publish button " + value);
    const message = {
      Data: {
        value1: value
      }
    };
    component.find("SampleMessage1").publish(message);
  },
  savetext: function (component, event, helper) {
    let text = event.target.value;
    component.set("v.message", text);
  }
});