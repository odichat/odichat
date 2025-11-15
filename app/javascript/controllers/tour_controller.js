import { Controller } from "@hotwired/stimulus"

const DEFAULT_STORAGE_KEY = "tour-onboarding"

export default class extends Controller {
  static values = {
    steps: Array,
    storageKey: { type: String, default: DEFAULT_STORAGE_KEY }
  }

  connect() {
    this.startTour()
  }

  startTour() {
    if (!this.shouldRunTour()) return

    const driverFactory = window?.driver?.js?.driver
    if (typeof driverFactory !== "function") return

    const steps = this.buildSteps()
    if (!steps.length) return

    this.driverInstance = driverFactory({ steps })
    this.driverInstance.drive()
    this.markTourSeen()
  }

  disconnect() {
    this.driverInstance = null
  }

  buildSteps() {
    const stepsSource = this.stepsValue || []

    return stepsSource
      .map((step) => {
        if (!step?.selector) return null

        const element = document.querySelector(step.selector)
        if (!element) return null

        const popover = step.popover || {
          title: step.title,
          description: step.description
        }

        return {
          element,
          popover
        }
      })
      .filter(Boolean)
  }

  shouldRunTour() {
    try {
      return !window.localStorage.getItem(this.storageKeyValue)
    } catch (error) {
      console.warn("tour_controller: failed to read storage key", error)
      return true
    }
  }

  markTourSeen() {
    try {
      window.localStorage.setItem(this.storageKeyValue, "true")
    } catch (error) {
      console.warn("tour_controller: failed to persist storage key", error)
    }
  }
}
