import { Controller } from "@hotwired/stimulus"
console.log("OCR LOADED")

export default class extends Controller {
  static targets = ["input", "status", "field"]

  connect() {
    console.log("OCR controller connected")
  }

  upload(event) {
    console.log("upload called") // ←確認用

    const file = event.target.files[0]
    if (!file) return

    this.statusTarget.textContent = "読み取り中..."

    const formData = new FormData()
    formData.append("image", file)

    const token = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content')
    const headers = {}
    if (token) headers['X-CSRF-Token'] = token

    fetch("/ocr", {
      method: "POST",
      body: formData,
      headers: headers
    })
      .then(res => {
        if (!res.ok) {
          throw new Error(`HTTP ${res.status}`)
        }
        return res.json()
      })
      .then(data => {

        if (data.expiration) {
          this.fieldTarget.value = data.expiration
          this.statusTarget.textContent = ""
        } else {
          this.statusTarget.textContent = "読み取れませんでした"
        }
      })
      .catch(error => {
        console.error(error)
        this.statusTarget.textContent = "エラーが発生しました"
      })
  }
}