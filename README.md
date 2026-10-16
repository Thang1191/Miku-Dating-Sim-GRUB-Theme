# Miku Dating Sim GRUB Theme

A Hatsune Miku–themed GRUB theme, remixed from the [Matrix Morpheus GRUB Theme](https://github.com/Priyank-Adhav/Matrix-Morpheus-GRUB-Theme), featuring full-screen dynamic backgrounds that change between Linux and Windows.

Fans of the original will recognize the layout — this version swaps the red pill / blue pill artwork for Miku art and uses the **Home Video** font.

![Miku Dating Sim GRUB Theme preview showing Linux and Windows boot icons](preview.gif)

---

**Note:**
- The theme ships with icons for **Linux** (`arch.png`) and **Windows** (`windows.png`).
- While the icons are **arranged horizontally** on screen, you still navigate using the **Up** and **Down arrow keys** as in a normal GRUB menu.
- The Linux Miku image is placed at `arch.png`, but GRUB picks icons by the menu entry's class name (e.g. `gnu-linux`, `gnu`, `os`, or a distro name like `cachyos`/`ubuntu`). The installer automatically detects the classes used by **your** distro from the generated `grub.cfg` and aliases `arch.png` to each of them (hardlinks — zero extra disk space), so the art shows up without any manual steps. Only entries classed e.g. `windows` keep their dedicated art. On exotic grubs where parsing finds nothing, you can still add a class manually: `cp icons/arch.png icons/yourclass.png`.

## Installation

1. Clone the repo

```shell
git clone https://github.com/Thang1191/Miku-Dating-Sim-GRUB-Theme
```

2. Go into the folder

```shell
cd Miku-Dating-Sim-GRUB-Theme
```

3. Make the installer executable

```shell
chmod +x install.sh
```

4. Execute the installation script as admin

```shell
sudo ./install.sh
```

The script works across distros — it auto-detects whether your system uses `update-grub`, `grub2-mkconfig`, or `grub-mkconfig`, and figures out the right GRUB layout (`/boot/grub` vs `/boot/grub2`). It can be run from anywhere (no need to be inside the repo folder), backs up `/etc/default/grub` before touching it, and does a clean reinstall so re-running it never leaves stale theme files behind.

5. Reboot to test your new theme

## Manual installation

```shell
sudo cp -r Miku-Dating-Sim /boot/grub/themes/
```

Then add to `/etc/default/grub` (or replace the existing `GRUB_THEME=` line):

```shell
GRUB_THEME="/boot/grub/themes/Miku-Dating-Sim/theme.txt"
```

And regenerate the GRUB config:

```shell
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

## Uninstall

```shell
sudo rm -rf /boot/grub/themes/Miku-Dating-Sim
```

Remove the `GRUB_THEME=` line from `/etc/default/grub`, then regenerate:

```shell
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

> The installer saves a copy of `/etc/default/grub` as a `.bak.<timestamp>` file next to it before making changes (the path is shown at the end of the install). To fully restore your previous config, copy it back before removing the `GRUB_THEME=` line.

---

**Artwork:** Miku art by the theme author.
**Original theme:** [Priyank-Adhav/Matrix-Morpheus-GRUB-Theme](https://github.com/Priyank-Adhav/Matrix-Morpheus-GRUB-Theme)