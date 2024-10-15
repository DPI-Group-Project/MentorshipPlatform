import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="signup"
export default class extends Controller {
  static targets = ["mentorForm", "menteeForm", "mentorButton", "menteeButton"];

  connect() {
    const urlParams = new URLSearchParams(window.location.search);
    const signupType = urlParams.get("signup_type");

    // Default behavior - hide mentor form and show mentee form
    if (signupType === "mentor") {
      this.showForm({ params: { content: "mentorForm" } });
    } else {
      this.showForm({ params: { content: "menteeForm" } });
    }
  }

  showForm({ params: { content } }) {
    // Show the correct form based on the button clicked or query parameter
    if (content === "mentorForm") {
      this.mentorFormTarget.hidden = false;
      this.menteeFormTarget.hidden = true;
    } else if (content === "menteeForm") {
      this.mentorFormTarget.hidden = true;
      this.menteeFormTarget.hidden = false;
    }
    
    // Update button styles to reflect active form
    this.setActiveButton(content);
  }

  setActiveButton(formType) {
    // Remove active and ring classes from both buttons
    this.mentorButtonTarget.classList.remove("ring-2", "ring-[#27485d]", "ring-opacity-50", "active", "bg-[#3e6176]");
    this.menteeButtonTarget.classList.remove("ring-2", "ring-[#27485d]", "ring-opacity-50", "active", "bg-[#3e6176]");

    // Add active, ring, and hover background color to the correct button
    if (formType === "mentorForm") {
      this.mentorButtonTarget.classList.add("ring-2", "ring-[#27485d]", "ring-opacity-50", "active", "bg-[#3e6176]");
    } else {
      this.menteeButtonTarget.classList.add("ring-2", "ring-[#27485d]", "ring-opacity-50", "active", "bg-[#3e6176]");
    }
  }
}
