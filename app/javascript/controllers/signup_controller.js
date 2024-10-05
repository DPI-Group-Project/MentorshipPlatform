import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="signup"
export default class extends Controller {
  static targets = ["mentorForm", "menteeForm"];

  connect() {
    this.mentorFormTarget.hidden = true;
  }

  showForm({ params: { content } }) {
    if (content == "mentorForm") {
      this.mentorFormTarget.hidden = false;
      this.menteeFormTarget.hidden = true;
    } else if (content == "menteeForm") {
      this.mentorFormTarget.hidden = true;
      this.menteeFormTarget.hidden = false;
    }
  }
}
