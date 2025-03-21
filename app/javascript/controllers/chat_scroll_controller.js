import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.scrollToBottom()
    
    // Observe changes to the messages container
    this.observer = new MutationObserver(() => {
      this.scrollToBottom()
    })
    
    this.observer.observe(this.element, {
      childList: true,
      subtree: true
    })
  }

  disconnect() {
    if (this.observer) {
      this.observer.disconnect()
    }
  }

  scrollToBottom() {
    this.element.scrollTop = this.element.scrollHeight
  }
}
