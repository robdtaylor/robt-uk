---
title: "Subscribe to The Agent Stack"
description: "Weekly newsletter about building AI agents. No hype, just what works."
layout: "single"
---

<div style="max-width: 600px;">

**What works in AI agents. No hype.**

A weekly newsletter for practitioners building with AI agents. Real implementations, actual code, honest assessments of what's working and what isn't.

### What you'll get

- **Friday Signal** -- The week's most important AI agent news, analysed for builders
- **Quick Hits** -- 3 notable developments you should know about
- **One Thing to Try** -- A single actionable step you can take this week

---

### Subscribe

Free. One email per week. Unsubscribe anytime.

<form id="subscribe-form" style="margin: 1.5rem 0;">
    <div style="display: flex; gap: 0.5rem; max-width: 480px;">
        <input type="email" id="email" placeholder="your@email.com" required
               style="flex: 1; padding: 0.6rem 0.8rem; border: 1px solid var(--border); border-radius: 4px; background: var(--code-bg, #1e1e2e); color: var(--primary, #cdd6f4); font-size: 1rem;">
        <button type="submit"
                style="padding: 0.6rem 1.2rem; background: var(--primary, #58a6ff); color: var(--theme, #1e1e2e); border: none; border-radius: 4px; font-size: 1rem; cursor: pointer; font-weight: 500;">Subscribe</button>
    </div>
    <p id="form-message" style="margin-top: 0.5rem; font-size: 0.875rem; min-height: 1.25rem;"></p>
</form>

---

Past editions are published at [AI Newsletters](/newsletters/).

</div>

<script>
document.getElementById('subscribe-form').addEventListener('submit', async (e) => {
    e.preventDefault();
    const email = document.getElementById('email').value;
    const msg = document.getElementById('form-message');
    const btn = e.target.querySelector('button');

    btn.disabled = true;
    btn.textContent = 'Subscribing...';
    msg.textContent = '';
    msg.style.color = '';

    try {
        const res = await fetch('/api/subscribe', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ email })
        });
        const data = await res.json();

        if (res.ok) {
            msg.textContent = "You're in. Check your inbox.";
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
