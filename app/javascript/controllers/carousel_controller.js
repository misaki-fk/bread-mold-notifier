import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
  static targets = ["track", "dots"]

  connect() {
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

    // タッチ操作
    this._touchStartX = 0

    this._handleTouchStart = (e) => {
      // タッチ開始位置を記録
      this._touchStartX = e.touches[0].clientX
    }

    this._handleTouchEnd = (e) => {
      const diff = this._touchStartX - e.changedTouches[0].clientX

      if (Math.abs(diff) < 50) return // 50px未満の小さい動きは誤操作として無視

      // スワイプ方向に応じて次/前のスライドに移動
      diff > 0 ? this.next() : this.prev()
    }

    this.trackTarget.addEventListener("touchstart", this._handleTouchStart, { passive: true })
    document.addEventListener("touchend", this._handleTouchEnd, { passive: true })
  }

  disconnect() {
    clearTimeout(this._animationTimeout)
    document.removeEventListener("keydown", this._handleKeydown)
    this.trackTarget.removeEventListener("touchstart", this._handleTouchStart)
    document.removeEventListener("touchend", this._handleTouchEnd)
  }

  next() {this.move(1)}
  prev() {this.move(-1)}

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
    this.trackTarget.style.transform = `translateX(-${this.index * 100}%)`
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