import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="timezone-visibility"
export default class extends Controller {
  static targets = [ "timezoneSelector", "toggle" ]

  connect() {
    this.updateState()
  }

  toggleState() {
    this.updateState()
  }

  updateState() {
    const timezoneSelectElement = this.timezoneSelectorTarget.querySelector("select")
    if (this.toggleTarget.checked) {
      this.timezoneSelectorTarget.classList.remove("opacity-50")
      timezoneSelectElement.disabled = false
    } else {
      this.timezoneSelectorTarget.classList.add("opacity-50")
      timezoneSelectElement.disabled = true
    }
  }
} 