# Miku Dating Sim GRUB Theme

A Hatsune Miku–themed GRUB theme, remixed from the [Matrix Morpheus GRUB Theme](https://github.com/Priyank-Adhav/Matrix-Morpheus-GRUB-Theme), featuring full-screen dynamic backgrounds that change between Linux and Windows.

Fans of the original will recognize the layout — this version swaps the red pill / blue pill artwork for Miku art and uses the **Home Video** font.

![Miku Dating Sim GRUB Theme preview showing Linux and Windows boot icons](preview.gif)

---

**Note:**
- The theme ships with icons for **Linux** (`arch.png`) and **Windows** (`windows.png`).
- While the icons are **arranged horizontally** on screen, you still navigate using the **Up** and **Down arrow keys** as in a normal GRUB menu.
- The Linux Miku image is placed at `arch.png`, but GRUB picks icons by the menu entry's class name (e.g. `gnu-linux`, `linux`, `os`). If your entries still show a plain background, copy `arch.png` to those names in `icons/`, e.g. `cp icons/arch.png icons/linux.png`.

## Installation

1. Clone the repo

```shell
git clone <your-repo-url>
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

---

**Artwork:** Miku art by the theme author.
**Original theme:** [Priyank-Adhav/Matrix-Morpheus-GRUB-Theme](https://github.com/Priyank-Adhav/Matrix-Morpheus-GRUB-Theme)