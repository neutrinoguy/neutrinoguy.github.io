---
title: AI vs AI wars !!
date: 2026-03-13T07:59:00.000+05:30
layout: interesting
author_profile: true
comments: true
---
A bot powered by Claude started exploiting a known less secure configuration in the GitHub Action called `pull_request_target ` which runs with base repo’s secrets and allows code execution from external untrusted sources.\
\
It wiped out the old releases of a very famous security tool called [Trviy](https://github.com/aquasecurity/trivy). That releases are gone and not coming back fully. 

It targeted other repos as well and one of them had Claude as code reviewer bot. It realised that something was off and stop the attack, essentially it went Claude vs Claude 🙂

Interesting times !! 

Further Read: <https://exagentica.ai/blog/hackerbot-claw-ai-agent-attack/>
