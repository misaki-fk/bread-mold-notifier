import { Controller } from "@hotwired/stimulus"
console.log("carousel connected")
export default class extends Controller {
  static targets = ["track", "dots"]

  connect() {
    console.log("carousel connected")
    this.index = 0
    this.total = this.trackTarget.children.length
    this.isAnimating = false

    this.trackTarget.addEventListener("transitionend", (event) => {
      if (event.target !== this.trackTarget) return
      this._unlockAnimation()
    })

    this.createDots()
    this.update()

    // キーボード操作
    this._handleKeydown = (e) => {
      if (e.key === "ArrowLeft")  this.prev()
      if (e.key === "ArrowRight") this.next()
    }
    document.addEventListener("keydown", this._handleKeydown)
  }

  disconnect() {
    clearTimeout(this._animationTimeout)
    document.removeEventListener("keydown", this._handleKeydown)
  }

  next() {
    this.move(1)
  }

  prev() {
    this.move(-1)
  }

  move(direction) {
    if (this.isAnimating) return
    this.isAnimating = true

    // フォールバック：CSSトランジションの時間 + 余裕を持たせる
    this._animationTimeout = setTimeout(() => this._unlockAnimation(), 400)

    this.index = (this.index + direction + this.total) % this.total
    this.update()
    }

  _unlockAnimation() {
    this.isAnimating = false
    clearTimeout(this._animationTimeout)
  }

  goTo(index) {
    // 同じ位置をクリックした場合やアニメーション中は無視
    if (this.isAnimating || index === this.index) return

    this.isAnimating = true
    this._animationTimeout = setTimeout(() => this._unlockAnimation(), 400)
    this.index = index
    this.update()
  }

  update() {
    this.trackTarget.style.transform =
      `translateX(-${this.index * 100}%)`

    this.updateDots()
  }

  createDots() {
    for (let i = 0; i < this.total; i++) {
      const dot = document.createElement("button")
      dot.className =
        "w-3 h-3 rounded-full bg-gray-300 transition-colors duration-200"

      dot.addEventListener("click", () => {
        this.goTo(i)
      })

      this.dotsTarget.appendChild(dot)
    }
  }

  updateDots() {
    const dots = this.dotsTarget.querySelectorAll("button")

    dots.forEach((dot, i) => {
      dot.classList.toggle("bg-black", i === this.index)
      dot.classList.toggle("bg-gray-300", i !== this.index)
    })
  }
}