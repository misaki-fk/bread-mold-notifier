import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "status", "field"]

  connect() {
    console.log("OCR controller connected")

    this.inputTarget.addEventListener("change", async (e) => {
      const file = e.target.files[0]
      if (!file) return

      this.statusTarget.textContent = "読み取り中..."

      const formData = new FormData()
      formData.append("image", file)

      try {
        const res = await fetch("/ocr", {
          method: "POST",
          body: formData
        })

        const data = await res.json()

        alert(JSON.stringify(data))

        if (data.expiration) {
          this.fieldTarget.value = data.expiration
          this.statusTarget.textContent = ""
        } else {
          this.statusTarget.textContent = "読み取れませんでした"
        }
      } catch (error) {
        console.error(error)
        this.statusTarget.textContent = "エラーが発生しました"
      }
    })
  }
}