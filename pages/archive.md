---
layout: page
title: "Índice"
description: "Electrónica y ciencia - Archivo"
permalink: /archive/
public: true
order: B
---

{% assign postsByYear = site.posts | group_by_exp:"post", "post.date | date: '%Y'" %}

{% for year in postsByYear %}

### Año {{ year.name }}

<ul>
{% for post in year.items %}
  {%- if post.featured -%}
  <li><a href="{{post.url}}"><b>{{post.title}}</b></a></li>
  {%- else -%}
  <li><a href="{{post.url}}">{{post.title}}</a></li>
  {%- endif -%}
{% endfor %}
</ul>

{% endfor %}

