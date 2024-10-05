import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="signup"
export default class extends Controller {
  static targets = ["display"];
  connect() {
    console.log("Hello!", this.element);
  }

  showForm({ params: { content } }) {
    console.log(content);

    const display = this.displayTarget
  }
}
