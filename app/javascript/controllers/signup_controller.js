import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="signup"
export default class extends Controller {
  connect() {
    console.log("Hello!", this.element);
  }
}
