---
title: "Subscribe"
description: "Choose your newsletters. No spam, no hype, unsubscribe anytime."
layout: "single"
---

<style>
.nl-container { max-width: 640px; }
.nl-card {
    border: 1px solid var(--border);
    border-radius: 8px;
    padding: 1.25rem;
    margin-bottom: 1rem;
    position: relative;
    cursor: pointer;
    transition: border-color 0.15s;
}
.nl-card:hover { border-color: var(--primary, #58a6ff); }
.nl-card.selected { border-color: var(--primary, #58a6ff); background: rgba(88, 166, 255, 0.05); }
.nl-card input[type="checkbox"] {
    position: absolute;
    top: 1.25rem;
    right: 1.25rem;
    width: 18px;
    height: 18px;
    accent-color: var(--primary, #58a6ff);
    cursor: pointer;
}
.nl-card h3 { margin: 0 0 0.25rem 0; font-size: 1.1rem; }
.nl-badge {
    display: inline-block;
    font-size: 0.75rem;
    padding: 0.15rem 0.5rem;
    border-radius: 3px;
    background: rgba(88, 166, 255, 0.15);
    color: var(--primary, #58a6ff);
    margin-bottom: 0.5rem;
    font-weight: 500;
}
.nl-card p { margin: 0; font-size: 0.9rem; opacity: 0.85; }
.nl-card ul { margin: 0.5rem 0 0 0; padding-left: 1.25rem; font-size: 0.85rem; opacity: 0.75; }
.nl-card ul li { margin-bottom: 0.2rem; }
.nl-form { margin-top: 1.5rem; }
.nl-form-row { display: flex; gap: 0.5rem; max-width: 480px; }
.nl-form input[type="email"] {
    flex: 1;
    padding: 0.6rem 0.8rem;
    border: 1px solid var(--border);
    border-radius: 4px;
    background: var(--code-bg, #1e1e2e);
    color: var(--primary, #cdd6f4);
    font-size: 1rem;
}
.nl-form button {
    padding: 0.6rem 1.2rem;
    background: var(--primary, #58a6ff);
    color: var(--theme, #1e1e2e);
    border: none;
    border-radius: 4px;
    font-size: 1rem;
    cursor: pointer;
    font-weight: 500;
}
.nl-form button:disabled { opacity: 0.6; cursor: not-allowed; }
#form-message { margin-top: 0.5rem; font-size: 0.875rem; min-height: 1.25rem; }
#selection-hint { font-size: 0.85rem; opacity: 0.6; margin-top: 0.5rem; }
</style>

<div class="nl-container">

Pick what lands in your inbox. Free, no spam, unsubscribe anytime.

<div id="nl-cards">
<label class="nl-card selected" for="cb-agent-stack">
<input type="checkbox" id="cb-agent-stack" value="agent-stack" checked>
<h3>The Agent Stack</h3>
<span class="nl-badge">3x per week</span>
<p>For practitioners building with AI agents. Real implementations, actual code, honest assessments of what works.</p>
<ul>
<li>The week's most important AI agent developments</li>
<li>Quick hits -- notable things you should know about</li>
<li>One actionable thing to try</li>
</ul>
</label>

<label class="nl-card" for="cb-daily-briefing">
<input type="checkbox" id="cb-daily-briefing" value="daily-briefing">
<h3>AI Daily Briefing</h3>
<span class="nl-badge">Every weekday</span>
<p>Auto-curated daily digest of AI news, research, and industry moves. Delivered before your morning coffee.</p>
<ul>
<li>Key stories from across the AI landscape</li>
<li>New research and model releases</li>
<li>Industry and market signals</li>
</ul>
</label>
</div>

<p id="selection-hint"></p>

<form id="subscribe-form" class="nl-form">
    <div class="nl-form-row">
        <input type="email" id="email" placeholder="your@email.com" required>
        <button type="submit">Subscribe</button>
    </div>
    <p id="form-message"></p>
</form>

---

Past editions: [AI Newsletters](/newsletters/)

</div>

<script>
// Toggle card selection styling
document.querySelectorAll('.nl-card input[type="checkbox"]').forEach(cb => {
    cb.addEventListener('change', () => {
        cb.closest('.nl-card').classList.toggle('selected', cb.checked);
        updateHint();
    });
});

function getSelected() {
    return [...document.querySelectorAll('.nl-card input:checked')].map(cb => cb.value);
}

function updateHint() {
    const sel = getSelected();
    const hint = document.getElementById('selection-hint');
    if (sel.length === 0) {
        hint.textContent = 'Select at least one newsletter.';
        hint.style.color = '#f38ba8';
    } else {
        hint.textContent = '';
        hint.style.color = '';
    }
}

document.getElementById('subscribe-form').addEventListener('submit', async (e) => {
    e.preventDefault();
    const email = document.getElementById('email').value;
    const newsletters = getSelected();
    const msg = document.getElementById('form-message');
    const btn = e.target.querySelector('button');

    if (newsletters.length === 0) {
        msg.textContent = 'Pick at least one newsletter.';
        msg.style.color = '#f38ba8';
        return;
    }

    btn.disabled = true;
    btn.textContent = 'Subscribing...';
    msg.textContent = '';
    msg.style.color = '';

    try {
        const res = await fetch('/api/subscribe', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ email, newsletters })
        });
        const data = await res.json();

        if (res.ok) {
            const count = newsletters.length === 2 ? 'both newsletters' : 'the newsletter';
            msg.textContent = "You're in for " + count + ". Check your inbox.";
            msg.style.color = '#a6e3a1';
            document.getElementById('email').value = '';
        } else {
            msg.textContent = data.error || 'Something went wrong. Try again.';
            msg.style.color = '#f38ba8';
        }
    } catch {
        msg.textContent = 'Something went wrong. Try again.';
        msg.style.color = '#f38ba8';
    }

    btn.disabled = false;
    btn.textContent = 'Subscribe';
});
</script>
