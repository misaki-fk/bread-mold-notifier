import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["track"]

  connect() {
    this.index = 0
    this.total = this.trackTarget.children.length
    this.isAnimating = false
  }

  next() {
    if (this.isAnimating) return
    this.move(1)
  }

  prev() {
    if (this.isAnimating) return
    this.move(-1)
  }

  move(direction) {
    this.isAnimating = true

    this.index = (this.index + direction + this.total) % this.total
    this.update()

    setTimeout(() => {
      this.isAnimating = false
    }, 300) // duration-300と合わせる
  }

  update() {
    this.trackTarget.style.transform =
      `translateX(-${this.index * 100}%)`
  }
}
