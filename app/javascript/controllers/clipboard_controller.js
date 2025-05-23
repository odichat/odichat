import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "tooltip"]

  copy() {
    const inputElement = document.getElementById("public-url-input")
    if (inputElement) {
      navigator.clipboard.writeText(inputElement.value).then(() => {
        this.showTooltip()
      }).catch(err => {
        console.error("Failed to copy: ", err)
      })
    }
  }

  showTooltip() {
    this.tooltipTarget.classList.remove("hidden")
    setTimeout(() => {
      this.tooltipTarget.classList.add("hidden")
    }, 2000)
  }
} 