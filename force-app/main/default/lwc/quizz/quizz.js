import { LightningElement, track } from "lwc";

export default class Quizz extends LightningElement {
  selectedanswer = {};
  @track isDisabled = true;
  @track showResult = false;
  score = 0;
  Questions = [
    {
      id: 1,
      Question: "What is the capital of France?",
      Options: ["Paris", "Lyon", "Marseille", "Nice"],
      Answer: "Paris"
    },
    {
      id: 2,
      Question: "What is the capital of Spain?",
      Options: ["Madrid", "Valencia", "Seville", "Barcelona"],
      Answer: "Madrid"
    },
    {
      id: 3,
      Question: "What is the capital of Italy?",
      Options: ["Rome", "Milan", "Naples", "Turin"],
      Answer: "Rome"
    },
    {
      id: 4,
      Question: "What is the capital of Germany?",
      Options: ["Berlin", "Hamburg", "Munich", "Frankfurt"],
      Answer: "Berlin"
    },
    {
      id: 5,
      Question: "What is the capital of India?",
      Options: ["New Delhi", "Mumbai", "Kolkata", "Chennai"],
      Answer: "New Delhi"
    }
  ];

  get disableSubmit() {
    return Object.keys(this.selectedanswer).length !== this.Questions.length;
  }

  handleOptionChange(event) {
    event.preventDefault();
    const { name, value } = event.target;
    this.selectedanswer = { ...this.selectedanswer, [Number(name)]: value };
    this.isDisabled = this.disableSubmit;
  }

  handleReset(event) {
    event.preventDefault();
    this.selectedanswer = {};
    this.isDisabled = true;
    this.template.querySelectorAll("lightning-input").forEach((element) => {
      element.checked = false;
    });
  }

  handleSubmit(event) {
    this.showResult = false;
    this.score = 0;
    event.preventDefault();
    this.Questions.forEach((question) => {
      if (question.Answer === this.selectedanswer[question.id]) {
        this.score++;
      }
    });
    this.showResult = true;
  }
}