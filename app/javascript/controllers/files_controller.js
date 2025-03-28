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
    
    this.documentsValue.forEach((doc, index) => {
      const card = this.createFileCard({
        name: doc.filename,
        size: doc.size
      }, index, doc.id)
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
    
    // Show all files from input
    Array.from(this.inputTarget.files).forEach((file, index) => {
      const card = this.createFileCard(file, this.documentsValue.length + index)
      this.containerTarget.appendChild(card)
    })


  }

  createFileCard(file, index, existingFileId = null) {
    // Clone the template content
    const fileCard = this.fileCardTarget
    const card = fileCard.content.cloneNode(true).firstElementChild
    
    // Replace placeholders with actual values
    card.dataset.fileIndex = index
    if (existingFileId) {
      card.dataset.existingFileId = existingFileId
    }
    card.querySelector('h3').textContent = file.name
    card.querySelector('p').textContent = this.formatFileSize(file.size)
    card.querySelector('button').dataset.fileIndex = index
    if (existingFileId) {
      card.querySelector('button').dataset.existingFileId = existingFileId
    }
    
    return card
  }

  async removeFile(event) {
    const button = event.currentTarget
    const existingFileId = button.dataset.existingFileId
    const index = parseInt(button.dataset.fileIndex)

    if (existingFileId) {
      // Find the document with matching id to get its signed_id
      const document = this.documentsValue.find(doc => doc.id === parseInt(existingFileId))
      if (document) {
        // Remove from documents value
        this.documentsValue = this.documentsValue.filter(doc => doc.id !== parseInt(existingFileId))
        // Remove the corresponding hidden field using signed_id
        const hiddenField = this.element.querySelector(`input[name="chatbot[documents][]"][value="${document.signed_id}"]`)
        if (hiddenField) {
          hiddenField.remove()
        }
        // Remove the card
        button.closest('.card').remove()
      }
    } else {
      const currentFiles = Array.from(this.inputTarget.files)
      const updatedFiles = currentFiles.filter((_, i) => i !== index)
      
      if (updatedFiles.length === 0 && this.documentsValue.length === 0) {
        this.inputTarget.value = ""
        this.hideAllFileCards()
      } else {
        const dataTransfer = new DataTransfer()
        updatedFiles.forEach(file => {
          dataTransfer.items.add(file)
        })
        this.inputTarget.files = dataTransfer.files

        this.containerTarget.innerHTML = ""

        if (this.documentsValue.length > 0) {
          this.showExistingFiles()
        }

        updatedFiles.forEach((file, i) => {
          const card = this.createFileCard(file, i)
          this.containerTarget.appendChild(card)
        })
      }
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