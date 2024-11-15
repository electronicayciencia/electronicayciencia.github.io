---
layout: page
title: Aprende electrónica con el MCP2221
head: MCP2221
public: true
order: 30
---

  {%- if site.easymcp.size > 0 -%}
    <ul>
      {%- for project in site.easymcp -%}
        <li>
          <a href="{{ project.url | relative_url }}">{{ project.title }}</a>
        </li>
      {%- endfor -%}
    </ul>
  {%- endif -%}

