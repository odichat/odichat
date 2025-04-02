import { Controller } from "@hotwired/stimulus"
import * as ActiveStorage from "@rails/activestorage"

// Connects to data-controller="direct-uploads"
export default class extends Controller {
  static targets = ["container"]

  connect() {
    // direct_uploads.js
    console.log("direct-uploads.js connected")
    
    addEventListener("direct-upload:initialize", event => {
      const { target, detail } = event
      const { id, file } = detail
      
      // Find the corresponding file card using the index, but only among new files
      const fileCard = this.containerTarget.querySelector(`[data-new-file="true"][data-file-index="${id - 1}"]`)
      
      if (fileCard) {
        // Add a progress bar to the card
        const cardBody = fileCard.querySelector('.card-body')
        cardBody.insertAdjacentHTML('beforeend', `
          <div class="mt-2 w-full bg-base-100 rounded-full h-2.5">
            <div id="direct-upload-progress-${id}" 
                 class="bg-primary h-2.5 rounded-full transition-all duration-150" 
                 style="width: 0%">
            </div>
          </div>
        `)
      }
    })

    addEventListener("direct-upload:start", event => {
      const { id } = event.detail
      const fileCard = this.containerTarget.querySelector(`[data-new-file="true"][data-file-index="${id - 1}"]`)
      if (fileCard) {
        fileCard.classList.add('opacity-75')
      }
    })

    addEventListener("direct-upload:progress", event => {
      const { id, progress } = event.detail
      const progressBar = document.getElementById(`direct-upload-progress-${id}`)
      if (progressBar) {
        progressBar.style.width = `${progress}%`
      }
    })

    addEventListener("direct-upload:error", event => {
      event.preventDefault()
      const { id, error } = event.detail
      const fileCard = this.containerTarget.querySelector(`[data-new-file="true"][data-file-index="${id - 1}"]`)
      if (fileCard) {
        fileCard.classList.remove('opacity-75')
        fileCard.classList.add('bg-error/20')
        // Add error message
        const cardBody = fileCard.querySelector('.card-body')
        cardBody.insertAdjacentHTML('beforeend', `
          <p class="text-error text-sm mt-2">${error}</p>
        `)
      }
    })

    addEventListener("direct-upload:end", event => {
      const { id } = event.detail
      const fileCard = this.containerTarget.querySelector(`[data-new-file="true"][data-file-index="${id - 1}"]`)
      if (fileCard) {
        fileCard.classList.remove('opacity-75')
        fileCard.classList.add('bg-success/20')
      }
    })

    ActiveStorage.start()
  }
}
