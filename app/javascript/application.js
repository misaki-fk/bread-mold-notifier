// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

window.toggleDropdown = function(button) {
  const dropdown = button.nextElementSibling;
  dropdown.classList.toggle('hidden');
}

document.addEventListener('turbo:load', () => {
  document.removeEventListener('click', handleClick);
  document.addEventListener('click', handleClick);
});

function handleClick(e) {
  document.querySelectorAll('[data-dropdown]').forEach(drop => {
    if (!drop.contains(e.target)) {
      const menu = drop.children[1];
      if (menu) menu.classList.add('hidden');
    }
  });
}