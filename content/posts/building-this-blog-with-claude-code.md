---
title: "I Built This Blog in 15 Minutes Using Only Natural Language"
date: 2025-01-10
draft: false
description: "How Claude Code turned a conversation into a fully deployed website at zero monthly cost."
tags: ["AI", "Claude Code", "web development"]
cover:
  image: "/images/claude-code-terminal.svg"
  alt: "Terminal showing Claude Code conversation"
  caption: "The entire build process happened through natural language"
---

I had no recent experience setting up websites. I had a domain name gathering dust. I had an idea for an AI blog.

Fifteen minutes later, you're reading the result.

## What is Claude Code?

Claude Code is Anthropic's command-line interface for Claude. Unlike chat interfaces where you ask questions and get answers, Claude Code can actually *do things* on your computer—read files, write code, run commands, and deploy infrastructure.

Think of it as pair programming with an AI that can type.

## The Conversation

Here's roughly how it went:

**Me:** "I'm thinking of starting a website and posting content on AI. How would that best be accomplished cost-effectively in the UK? I can provide a domain name but have no recent experience setting up websites."

**Claude:** Gave me options ranging from WordPress (easy) to Hugo + Cloudflare Pages (free, more technical).

**Me:** "I'd be happy paying up to £10 per month, but could you do all of it for me?"

**Claude:** Explained what it could handle (building the site, configuring everything, pushing to GitHub) and what I'd need to do (create two free accounts, authenticate once).

**Me:** "Build a clean Hugo site. My domain is robt.uk. Yes I have GitHub: robdtaylor"

And then I watched it work.

## What Happened Next

![The build pipeline](/images/stack-diagram.svg)

Claude Code:
- Installed Hugo on my Mac
- Created the site structure
- Added and configured the PaperMod theme
- Set up the content architecture
- Wrote the configuration for my domain
- Initialised Git, created the repo, pushed everything
- Gave me exact steps for Cloudflare Pages deployment

I authenticated with GitHub (30 seconds), clicked through Cloudflare's Pages setup (2 minutes), and the site was live.

Total hands-on time: maybe 5 minutes of clicking.

## The Stack

| Component | Cost |
|-----------|------|
| Hugo (static site generator) | £0 |
| Cloudflare Pages (hosting + CDN + SSL) | £0 |
| GitHub (source control) | £0 |
| Domain renewal | ~£10/year |
| **Monthly cost** | **£0** |

The site loads fast (static files served from edge locations worldwide), scales infinitely (no server to overload), and is secure by default (automatic HTTPS).

## Why This Matters

This isn't about building websites. Plenty of tools can do that.

This is about the friction collapse between intent and outcome.

I didn't learn Hugo's templating syntax. I didn't read Cloudflare's documentation. I didn't debug TOML configuration errors (Claude did—Hugo's pagination syntax had changed in a recent version, and it adapted on the fly).

I described what I wanted in plain English, and a capable agent figured out the implementation details.

## The Limits

Claude Code couldn't create accounts for me—that's a security boundary, and the right one. It couldn't enter my credentials. Those moments required my direct action.

But everything else? Handled.

## What I'm Watching

We're at the early edge of this capability curve. Today it's websites and scripts. Tomorrow it's more complex systems, more autonomous operation, more sophisticated reasoning about what you actually need versus what you literally asked for.

The gap between "I have an idea" and "it exists" is compressing rapidly.

---

*This post was written on a blog that was built by describing what I wanted to an AI in my terminal. The irony isn't lost on me.*
