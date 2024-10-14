import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="signup"
export default class extends Controller {
  static targets = [""];

  connect() {
    this.mentorFormTarget.hidden = true;
    // set Mentee button as active by default when the page loads
    this.setActiveButton("menteeForm");
  }

  showForm({ params: { content } }) {
    if (content === "mentorForm") {
      this.mentorFormTarget.hidden = false;
      this.menteeFormTarget.hidden = true;
    } else if (content === "menteeForm") {
      this.mentorFormTarget.hidden = true;
      this.menteeFormTarget.hidden = false;
    }
    
    // update active button styles based on the form being shown
    this.setActiveButton(content);
  }

  setActiveButton(formType) {
    // remove active and ring classes from both buttons and reset background colors
    this.mentorButtonTarget.classList.remove("ring-2", "ring-[#27485d]", "ring-opacity-50", "active", "bg-[#3e6176]");
    this.menteeButtonTarget.classList.remove("ring-2", "ring-[#27485d]", "ring-opacity-50", "active", "bg-[#3e6176]");

    // add active, ring, and hover background color to the correct button
    if (formType === "mentorForm") {
      this.mentorButtonTarget.classList.add("ring-2", "ring-[#27485d]", "ring-opacity-50", "active", "bg-[#3e6176]");
    } else {
      this.menteeButtonTarget.classList.add("ring-2", "ring-[#27485d]", "ring-opacity-50", "active", "bg-[#3e6176]");
    }
  }
}
