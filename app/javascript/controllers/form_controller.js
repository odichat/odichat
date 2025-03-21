import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="form"
export default class extends Controller {
  connect() {
    this.element.addEventListener("turbo:submit-end", () => {
      this.element.reset()
    })
  }

  clear() {
    this.element.reset()
  }
}
