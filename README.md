# Sibme Wizard setup (starter)

This public repo holds only the **starter script** for the Sibme Wizard, the Claude Code skills for Sibme staff.
It contains no secrets. It asks for your Sibme Wizard key (from the Wizard owner), downloads the real setup from
the private plugin repo with it, and runs it.

Open a terminal (Mac: **Terminal**; Windows: **Git Bash**), paste this, press Enter:

```bash
curl -fsSL https://raw.githubusercontent.com/Santiago-Astini/sibme-wizard-setup/main/go | bash
```

After the first install you rarely need the terminal again: in Claude, type `/sibmew-setup` to check, repair,
update or change modules.
