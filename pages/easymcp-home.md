---
layout: page
title: Proyectos con MCP2221
public: true
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

