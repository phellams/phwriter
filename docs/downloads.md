---
layout: default
title: Installation & Downloads
nav_order: 2
description: "Download links and package installation commands for PHWriter."
---

# Installation & Downloads

PHWriter is packaged and distributed across several channels to integrate smoothly into any development environment or automated CI/CD pipeline.

---

## Package Managers

{% for pkg in site.data.downloads.package_managers %}
### {{ forloop.index }}. {{ pkg.name }}
{{ pkg.desc }}

```powershell
{{ pkg.command }}
```

* ➔ **[Link to Registry]({{ pkg.url }})**

{% endfor %}

---

## Manual Downloads

You can download compiled versions of the module directly for offline distribution or custom embedding:

### Latest Release Assets (v2.0.0)

| Format | Description | Download Link |
|---|---|---|
{% for dl in site.data.downloads.manual_downloads -%}
| 📦 **{{ dl.format }}** | {{ dl.desc }} | [{{ dl.filename }}]({{ dl.url }}) |
{% endfor %}

---

## Release Pipeline

Every commit to the `main` branch undergoes automated testing via GitLab CI/CD, which generates release notes, runs compliance checks, compiles the binary dependencies, and publishes release packages.

* ➔ **[GitLab Releases Page](https://gitlab.com/phellams/phwriter/-/releases)**
* ➔ **[GitLab CI/CD Pipeline Runs](https://gitlab.com/phellams/phwriter/-/pipelines)**
