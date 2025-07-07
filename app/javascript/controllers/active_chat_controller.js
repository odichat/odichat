import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["item"]

  connect() {
    // Set the first chat as active initially if none are active
    if (!this.hasActiveItem()) {
      this.setActive(this.itemTargets[0])
    }
  }

  selectChat(event) {
    console.log("selectChat", event.currentTarget)
    const clickedItem = event.currentTarget
    
    // Remove active state from all items
    this.itemTargets.forEach(item => {
      item.classList.remove("bg-base-300", "border-r-4", "border-info")
      item.querySelector("a").classList.remove("text-info")
    })
    
    // Add active state to clicked item
    this.setActive(clickedItem)
  }

  setActive(item) {
    if (item) {
      item.classList.add("bg-base-300", "border-r-4", "border-info")
      item.querySelector("a").classList.add("text-info")
    }
  }

  hasActiveItem() {
    return this.itemTargets.some(item => item.classList.contains("bg-base-300"))
  }
} 