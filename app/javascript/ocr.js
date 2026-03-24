document.addEventListener("DOMContentLoaded", () => {
  const input = document.getElementById("imageInput")
  const status = document.getElementById("ocrStatus")
  if (!input) return

  input.addEventListener("change", async (e) => {
    const file = e.target.files[0]
    if (!file) return

    status.textContent = "読み取り中..."

    const formData = new FormData()
    formData.append("image", file)

    try {
      const res = await fetch("/ocr", {
        method: "POST",
        body: formData
      })

      const data = await res.json()

      if (data.expiration) {
        document.getElementById("expirationField").value = data.expiration
        status.textContent = ""
      } else {
        status.textContent = "読み取れませんでした"
      }
    } catch (error) {
      console.error(error)
      status.textContent = "エラーが発生しました"
    }
  })
})