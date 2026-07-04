# REAPER Track Automation: Auto-Input Assigner

A lightweight, background ReaScript (Lua) for **REAPER** that automatically assigns audio hardware inputs, arms recording, and enables record monitoring the exact moment you name a track. 

This script pairs perfectly with SWS Auto-Color/Icon/Layout setups. While SWS handles your visual aesthetics, this script runs silently in the background to handle your hardware routing logistics.

---

## Features
* **Name-Based Automation:** Matches track names instantly (case-insensitive).
* **Smart Input Selection:** Seamlessly maps both Mono and Stereo hardware interface inputs.
* **Instant Record Ready:** Automatically arms the track for recording (`I_RECARM`).
* **Live Input Monitoring:** Automatically sets Record Monitoring to "On" (`I_RECMON`).
* **Performance Optimized:** Only applies changes if the track settings don't already match your rules, preventing undo history bloat and keeping REAPER running at peak performance.

---

## Installation & Setup

### 1. Add the Script to REAPER
1. In REAPER, open the action list by going to **Actions** > **Show action list...** (or press `?`).
2. Next to *New action*, click the **New action...** button and select **New ReaScript...**
3. Name the file `Auto_Track_Input_Assigner.lua` and click **Save**.
4. A blank development window will appear. Paste the script code into the window.
5. Press `Ctrl + S` (Windows) or `Cmd + S` (Mac) to save, then close the text editor window.

### 2. Run the Script
1. In your **Actions List**, search for `Script: Auto_Track_Input_Assigner.lua`.
2. Select it and click **Run**. 
3. *The script will now actively monitor track names until you restart REAPER.*

---

## Configuration & Customization

To add your own gear or adjust track triggers, look for the `local rules = { ... }` block at the very top of the code. Open the script in REAPER's Action list anytime to modify it.

### The Routing Logic Guide
Because REAPER's internal API starts counting inputs from `0` (Input 1 is index 0), use the following formulas to configure your inputs:

* **Mono Channels:** Use the hardware input number minus 1.
  * *Example (Input 1):* `0`
  * *Example (Input 5):* `4`
* **Stereo Channels:** Add `1024` to the starting hardware input index number.
  * *Example (Stereo Inputs 1 & 2):* `1024 + 0`
  * *Example (Stereo Inputs 23 & 24):* `1024 + 22`

### Template Configuration Example
```lua
local rules = {
    -- ["track name trigger"] = { input = API_VALUE, auto_arm = true/false, monitor = 0/1/2 }
    ["monotrack"]   = { input = 0,         auto_arm = true, monitor = 1 }, -- Mono Input 1
    ["stereotrack"] = { input = 1024 + 0,  auto_arm = true, monitor = 1 }, -- Stereo Inputs 1 & 2
}
