---
layout: archive
title: "Interesting Shorts"
permalink: /shorts/
author_profile: true
---

<div class="shorts-container">
  {% for post in site.interesting reversed %}
    <a href="{{ post.url | relative_url }}" class="short-row">
      <span class="short-title">{{ post.title }}</span>
      <span class="short-meta">
        {{ post.date | date: "%B %d, %Y" }}
      </span>
    </a>
  {% endfor %}
</div>

<style>
.shorts-container {
  display: flex;
  flex-direction: column;
  gap: 2px;
  margin-top: 20px;
}

.short-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 16px;
  border-radius: 6px;
  text-decoration: none !important;
  transition: all 0.2s ease;
  border: 1px solid transparent;
}

.short-title {
  font-size: 1.05rem;
  font-weight: 500;
  flex: 1;
  margin-right: 20px;
}

.short-meta {
  font-size: 0.85rem;
  white-space: nowrap;
  opacity: 0.6;
}

/* Light Mode */
.short-row {
  color: #333;
}

.short-row:hover {
  background: rgba(0, 0, 0, 0.05);
  transform: translateX(4px);
}

/* Dark Mode Support */
@media (prefers-color-scheme: dark) {
  .short-row {
    color: #e0e0e0;
  }

  .short-row:hover {
    background: rgba(255, 255, 255, 0.05);
  }

  .short-meta {
    color: #aaa;
  }
}
</style>
