/* StreetBite file-by-file guide — shared across every page (generated). */
(function () {
  "use strict";
  var body = document.body;
  var KEY = "streetbite-guide-lang";

  /* ---- language toggle: remembered once, replayed on every page ---- */
  var buttons = [].slice.call(document.querySelectorAll(".langbar button"));
  function apply(lang) {
    body.dataset.lang = lang;
    document.documentElement.lang = lang === "ar" ? "ar" : "en";
    buttons.forEach(function (b) {
      b.setAttribute("aria-pressed", String(b.dataset.lang === lang));
    });
    try { localStorage.setItem(KEY, lang); } catch (e) {}
  }
  buttons.forEach(function (b) {
    b.addEventListener("click", function () { apply(b.dataset.lang); });
  });
  var saved = null;
  try { saved = localStorage.getItem(KEY); } catch (e) {}
  if (saved === "en" || saved === "ar" || saved === "both") { apply(saved); }

  /* ---- cross-page file search (manifest lives in search-data.js) ---- */
  var box = document.getElementById("filter");
  var res = document.getElementById("results");
  if (!box || !res) { return; }
  var CARDS = window.GB_CARDS || [];

  function slug(s) {
    return s.replace(/[^0-9A-Za-z]+/g, "-").replace(/^-+|-+$/g, "").toLowerCase();
  }
  function esc(s) {
    return s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
  }
  function run() {
    var q = box.value.trim().toLowerCase();
    if (!q) { res.classList.remove("open"); res.innerHTML = ""; return; }
    var hits = [];
    for (var i = 0; i < CARDS.length && hits.length < 30; i++) {
      if (CARDS[i][0].toLowerCase().indexOf(q) > -1) { hits.push(CARDS[i]); }
    }
    if (!hits.length) {
      res.innerHTML = '<div class="nores">لا نتيجة · no match</div>';
      res.classList.add("open");
      return;
    }
    res.innerHTML = hits.map(function (h) {
      return '<a href="' + h[1] + "#file-" + slug(h[0]) + '"><code>' + esc(h[0]) + "</code></a>";
    }).join("");
    res.classList.add("open");
  }
  box.addEventListener("input", run);
  box.addEventListener("search", run);
  document.addEventListener("click", function (e) {
    if (!e.target.closest(".searchwrap")) { res.classList.remove("open"); }
  });
  document.addEventListener("keydown", function (e) {
    if (e.key === "Escape") { res.classList.remove("open"); box.blur(); }
  });
})();
