/**
 * StreetBite documentation — language toggle, shared by every page.
 * The choice is stored once and replayed on load, so all 18 pages agree.
 */
(function () {
  "use strict";
  var body = document.body;
  var buttons = Array.prototype.slice.call(document.querySelectorAll(".langbar button"));
  function apply(lang) {
    body.dataset.lang = lang;
    buttons.forEach(function (b) {
      b.setAttribute("aria-pressed", String(b.dataset.lang === lang));
    });
    try { localStorage.setItem("streetbite-doc-lang", lang); } catch (e) {}
  }
  buttons.forEach(function (b) {
    b.addEventListener("click", function () { apply(b.dataset.lang); });
  });
  var saved = null;
  try { saved = localStorage.getItem("streetbite-doc-lang"); } catch (e) {}
  if (saved === "en" || saved === "ar" || saved === "both") { apply(saved); }
})();
