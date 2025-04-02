import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "container", "fileCard"]
  static values = {
    documents: Array,
    chatbotId: String
  }

  connect() {
    if (this.documentsValue.length > 0) {
      this.showExistingFiles()
    }
  }

  showExistingFiles() {
    console.log("showExistingFiles")
    this.containerTarget.innerHTML = ""
    
    this.documentsValue.forEach((doc) => {
      const card = this.createFileCard({
        name: doc.filename,
        size: doc.size
      }, null, doc.id)
      this.containerTarget.appendChild(card)
    })
  }

  showSelectedFile(event) {
    const newFiles = event.target.files
    if (!newFiles || newFiles.length === 0) {
      return
    }
    
    // Create a new DataTransfer object to hold all files
    const dataTransfer = new DataTransfer()
    
    // Add new files
    Array.from(newFiles).forEach(file => {
      dataTransfer.items.add(file)
    })
    
    // Update the file input with all files
    this.inputTarget.files = dataTransfer.files
    
    // Clear container and show existing files first
    this.containerTarget.innerHTML = ""
    if (this.documentsValue.length > 0) {
      this.showExistingFiles()
    }
    
    // Show all files from input, with indices starting from 0
    Array.from(this.inputTarget.files).forEach((file, index) => {
      const card = this.createFileCard(file, index)
      this.containerTarget.appendChild(card)
    })
  }

  createFileCard(file, index, existingFileId = null) {
    // Clone the template content
    const fileCard = this.fileCardTarget
    const card = fileCard.content.cloneNode(true).firstElementChild
    
    // Only set file index for new files (not existing ones)
    if (index !== null) {
      card.dataset.fileIndex = index
      card.dataset.newFile = "true"
    }
    
    if (existingFileId) {
      card.dataset.existingFileId = existingFileId
      card.classList.add('bg-success/20') // Add success background to existing files
    }
    
    card.querySelector('h3').textContent = file.name
    card.querySelector('p').textContent = this.formatFileSize(file.size)
    
    // Only set file index on button for new files
    const button = card.querySelector('button')
    if (index !== null) {
      button.dataset.fileIndex = index
    }
    if (existingFileId) {
      button.dataset.existingFileId = existingFileId
    }
    
    return card
  }

  async removeFile(event) {
    const button = event.currentTarget
    const existingFileId = button.dataset.existingFileId
    const index = parseInt(button.dataset.fileIndex)
    const card = button.closest('.card')

    if (existingFileId) {
      // Add confirmation dialog for existing files
      if (!confirm("Are you sure you want to delete this file?")) {
        return
      }

      try {
        const response = await fetch(`/chatbots/${this.chatbotIdValue}/sources?document_id=${existingFileId}`, {
          method: 'DELETE',
          headers: {
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
            'Accept': 'text/vnd.turbo-stream.html, application/html, application/json'
          }
        })

        if (response.ok) {
          // Remove from documents value
          this.documentsValue = this.documentsValue.filter(doc => doc.id !== parseInt(existingFileId))
          // Remove the card
          card.remove()
        } else {
          console.error('Failed to delete file')
        }
      } catch (error) {
        console.error('Error deleting file:', error)
      }
    } else {
      // For non-existing files, just update the files list and remove the card
      const currentFiles = Array.from(this.inputTarget.files)
      const updatedFiles = currentFiles.filter((_, i) => i !== index)
      
      // Update the file input with remaining files
      const dataTransfer = new DataTransfer()
      updatedFiles.forEach(file => {
        dataTransfer.items.add(file)
      })
      this.inputTarget.files = dataTransfer.files

      // Remove the card from UI
      card.remove()
    }
  }

  hideAllFileCards() {
    // this.containerTarget.classList.add('hidden')
    this.containerTarget.innerHTML = ""
  }

  formatFileSize(bytes) {
    if (bytes === 0) return '0 Bytes'
    
    const k = 1024
    const sizes = ['Bytes', 'KB', 'MB', 'GB']
    const i = Math.floor(Math.log(bytes) / Math.log(k))
    
    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i]
  }
} 