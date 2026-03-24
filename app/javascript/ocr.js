document.addEventListener("DOMContentLoaded", () => {
  const input = document.getElementById("imageInput")
  if (!input) return

  input.addEventListener("change", async (e) => {
    const file = e.target.files[0]
    if (!file) return

    const formData = new FormData()
    formData.append("image", file)

    const res = await fetch("/ocr", {
      method: "POST",
      body: formData
    })

    const data = await res.json()

    if (data.expiration) {
      document.getElementById("expirationField").value = data.expiration
    } else {
      alert("読み取れませんでした")
    }
  })
})