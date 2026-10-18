# -*- coding: utf-8 -*-
"""Build the multi-page Manual QA dashboard in manual_qa/dashboard/.

Reads TestPlan_and_TestCases.xlsx and emits index.html + styles.css at the
dashboard root plus pages/00..09. Metrics are computed from the *Test Cases*
sheet (the real execution record), not from the Traceability sheet, which still
carries the original baseline plan ("51 passed"). The dashboard is English only
on purpose: the QA evidence is not translated, and fabricating an Arabic column
would be worse than omitting it.

Run:  python manual_qa/scripts/build_qa_dashboard.py
"""
import html
import io
import os
import re
import sys

import openpyxl

BASE = os.path.dirname(os.path.abspath(__file__))          # .../manual_qa/scripts
ROOT = os.path.dirname(BASE)                               # .../manual_qa
DASH = os.path.join(ROOT, "dashboard")
PAGES = os.path.join(DASH, "pages")
WB_PATH = os.path.join(ROOT, "TestPlan_and_TestCases.xlsx")

COMMIT = "8b37078"
DATE = "2026-10-18"

sys.stdout.reconfigure(encoding="utf-8", errors="replace")


def esc(s):
    return html.escape("" if s is None else str(s), quote=True)


# --------------------------------------------------------------------------- #
# 1.  Load the workbook
# --------------------------------------------------------------------------- #
def load():
    wb = openpyxl.load_workbook(WB_PATH, data_only=True)
    data = {"plan": [], "cases": [], "trace": [], "defects": []}

    # ---- Test Plan: "N. Title" section markers, then (key,item,detail) rows
    ws = wb["Test Plan"]
    section = None
    for r in ws.iter_rows(min_row=1, values_only=True):
        a, b, c = (r + (None, None, None))[:3]
        if a is None and b is None and c is None:
            continue
        astr = str(a).strip() if a is not None else ""
        if re.match(r"^\d+\.\s", astr):
            section = {"title": astr, "rows": []}
            data["plan"].append(section)
            continue
        if astr == "Key":          # the repeated column header
            continue
        if section is not None and (astr or b or c):
            section["rows"].append((astr, b, c))

    # ---- Test Cases
    ws = wb["Test Cases"]
    header = None
    cols = {}
    for i, r in enumerate(ws.iter_rows(min_row=1, values_only=True), start=1):
        if r and str(r[0]).strip() == "Case ID":
            header = [str(x).strip() if x else "" for x in r]
            cols = {name: j for j, name in enumerate(header)}
            start = i + 1
            break
    for r in ws.iter_rows(min_row=start, values_only=True):
        if not r or r[0] is None:
            continue
        cid = str(r[cols["Case ID"]]).strip()
        if not cid:
            continue
        data["cases"].append({
            "id": cid,
            "suite": (r[cols["Suite"]] or "").strip(),
            "title": (r[cols["Title"]] or "").strip(),
            "pre": (r[cols["Pre-condition"]] or "").strip(),
            "steps": (r[cols["Test Steps"]] or "").strip(),
            "expected": (r[cols["Expected Result"]] or "").strip(),
            "actual": (r[cols["Actual Result"]] or "").strip(),
            "status": (r[cols["Status"]] or "").strip(),
            "req": (r[cols["Requirement"]] or "").strip(),
            "defect": (r[cols["Defect ID"]] or "").strip(),
            "priority": (r[cols["Priority"]] or "").strip(),
        })

    # ---- Traceability (requirement -> listed cases)
    ws = wb["Traceability"]
    for r in ws.iter_rows(min_row=1, values_only=True):
        if r and r[0] and re.match(r"^(FR|NFR|SOLID)", str(r[0]).strip()):
            req_id = str(r[0]).strip()
            requirement = (r[1] or "").strip()
            listed = [c.strip() for c in str(r[2] or "").split(",") if c.strip()]
            data["trace"].append({"req": req_id, "requirement": requirement,
                                   "cases": listed})

    # ---- Defect Log
    ws = wb["Defect Log"]
    dheader = None
    for i, r in enumerate(ws.iter_rows(min_row=1, values_only=True), start=1):
        if r and str(r[0]).strip() == "Jira Key":
            dheader = {str(x).strip(): j for j, x in enumerate(r) if x}
            dstart = i + 1
            break
    for r in ws.iter_rows(min_row=dstart, values_only=True):
        if not r or r[0] is None:
            continue
        key = str(r[0]).strip()
        if not key.startswith("SB-"):
            continue
        g = lambda name: (r[dheader[name]] if dheader.get(name) is not None else None)
        data["defects"].append({
            "key": key,
            "case": (g("Test Case") or "").strip(),
            "summary": (g("Summary") or "").strip(),
            "severity": (g("Severity") or "").strip(),
            "priority": (g("Priority") or "").strip(),
            "component": (g("Component") or "").strip(),
            "status": (g("Status") or "").strip(),
            "cause": (g("Root Cause / Fix") or "").strip(),
        })
    return data


# --------------------------------------------------------------------------- #
# 2.  Derived metrics (honest, from the execution record)
# --------------------------------------------------------------------------- #
def metrics(cases):
    total = len(cases)
    passed = sum(1 for c in cases if c["status"].lower() == "pass")
    failed = sum(1 for c in cases if c["status"].lower() == "fail")
    blocked = sum(1 for c in cases if c["status"].lower() == "blocked")
    return {"total": total, "passed": passed, "failed": failed, "blocked": blocked}


# --------------------------------------------------------------------------- #
# 3.  Small render helpers
# --------------------------------------------------------------------------- #
def pill(text, kind=None):
    t = (text or "").strip()
    low = t.lower()
    if kind is None:
        if low == "pass":
            kind = "pass"
        elif low == "fail":
            kind = "fail"
        elif low == "blocked":
            kind = "blocked"
        elif low.startswith("partially"):
            kind = "part"
        elif low.startswith("fixed"):
            kind = "fixed"
        elif "open" in low:
            kind = "open"
        else:
            kind = "blocked"
    return '<span class="pill %s">%s</span>' % (kind, esc(t))


def sev(text):
    t = (text or "").strip()
    cls = t.lower() if t.lower() in ("critical", "high", "medium", "low") else "low"
    return '<span class="sev %s">%s</span>' % (cls, esc(t))


def steps_to_html(text):
    """Turn a numbered multiline cell into an ordered list."""
    lines = [ln.strip() for ln in re.split(r"\r?\n", text) if ln.strip()]
    cleaned = [re.sub(r"^\d+\.\s*", "", ln) for ln in lines]
    if not cleaned:
        return esc(text)
    items = "".join("<li>%s</li>" % esc(ln) for ln in cleaned)
    return "<ol>%s</ol>" % items


# --------------------------------------------------------------------------- #
# 4.  Page metadata + shell
# --------------------------------------------------------------------------- #
NAV = [
    ("Overview", [
        ("00-overview.html", "00", "Dashboard & status"),
    ]),
    ("Test Plan", [
        ("01-test-plan.html", "01", "Plan, objectives, scope"),
        ("02-environment.html", "02", "Environment & criteria"),
    ]),
    ("Test Cases", [
        ("03-cases-auth.html", "03", "Login & Sign Up"),
        ("04-cases-home.html", "04", "Home & Meal details"),
        ("05-cases-order.html", "05", "Cart & Map"),
        ("06-cases-profile.html", "06", "Profile & General"),
    ]),
    ("Coverage & Defects", [
        ("07-traceability.html", "07", "Traceability matrix"),
        ("08-defects.html", "08", "Defect log"),
    ]),
    ("Evidence & Closure", [
        ("09-evidence.html", "09", "Evidence & closure"),
    ]),
]
FLAT = [p for _g, items in NAV for p in items]          # (file, num, label)
INDEX_NOTE = "Manual QA pack \u00b7 build 1.0.0+3"


def nav_html(active, prefix, home):
    out = ['  <div class="brand">StreetBite<span>%s</span></div>' % esc(INDEX_NOTE)]
    for group, items in NAV:
        out.append("  <h3>%s</h3>" % esc(group))
        out.append("  <ol>")
        for fname, num, label in items:
            cur = ' class="cur"' if fname == active else ""
            out.append('    <li><a href="%s%s"%s><b>%s</b>%s</a></li>'
                       % (prefix, fname, cur, num, esc(label)))
        out.append("  </ol>")
    out.append('  <p class="home"><a href="%s">\u2191 Dashboard index</a></p>' % home)
    return "\n".join(out)


def shell(num, title, sub, body, active, asset, prefix, home, prev_file, next_file):
    crumb = ('<p class="crumb"><a href="%s">Dashboard</a> \u00b7 '
             '<span>Section %s of 10</span></p>' % (home, num)) if active else ""
    pager = []
    if prev_file or next_file:
        pager.append('<nav class="pager">')
        if prev_file:
            pl = dict((f, l) for f, _n, l in FLAT)[prev_file]
            pager.append('  <a href="%s"><span class="lbl">\u2190 Previous</span>'
                         '<span class="to">%s \u00b7 %s</span></a>'
                         % (prev_file, esc(prev_file[:2]), esc(pl)))
        else:
            pager.append('  <span></span>')
        if next_file:
            nl = dict((f, l) for f, _n, l in FLAT)[next_file]
            pager.append('  <a class="next" href="%s"><span class="lbl">Next \u2192</span>'
                         '<span class="to">%s \u00b7 %s</span></a>' % (next_file, esc(next_file[:2]), esc(nl)))
        pager.append("</nav>")
    pager = "\n".join(pager)
    foot = ('<footer class="footline">StreetBite QA \u00b7 generated from '
            '<code>TestPlan_and_TestCases.xlsx</code> \u00b7 commit <code>%s</code> \u00b7 %s</footer>'
            % (COMMIT, DATE))
    return """<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>%s \u00b7 StreetBite QA</title>
<link rel="stylesheet" href="%sstyles.css">
</head>
<body>
<nav id="toc">
%s
</nav>
<main>
%s<header class="doc"><h1>%s</h1><p class="sub">%s</p></header>
%s
%s
%s
</main>
<a class="top" href="#">\u2191 Top</a>
</body>
</html>
""" % (esc(title), asset, nav_html(active, prefix, home), crumb,
       esc(title), esc(sub), body, pager, foot)


# --------------------------------------------------------------------------- #
# 5.  Page bodies
# --------------------------------------------------------------------------- #
def metrics_block(m):
    pct = round(100.0 * m["passed"] / m["total"]) if m["total"] else 0
    return """
<div class="metricgrid">
  <div class="metric"><div class="big">%d</div><div class="lbl">Total cases</div></div>
  <div class="metric ok"><div class="big">%d</div><div class="lbl">Executed &amp; passed</div></div>
  <div class="metric warn"><div class="big">%d</div><div class="lbl">Blocked</div></div>
  <div class="metric%s"><div class="big">%d</div><div class="lbl">Failed</div></div>
  <div class="metric"><div class="big">%d%%</div><div class="lbl">Pass rate</div></div>
</div>
<div class="bar" title="%d of %d cases passed"><i style="width:%d%%"></i></div>
""" % (m["total"], m["passed"], m["blocked"], " bad" if m["failed"] else "", m["failed"],
       pct, m["passed"], m["total"], pct)


def page_overview(data, m):
    defects = data["defects"]
    open_def = sum(1 for d in defects if "open" in d["status"].lower())
    fixed = sum(1 for d in defects if d["status"].lower().startswith("fixed"))
    part = sum(1 for d in defects if d["status"].lower().startswith("partially"))
    cards = []
    for fname, num, label in FLAT[1:]:
        cards.append('  <a class="card" href="%s"><div class="no">%s</div>'
                     '<div class="tt">%s</div></a>' % (fname, num, esc(label)))
    cards = "\n".join(cards)
    body = """
<section>
  <h2><span class="num">00</span> \u00b7 Dashboard &amp; status</h2>
  <div class="warn"><b>Not ready to close</b>
    %d of %d cases have been executed and passed; the remaining %d are recorded as
    <b>Blocked</b>, not assumed green. An honest %d/%d is worth more than a
    fabricated %d/%d. See the <a href="../../README.md">QA README</a> and
    <a href="../../TestClosureSummary.pdf">Test Closure Summary</a>.</div>
  %s
</section>
<section>
  <h3>Defect picture</h3>
  <div class="metricgrid">
    <div class="metric"><div class="big">%d</div><div class="lbl">Defects raised</div></div>
    <div class="metric ok"><div class="big">%d</div><div class="lbl">Fixed</div></div>
    <div class="metric warn"><div class="big">%d</div><div class="lbl">Partially fixed</div></div>
    <div class="metric bad"><div class="big">%d</div><div class="lbl">Open (SB-119)</div></div>
  </div>
  <p>Every defect was invisible to <code>flutter analyze</code> and
     <code>flutter test</code>, which stayed green throughout \u2014 the strongest
     argument for the device round and the Appium round. The
     <a href="08-defects.html">defect log</a> mirrors the Jira board one-to-one.</p>
</section>
<section>
  <h3>Sections</h3>
  <div class="cards">
%s
  </div>
</section>
""" % (m["passed"], m["total"], m["blocked"], m["passed"], m["total"], m["total"], m["total"],
       metrics_block(m), len(defects), fixed, part, open_def, cards)
    return body


def page_plan(data):
    # map section titles we care about
    secs = {s["title"]: s["rows"] for s in data["plan"]}

    def tbl(title, headers=("Key", "Item", "Detail")):
        rows = secs.get(title, [])
        out = ['<table class="tbl"><thead><tr>'
               + "".join("<th>%s</th>" % esc(h) for h in headers) + "</tr></thead><tbody>"]
        for a, b, c in rows:
            out.append("<tr><td><code>%s</code></td><td>%s</td><td>%s</td></tr>"
                       % (esc(a), esc(b), esc(c)))
        out.append("</tbody></table>")
        return "\n".join(out)

    body = """
<section>
  <h2><span class="num">01</span> \u00b7 Test plan, objectives &amp; scope</h2>
  <p>The plan below is transcribed from the <b>Test Plan</b> sheet of
     <code>TestPlan_and_TestCases.xlsx</code>. It governs the manual round run
     against the release APK <code>1.0.0+3</code>.</p>
</section>
<section><h3>1. Reference documents</h3>%s</section>
<section><h3>2. Objectives</h3>%s</section>
<section><h3>3. Scope</h3>%s</section>
<section><h3>4. Testing types</h3>%s</section>
""" % (tbl("1. Reference documents"), tbl("2. Objectives"),
       tbl("3. Scope"), tbl("4. Testing types"))
    return body


def page_cases(data, title, num, suites, intro):
    body = ['<section><h2><span class="num">%s</span> \u00b7 %s</h2>%s</section>'
            % (num, esc(title), intro)]
    for suite in suites:
        group = [c for c in data["cases"] if c["suite"] == suite]
        if not group:
            continue
        passed = sum(1 for c in group if c["status"].lower() == "pass")
        body.append('<div class="suitehead" id="%s">%s &mdash; %d passed / %d</div>'
                    % (esc("suite-" + suite.lower()), esc(suite), passed, len(group)))
        for c in group:
            body.append(case_block(c))
    return "\n".join(body)


def case_block(c):
    anchor = c["id"]
    parts = ['<div class="case" id="%s">' % esc(anchor)]
    parts.append('  <div class="ch"><code>%s</code><span class="t">%s</span>%s</div>'
                 % (esc(c["id"]), esc(c["title"]), pill(c["status"])))
    parts.append('  <div class="bd"><dl class="kv">')
    parts.append("    <dt>Pre-condition</dt><dd>%s</dd>" % esc(c["pre"]))
    parts.append("    <dt>Steps</dt><dd>%s</dd>" % steps_to_html(c["steps"]))
    parts.append("    <dt>Expected</dt><dd>%s</dd>" % esc(c["expected"]))
    parts.append("    <dt>Actual</dt><dd>%s</dd>" % esc(c["actual"]))
    req = '<code>%s</code>' % esc(c["req"]) if c["req"] else "&mdash;"
    defid = pill(c["defect"], "fail") if c["defect"] and c["defect"] != "-" else "&mdash;"
    pr = esc(c["priority"]) if c["priority"] and c["priority"] != "-" else "&mdash;"
    parts.append("    <dt>Requirement</dt><dd>%s</dd>" % req)
    parts.append("    <dt>Defect</dt><dd>%s</dd>" % defid)
    parts.append("    <dt>Priority</dt><dd>%s</dd>" % pr)
    parts.append("  </dl></div></div>")
    return "\n".join(parts)


def page_traceability(data, by_id):
    rows_html = []
    for t in data["trace"]:
        passed = blocked = fail = total = 0
        for cid in t["cases"]:
            c = by_id.get(cid)
            if not c:
                continue
            total += 1
            st = c["status"].lower()
            if st == "pass":
                passed += 1
            elif st == "fail":
                fail += 1
            else:
                blocked += 1
        if total:
            res = pill("Passed", "pass") if (passed == total and fail == 0) else \
                (pill("Failed", "fail") if fail else pill("Partial", "blocked"))
        else:
            res = pill("No cases", "blocked")
        rows_html.append(
            "<tr><td><code>%s</code></td><td>%s</td><td class='n'>%d</td>"
            "<td class='n' style='color:var(--green-d);font-weight:700'>%d</td>"
            "<td class='n'>%d</td><td>%s</td></tr>"
            % (esc(t["req"]), esc(t["requirement"]), total, passed, blocked, res))
    body = """
<section>
  <h2><span class="num">07</span> \u00b7 Traceability matrix</h2>
  <p>Requirement \u2192 case mapping is taken from the <b>Traceability</b> sheet, but
     the <i>Passed / Blocked</i> columns are recomputed here from each listed case's
     real execution status in the <b>Test Cases</b> sheet.</p>
  <div class="warn"><b>Why this differs from the workbook</b>
    The Traceability sheet still shows the <i>baseline plan</i> ("51 passed, 0
    blocked"). The dashboard never copies that number: it reports what was actually
    observed on the device. A requirement is only marked <i>Passed</i> when every
    case mapped to it has passed.</div>
  <table class="tbl"><thead><tr><th>Req</th><th>Requirement</th><th>Cases</th>
    <th>Passed</th><th>Blocked</th><th>Result</th></tr></thead><tbody>
%s
  </tbody></table>
</section>
""" % "\n".join(rows_html)
    return body


def page_defects(data):
    rows = []
    for d in data["defects"]:
        rows.append(
            "<tr><td><code>%s</code></td><td>%s</td><td>%s</td><td>%s</td>"
            "<td>%s</td><td>%s</td></tr>"
            % (esc(d["key"]), esc(d["case"]), esc(d["summary"]), sev(d["severity"]),
               esc(d["component"]), pill(d["status"])))
    blocks = []
    for d in data["defects"]:
        blocks.append(
            '<div class="case" id="%s"><div class="ch"><code>%s</code>'
            '<span class="t">%s</span>%s</div><div class="bd"><dl class="kv">'
            "<dt>Case</dt><dd><code>%s</code></dd>"
            "<dt>Severity</dt><dd>%s &middot; priority %s</dd>"
            "<dt>Component</dt><dd>%s</dd>"
            "<dt>Status</dt><dd>%s</dd>"
            "<dt>Root cause / fix</dt><dd>%s</dd>"
            "</dl></div></div>"
            % (esc(d["key"]), esc(d["key"]), esc(d["summary"]), sev(d["severity"]),
               esc(d["case"]), sev(d["severity"]), esc(d["priority"]),
               esc(d["component"]), pill(d["status"]), esc(d["cause"])))
    body = """
<section>
  <h2><span class="num">08</span> \u00b7 Defect log</h2>
  <p>14 defects (<code>SB-106</code>\u2026<code>SB-119</code>) raised against the
     release APK, mirroring the Jira board. 13 are fixed; <code>SB-119</code>
     (Google Maps key) is <b>open</b> \u2014 a credential/billing problem, not a code
     problem, and intentionally not committed.</p>
  <table class="tbl"><thead><tr><th>Key</th><th>Case</th><th>Summary</th>
    <th>Severity</th><th>Component</th><th>Status</th></tr></thead><tbody>
%s
  </tbody></table>
</section>
<section><h3>Detail</h3>
%s
</section>
""" % ("\n".join(rows), "\n".join(blocks))
    return body


def page_evidence(data, m):
    shots = [
        ("01_splash.png", "Splash during session restore"),
        ("02_login_error.png", "Login SnackBar on a rejected sign-in"),
        ("03_signup.png", "Create-account form"),
        ("04_home_feed.png", "Home feed with the live meals grid"),
        ("05_home_arabic.png", "Arabic (RTL), Arabic-Indic digits"),
        ("06_cart_empty.png", "Empty-cart state"),
        ("07_meal_details.png", "Meal details: favourite + add-to-cart"),
        ("08_vendor_map_info.png", "Vendor map with a selected info window"),
        ("09_profile_device.png", "Profile behind the gate, device info"),
        ("10_dark_mode.png", "Dark theme"),
        ("11_biometric_prompt.png", "In-app biometric gate on Profile"),
        ("12-cross-device-sync.png", "Cross-device Firestore continuity"),
    ]
    figs = []
    for fn, cap in shots:
        figs.append('  <figure class="shot"><img src="../../screenshots/%s" alt="%s">'
                    '<figcaption><b>%s</b><br>%s</figcaption></figure>'
                    % (esc(fn), esc(cap), esc(fn), esc(cap)))
    body = """
<section>
  <h2><span class="num">09</span> \u00b7 Evidence &amp; closure</h2>
  <p>Screenshots are numbered to line up with the case IDs. All were captured from
     the release APK on the physical handset below.</p>
  <div class="key"><b>Device used for the manual round</b>
     Xiaomi Redmi 24117RN76G &middot; Android 16 (API 36) &middot; 1080\u00d72400
     &middot; 480&nbsp;dpi &middot; release APK
     <code>build/app/outputs/flutter-apk/app-release.apk</code>.
     The Appium suite ran against the same handset (6/6 passing).</div>
</section>
<section>
  <h3>Execution summary</h3>%s
  <p>The pack is <b>not ready to close</b>: %d of %d cases passed, %d blocked,
     one High defect (<code>SB-119</code>) open. The full plan, cases and defect
     log live in <a href="../../TestPlan_and_TestCases.xlsx">the workbook</a> and
     <a href="../../TestClosureSummary.pdf">the closure summary</a>.</p>
</section>
<section>
  <h3>Screenshots</h3>
  <div class="shots">
%s
  </div>
</section>
""" % (metrics_block(m), m["passed"], m["total"], m["blocked"], "\n".join(figs))
    return body


# --------------------------------------------------------------------------- #
# 6.  Build everything
# --------------------------------------------------------------------------- #
def build():
    data = load()
    m = metrics(data["cases"])
    by_id = {c["id"]: c for c in data["cases"]}
    os.makedirs(PAGES, exist_ok=True)

    # (num, file, title, sub, builder(data)->html body)
    builders = {
        "00-overview.html": lambda: page_overview(data, m),
        "01-test-plan.html": lambda: page_plan(data),
        "02-environment.html": lambda: page_environment_body(data, m),
        "03-cases-auth.html": lambda: page_cases(
            data, "Login & Sign Up", "03", ["Login", "Sign Up"],
            "<p>Authentication flows: Firebase login, client-side validation, "
            "session restore, and the sign-up rules. This suite is the most fully "
            "executed of the round.</p>"),
        "04-cases-home.html": lambda: page_cases(
            data, "Home & Meal details", "04", ["Home", "Meal details"],
            "<p>The live TheMealDB feed, scrolling, Hot Offers, the theme and "
            "language toggles, and the meal details screen.</p>"),
        "05-cases-order.html": lambda: page_cases(
            data, "Cart & Map", "05", ["Cart", "Map"],
            "<p>Cart state, totals, the SOLID payment strategies and checkout, plus "
            "the vendor map. The map cases are blocked by the open "
            "<code>SB-119</code> credential issue.</p>"),
        "06-cases-profile.html": lambda: page_cases(
            data, "Profile & General", "06", ["Profile", "General"],
            "<p>The biometric profile gate, device info, Firestore-backed lists, and "
            "the cross-cutting responsive / localization / theme cases.</p>"),
        "07-traceability.html": lambda: page_traceability(data, by_id),
        "08-defects.html": lambda: page_defects(data),
        "09-evidence.html": lambda: page_evidence(data, m),
    }

    files = [f for _g, items in NAV for f, _n, _l in items]
    for i, fname in enumerate(files):
        num = fname[:2]
        title = dict((f, l) for f, _n, l in FLAT)[fname]
        prev_f = files[i - 1] if i > 0 else None
        next_f = files[i + 1] if i + 1 < len(files) else None
        body = builders[fname]()
        page = shell(num, title, "StreetBite \u00b7 Manual QA \u00b7 build 1.0.0+3",
                     body, fname, "../", "", "../index.html", prev_f, next_f)
        write(os.path.join(PAGES, fname), page)

    write_index(data, m)
    print("wrote index.html + %d pages to %s" % (len(files), DASH))


def page_environment_body(data, m):
    secs = {s["title"]: s["rows"] for s in data["plan"]}

    def tbl(title):
        rows = secs.get(title, [])
        out = ['<table class="tbl"><thead><tr><th>Key</th><th>Item</th>'
               "<th>Detail</th></tr></thead><tbody>"]
        for a, b, c in rows:
            out.append("<tr><td><code>%s</code></td><td>%s</td><td>%s</td></tr>"
                       % (esc(a), esc(b), esc(c)))
        out.append("</tbody></table>")
        return "\n".join(out)

    return """
<section>
  <h2><span class="num">02</span> \u00b7 Environment, criteria &amp; risks</h2>
  <p>The manual round and the Appium suite both ran on the physical Xiaomi
     <code>24117RN76G</code> (Android 16, 1080\u00d72400), which makes the manual and
     automated results comparable rather than anecdotal \u2014 see the
     <a href="09-evidence.html">evidence page</a>. The Test Plan sheet lists the
     originally planned emulators; the round was executed on hardware.</p>
</section>
<section><h3>5. Test environment</h3>%s</section>
<section><h3>6. Entry criteria</h3>%s</section>
<section><h3>7. Exit criteria</h3>
  <div class="warn"><b>Exit status</b>
     X1\u2013X2 are <b>not met</b>: only %d of %d cases were executed, so Login/Home
     coverage is partial and total coverage is below 95%%. X3\u2013X4 are <b>not met</b>:
     <code>SB-119</code> (High) is still open. X5\u2013X7 hold for the cases that were
     run.</div>
  %s</section>
<section><h3>8. Risks &amp; mitigations</h3>%s</section>
<section><h3>9. Deliverables</h3>%s</section>
""" % (tbl("5. Test environment"), tbl("6. Entry criteria"),
       m["passed"], m["total"], tbl("7. Exit criteria"),
       tbl("8. Risks and mitigations"), tbl("9. Deliverables"))


def write_index(data, m):
    cards = []
    for _g, items in NAV:
        for fname, num, label in items:
            href = "pages/" + fname
            cards.append('  <a class="card" href="%s"><div class="no">%s</div>'
                         '<div class="tt">%s</div></a>' % (href, num, esc(label)))
    defects = data["defects"]
    open_def = sum(1 for d in defects if "open" in d["status"].lower())
    body = """
<section>
  <h2><span class="num">\u25cf</span> \u00b7 Manual QA dashboard</h2>
  <div class="warn"><b>Not ready to close</b>
     %d of %d cases executed &amp; passed, %d blocked, one High defect
     (<code>SB-119</code>) open. Automated regression (Appium) is 6/6 on the same
     device. Numbers come from the real execution record, never the baseline plan.</div>
  %s
</section>
<section>
  <h3>Sections</h3>
  <div class="cards">
%s
  </div>
  <p style="margin-top:18px">Source artefacts:
     <a href="../README.md">QA README</a> &middot;
     <a href="../TestPlan_and_TestCases.xlsx">workbook</a> &middot;
     <a href="../TestClosureSummary.pdf">closure summary</a> &middot;
     <a href="../scripts/">generators</a>.</p>
</section>
""" % (m["passed"], m["total"], m["blocked"], metrics_block(m), "\n".join(cards))
    htmlout = shell(None, "StreetBite \u2014 Manual QA dashboard",
                    "Test plan, execution record and evidence \u00b7 build 1.0.0+3",
                    body, None, "", "pages/", "index.html", None, None)
    write(os.path.join(DASH, "index.html"), htmlout)


def write(path, text):
    with io.open(path, "w", encoding="utf-8", newline="\n") as fh:
        fh.write(text)


if __name__ == "__main__":
    build()
