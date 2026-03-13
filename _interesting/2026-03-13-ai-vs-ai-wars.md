---
title: AI vs AI Wars !!
date: 2026-03-13T08:15:00.000+05:30
layout: interesting
author_profile: true
comments: true
---
A bot powered by Claude started exploiting a less secure configuration called `pull_request_target` in GitHub Actions Workflow, gaining code execution capabilities on Base repository using it’s secrets. 

It wiped almost all old releases for a famous security tool called [Trviy](https://github.com/aquasecurity/trivy). Those releases are not coming back fully as per aqua security. The same attack was carried out on multiple repositories which were found vulnerable. One of the repo from Ambient had Claude as code reviewer. It flagged this behaviour as suspicious and blocked the attempt by hackerclaw-bot. It essentially became Claude vs Claude 🙂

Further Read : <https://exagentica.ai/blog/hackerbot-claw-ai-agent-attack/>
