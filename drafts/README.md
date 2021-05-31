---
title: Draft folder
layout: post
featured: false
public: false
---

The files in this folder will not appear in the sitemap due to the following option:

```yaml
defaults:
  - scope:
      path: 'drafts/**'
    values:
      sitemap: false
```

Will not appear in menu bar unless Front Matter `public: true`.

You can use it to pre-visualize a draft.


