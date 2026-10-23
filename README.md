# Miku Dating Sim GRUB Theme

A Hatsune Miku–themed GRUB theme, remixed from the [Matrix Morpheus GRUB Theme](https://github.com/Priyank-Adhav/Matrix-Morpheus-GRUB-Theme). Art by me.

![Miku Dating Sim GRUB Theme preview showing Linux and Windows boot icons](preview.gif)

The original art files with layers can be found [here](https://www.mediafire.com/folder/xiafgyzxbnefz/MIKU_SIM) (clip  and psd included).
If you make something out of this, be sure to credit me (and send it to me too, I'd love to see it). Thanks!

---

**Note:** pls read so you know what you're getting yourself into :P **(Troubleshoot guide below!!!)**
- The install script should handle most of the work.
- There are only two images (1920x1080). One for Linux and one for Windows. **Other options like "Advanced options" or "Snapshots" will display nothing (black screen).**
- **Reorder your boot options so that Linux is right above Windows to match the drawings**. Other options can be hidden or set in an order that you can remember.
- If you really need to use advanced options like "Snapshots", you can add a line in your grub to switch to another theme when you enter the submenu. (kind of advanced so figure it out yourself lol)
- ⚠️ **If you are seeing a back screen:** The repo only includes arch.png and windows.png. You have to look into the folder and rename arch.png to [your distro's class].png. You can find your distro's class in grub.cfg. The install script should be able to handle this, otherwise you have to fix it manually lol.
  + Here's a quick command to see all of your classes:
    
    ```shell
      grep --color=auto "class " /boot/grub/grub.cfg
    ```
- ⚠️ **Fedora/openSUSE users:** these distros default to `GRUB_TERMINAL_OUTPUT="console"`, which makes GRUB silently ignore `GRUB_THEME` (the theme line is never written to `grub.cfg`). The installer switches it to `gfxterm` automatically; if you installed manually, change it yourself and rerun `grub2-mkconfig`.
## Installation (Recommended!)

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
> The repo only includes arch.png and windows.png. You have to look into the folder and rename arch.png to [your distro's class].png. You can find your distro's class in grub.cfg. If it's too much work, just use the install script.

## Uninstall

```shell
sudo rm -rf /boot/grub/themes/Miku-Dating-Sim
```

Remove the `GRUB_THEME=` line from `/etc/default/grub`, then regenerate:

```shell
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

> The installer saves a copy of `/etc/default/grub` as a `.bak.<timestamp>` file next to it before making changes (the path is shown at the end of the install). To fully restore your previous config, copy it back before removing the `GRUB_THEME=` line.
