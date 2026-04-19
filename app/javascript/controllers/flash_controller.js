import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    timeout: { type: Number, default: 2000 }
  }

  connect() {
    this.element.style.transform = "translateY(-100%)"
    this.element.style.transition = "transform 0.35s ease-out"

    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        this.element.style.transform = "translateY(0)"
      })
    })

    this.element.addEventListener("mouseenter", () => clearTimeout(this.timeoutId))
    this.element.addEventListener("mouseleave", () => this.startTimer())

    this.startTimer()
  }

  startTimer() {
    this.timeoutId = setTimeout(() => this.dismiss(), this.timeoutValue)
  }

  dismiss() {
    this.element.style.transition = "transform 0.4s ease-in"
    // ヘッダー(56px)分も含めて確実に裏に隠れる量
    this.element.style.transform = "translateY(calc(-100% - 56px))"

    setTimeout(() => this.element.remove(), 400)
  }

  disconnect() {
    clearTimeout(this.timeoutId)
  }
}