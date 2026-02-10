console.log("breads.js loaded");

document.addEventListener("turbo:load", () => {
  console.log("breads.js loaded");
  const form = document.getElementById("bread-form");
  if (!form) return;

  const signedIn = form.dataset.signedIn === "true";

  form.addEventListener("submit", (e) => {
    if (!signedIn) {
      e.preventDefault();
      saveToLocalStorage();
    }
  });
});

function saveToLocalStorage() {
  const bread = {
    id: Date.now(),
    bread_type_id: document.getElementById("bread_bread_type_id").value,
    total_count: Number(document.getElementById("bread_total_count").value),
    daily_consumption: Number(document.getElementById("bread_daily_consumption").value),
    expiration_date: document.getElementById("bread_expiration_date").value
  };

  const breads = JSON.parse(localStorage.getItem("guest_breads")) || [];
  breads.push(bread);
  localStorage.setItem("guest_breads", JSON.stringify(breads));

  console.log("保存後:", breads);

  alert("ゲストとしてパンを登録しました 🍞");
  window.location.href = "/home";
}