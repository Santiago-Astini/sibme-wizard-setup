# Sibme Wizard setup (starter)

This public repo holds only the **starter scripts** for the Sibme Wizard, the Claude Code skills for Sibme staff.
They contain no secrets. They ask for your Sibme Wizard key (from the Wizard owner), download the real setup from
the private plugin repo with it, and run it.

Easiest: in the Claude app, open the **Code** tab, open the **Terminal panel**, paste the line for your computer and
press Enter. When it asks for the key, paste it and press Enter: **you will not see the key** (nothing shows, not even
dots). That is normal.

**Mac** (or Git Bash on Windows):

```bash
curl -fsSL https://raw.githubusercontent.com/Santiago-Astini/sibme-wizard-setup/main/go | bash
```

**Windows** (the Terminal panel in Claude, or PowerShell):

```powershell
irm https://raw.githubusercontent.com/Santiago-Astini/sibme-wizard-setup/main/go.ps1 | iex
```

After the first install you rarely need the terminal again: in Claude, type `/sibmew-setup` to check, repair,
update or change modules.
