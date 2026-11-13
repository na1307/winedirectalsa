# winedirectalsa Installation Guide

## Install for Steam games

### Dependencies

#### Required

##### Automatic Installation

1. Python 3.x
2. umu-launcher
3. The `vdf` Python package

On Arch Linux, install them as follows. (`multilib` is required.)

```shell
sudo pacman -S python python-vdf umu-launcher
```

##### Manual Installation

1. Protontricks

On Arch Linux, install them as follows.

```shell
sudo pacman -S protontricks
```

#### Optional

1. RealtimeKit (`rtkit-daemon`) (Recommended)

### Installation steps

> [!caution]
> This project only supports Wine/Proton 11.0 or later.

1. If the target game has never been run, run it once.
2. Download the latest tarball from the [Releases](https://github.com/na1307/winedirectalsa/releases/latest) page.
3. Extract the downloaded tarball.
4. (Optional) Copy the `x86_64-{unix|windows}` directories to one of the following locations:

   * `$HOME/.local/lib/wine/` (Recommended)
   * `/opt/winedirectalsa/` (requires root privileges)

   If you do not copy the files manually, the script will copy them for you.
5. Run the included `wda-install` script.
6. Here, you can let a script handle the installation, or you can install it manually.
   * For automatic installation, simply choose 2 and follow the script's instructions. umu-launcher is required.
   * To install manually, please follow the procedures below. Protontricks is required.
      1. Choose 5 in the script to simply exit.
      2. Edit the `Manual Register.reg` file. Change the `(YOUR USER NAME)` to your **Linux** username.
      3. Enter the following in the terminal:

         ```shell
         protontricks APPID winecmd
         ```

         Here, the Steam App ID of the corresponding game goes in the `APPID` (example: `960170`).
      4. When the command prompt opens, enter the following:

         ```shell
         reg import "Manual Register.reg" /reg:64
         ```
7. In the game's Steam properties, set the launch options as follows:

   ```shell
   WINEDLLPATH=~/.local/lib/wine/ %command% # or WINEDLLPATH=/opt/winedirectalsa %command%
   ```
8. Enjoy!
