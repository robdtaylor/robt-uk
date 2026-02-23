---
title: "I built a personal AI. Here's the stack."
date: 2026-02-17
draft: false
description: "The actual architecture behind a Personal AI Infrastructure — Claude Code, skills system, n8n automation, and why it costs under £50/month."
tags: ["The Agent Stack", "AI Agents", "Claude Code", "Personal AI", "n8n"]
---

*The Agent Stack #001 — Monday Build*

---

Last week I asked an AI to scan my MCP server configs for security vulnerabilities, build a CLI tool to automate the checks, add baseline diffing, and publish it to npm. It did all of it across a few sessions. No copy-pasting from Stack Overflow. No scaffolding by hand. Conversations that produce working software.

That's not a demo. That's my normal workflow now.

## The Stack That Makes This Work

I run what I call a Personal AI Infrastructure — Claude Code as the brain, with a skills system that gives it deep context about my work, my tools, and my preferences. Think of it like muscle memory for an AI.

Here's the actual architecture:

```
Claude Code (CLI)
  ├── Skills (60+ context modules)
  ├── n8n (workflow automation, self-hosted)
  ├── Obsidian (knowledge base, semantic search)
  ├── MCP Servers (browser, Docker, Obsidian)
  └── Multi-agent spawning (parallel research, builds)
```

The skills are the interesting bit. Each one is a markdown file that teaches the AI about a specific domain — manufacturing processes, infrastructure details, deployment patterns, even personality calibration. When I say "deploy this to the VPS", the AI already knows which server, which port range, and how to configure Traefik. No explanation needed.

The result: I don't use AI as a chatbot. I use it as a technical partner that remembers everything and can operate my infrastructure.

**What this took to build:** About three months of evening work. The core is just Claude Code with good context management. The skills system is markdown files in a directory. n8n handles the automation. It's not complex — it's just well-organised.

**What it costs:** Claude Pro subscription, a £12/month VPS, and whatever API calls the agents make. Under £50/month total.

## Why The Agent Stack Exists

Most AI newsletters tell you what happened. This one shows you what to build.

I'm a practitioner. I build agents that do real work — automate research, manage infrastructure, generate reports, scan for security issues. Every edition of The Agent Stack comes from something I actually built, broke, or figured out.

Three editions per week:
- **Monday:** Build something. Walkthroughs with real code.
- **Wednesday:** Stack reviews. Tools and frameworks tested in production, not in theory.
- **Friday:** Signal. What happened this week that changes how you build agents.

No hype. No "revolutionary AI breakthrough" headlines. Just what works.

## Quick Hits

- **Claude Code now supports multi-agent teams** — Spawn parallel agents that coordinate via shared task lists. I use this daily for research. Game-changer for complex builds.
- **n8n raised $180M at $2.5B valuation** — The workflow automation tool I use for everything. 75% of their customers now use AI tools. The agent infrastructure market is real.
- **Gartner says 40% of enterprise apps will feature agents by end of 2026** — Bold claim. Based on what I'm seeing, the number for *useful* agents is closer to 5%. But that 5% is transformative.

## One Thing to Try

Install Claude Code and create your first skill file. Make a file at `~/.claude/skills/MyProject/SKILL.md` with context about a project you're working on — tech stack, deployment details, coding conventions. Next time you work on that project, the AI already knows. It's the simplest force multiplier I've found.

---

*This is edition one. If you're reading this, you're early. That's usually the best time to be somewhere.*
