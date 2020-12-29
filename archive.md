---
layout: page
title: "Archivo"
description: "Electrónica y ciencia - Archivo"
permalink: /archive/
---

{% assign postsByYear = site.posts | group_by_exp:"post", "post.date | date: '%Y'" %}

{% for year in postsByYear %}

### Año {{ year.name }}

{% for post in year.items %}- [{{post.title}}](post.url)
{% endfor %}

{% endfor %}

