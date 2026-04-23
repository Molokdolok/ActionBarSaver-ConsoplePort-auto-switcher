# Action Bar Saver(ConsolePort Auto-Switcher)

**Action Bar Saver** is a World of Warcraft addon designed to save and restore your action bar layouts. This version is a fork of the [original Action Bar Saver](https://github.com/Shadowed/ActionBarSaver) by Shadowed, enhanced with an **Auto-Switcher** feature specifically for players using controller addons.

## Compatibility

- **Client**: Wrath of the Lich King (3.3.5a).
- **Dependencies**: Works in conjunction with [ConsolePortLK](https://github.com/leoaviana/ConsolePortLK).

## Key Features

- **Profile Management**: Save, restore, rename, and delete multiple action bar layouts per class.
- **ConsolePort Auto-Switching**: Automatically detects if `ConsolePort` is enabled and switches to specialized profiles:
  - `ConsolePortON`: Loaded automatically when `ConsolePort` is active.
  - `ConsolePortOFF`: Loaded automatically when `ConsolePort` is disabled.
- **Auto-Save**: Automatically saves your current profile upon logout or exit.

> [!IMPORTANT]
> **Initial Setup & Multi-Device Usage**
> Before changing any keybinds or spell placements, you must initialize the auto-switching profiles so the addon can capture your current layouts correctly.
> 
> **Step 1: Initialize profiles per mode**
> The addon creates two profiles based on whether ConsolePort is enabled:
> 
> - **ConsolePortON** (controller mode)
> - **ConsolePortOFF** (PC mode)
> 
> To create these properly:
> 
> - **If you only use one mode:** Launch the game once in that mode.
> - **If you use both modes on the same device:** 
>   - Launch once with ConsolePort enabled
>   - Launch once with ConsolePort disabled
> 
> This ensures both profiles are created using your current setup.
> 
> **Step 2: Multi-device setup (important)**
> If you play on multiple devices (PC, Steam Deck, laptop, etc.), you must repeat this process on each device:
> 
> - Launch the game once per mode you plan to use on that device
> 
> This is required because settings are cloud-synced. Each device needs to generate its own local version of the profiles before syncing happens.
> 
> **Why this matters**
> If you skip this step, one device may overwrite another device’s layout during sync, causing incorrect keybinds or action bars. Proper initialization ensures each device keeps its intended configuration.
> 
> **After setup**
> Once all profiles are initialized across your devices, you can safely customize keybinds and spell placements for each mode without conflicts.



## Installation

1. Download the addon.
2. Extract the `ActionBarSaver` folder into your `Interface/AddOns` directory.
3. Upon first run, the addon will automatically manage the `ConsolePortON` and `ConsolePortOFF` profiles based on your active addons.

## Credits

- **Original Author**: [Shadowed](https://github.com/Shadowed/ActionBarSaver)
- **Enhancements**: Modified for WotLK 3.3.5 and ConsolePort auto-switching support.

