import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["track", "dots"]

  connect() {
    this.index = 0
    this.total = this.trackTarget.children.length
    this.isAnimating = false

    this.createDots()
    this.update()
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
    }, 300)
  }

  goTo(index) {
    if (this.isAnimating) return
    this.isAnimating = true

    this.index = index
    this.update()

    setTimeout(() => {
      this.isAnimating = false
    }, 300)
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

function deleteBread(id) {
  let breads = JSON.parse(localStorage.getItem("guest_breads")) || [];
  breads = breads.filter(bread => bread.id !== id);
  localStorage.setItem("guest_breads", JSON.stringify(breads));
}
