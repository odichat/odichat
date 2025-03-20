import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "display"]

  connect() {
    this.updateDisplay()
  }

  updateDisplay() {
    if (this.hasDisplayTarget) {
      this.displayTarget.textContent = Number(this.inputTarget.value).toFixed(1)
    }
  }
} 