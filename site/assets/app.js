(() => {
  const navLinks = document.querySelectorAll('[data-view-link]');
  const details = document.querySelectorAll('details[data-stage]');

  function openHashTarget() {
    const raw = window.location.hash.slice(1);
    if (!raw) return;
    const target = document.getElementById(raw);
    if (target?.tagName === 'DETAILS') target.open = true;
    navLinks.forEach(link => {
      const selected = link.getAttribute('href') === `#${raw}`;
      if (selected) link.setAttribute('aria-current', 'location');
      else link.removeAttribute('aria-current');
    });
  }

  document.querySelectorAll('[data-expand-all]').forEach(button => {
    button.addEventListener('click', () => {
      const shouldOpen = button.getAttribute('aria-pressed') !== 'true';
      details.forEach(item => { item.open = shouldOpen; });
      button.setAttribute('aria-pressed', String(shouldOpen));
      button.textContent = shouldOpen ? 'Contraer todos los pasos' : 'Ampliar todos los pasos';
    });
  });

  window.addEventListener('hashchange', openHashTarget);
  openHashTarget();
})();
