import { LightningElement } from "lwc";
import { loadStyle } from "lightning/platformResourceLoader";
import fontawesome from "@salesforce/resourceUrl/Icons";

export default class GameMatchingIcons extends LightningElement {
  isLoaded = false;
  openCards = [];
  matchCards = [];
  moves = 0;
  cards = [
    {
      id: 1,
      listClass: "card",
      icon: "fa fa-car",
      type: "car"
    },
    {
      id: 2,
      listClass: "card",
      icon: "fa fa-address-book",
      type: "address-book"
    },
    {
      id: 3,
      listClass: "card",
      icon: "fa fa-arrows",
      type: "arrows"
    },
    {
      id: 4,
      listClass: "card",
      icon: "fa fa-bell-o",
      type: "bell-o"
    },
    {
      id: 5,
      listClass: "card",
      icon: "fa fa-bug",
      type: "bug"
    },
    {
      id: 6,
      listClass: "card",
      icon: "fa fa-book",
      type: "book"
    },
    {
      id: 7,
      listClass: "card",
      icon: "fa fa-battery-half",
      type: "battery-half"
    },
    {
      id: 8,
      listClass: "card",
      icon: "fa fa-certificate",
      type: "certificate"
    },
    {
      id: 9,
      listClass: "card",
      icon: "fa fa-car",
      type: "car"
    },
    {
      id: 10,
      listClass: "card",
      icon: "fa fa-address-book",
      type: "address-book"
    },
    {
      id: 11,
      listClass: "card",
      icon: "fa fa-arrows",
      type: "arrows"
    },
    {
      id: 12,
      listClass: "card",
      icon: "fa fa-bell-o",
      type: "bell-o"
    },
    {
      id: 13,
      listClass: "card",
      icon: "fa fa-bug",
      type: "bug"
    },
    {
      id: 14,
      listClass: "card",
      icon: "fa fa-book",
      type: "book"
    },
    {
      id: 15,
      listClass: "card",
      icon: "fa fa-battery-half",
      type: "battery-half"
    },
    {
      id: 16,
      listClass: "card",
      icon: "fa fa-certificate",
      type: "certificate"
    }
  ];

  handleCardClick(event) {
    let curcard = event.target;

    // Ignore clicks on already disabled cards, matched cards, or if the card is already in openCards
    if (
      curcard.classList.contains("disabled") ||
      curcard.classList.contains("match") ||
      this.openCards.includes(curcard)
    ) {
      return;
    }
    console.log("curcard CLICK", curcard);

    curcard.classList.add("open", "show", "disabled");
    this.openCards = this.openCards.concat(curcard);

    // Ensure only two cards are processed at a time
    if (this.openCards.length === 2) {
      this.moves++;
      this.checkMatch(this.openCards);
    }
  }

  checkMatch(openCards) {
    // Ensure there are exactly 2 cards to compare
    // if (openCards.length !== 2) {
    //   return;
    // }

    if (openCards[0].type === openCards[1].type) {
      openCards[0].classList.remove("open", "show");
      openCards[1].classList.remove("open", "show");
      openCards[0].classList.add("match");
      openCards[1].classList.add("match");
      this.matchCards = this.matchCards.concat(openCards);
      this.openCards = [];
    } else {
      openCards[0].classList.add("unmatch");
      openCards[1].classList.add("unmatch");
      this.action("DISABLE");

      // eslint-disable-next-line @lwc/lwc/no-async-operation
      setTimeout(() => {
        this.openCards[0].classList.remove("show", "open", "unmatch");
        this.openCards[1].classList.remove("show", "open", "unmatch");
        this.openCards = [];
        this.action("ENABLE");
      }, 1100);
    }
  }

  action(type) {
    if (type === "ENABLE") {
      Array.from(this.template.querySelectorAll(".card")).forEach((card) => {
        if (!card.classList.contains("match")) {
          card.classList.remove("disabled");
        }
      });
    }
    if (type === "DISABLE") {
      Array.from(this.template.querySelectorAll(".card")).forEach((card) => {
        if (!card.classList.contains("match")) {
          card.classList.add("disabled");
        }
      });
    }
  }

  renderedCallback() {
    if (this.isLoaded) {
      return;
    }

    loadStyle(this, fontawesome + "/fontawesome/css/font-awesome.min.css")
      .then(() => {
        this.isLoaded = true;
        console.log("FontAwesome loaded");
      })
      .catch((error) => {
        console.error("Error loading FontAwesome: ", error);
      });
  }
}