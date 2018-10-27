-- Imports.
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Actions.SpawnOn
-- import XMonad.Config.Desktop
import XMonad.Hooks.EwmhDesktops
-- import XMonad.Hooks.SetWMName
import XMonad.Layout.NoBorders
-- import qualified XMonad.StackSet as W
-- import XMonad.Layout.ThreeColumns

--KDE
-- import XMonad.Config.Kde

mylayout = tiled ||| Mirror tiled ||| noBorders Full
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio
     -- tiled   = ThreeCol nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

-- The main function.
main = xmonad =<< statusBar myBar myPP toggleStrutsKey myConfig

-- Command to launch the bar.
myBar = "xmobar"

-- Custom PP, configure it as you like. It determines what is being written to the bar.
myPP = xmobarPP { ppCurrent = xmobarColor "#429942" "" . wrap "<" ">" }

-- Key binding to toggle the gap for the bar.
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

-- Main configuration, override the defaults to your liking.
-- myConfig = kdeConfig
myConfig = defaultConfig
    {   modMask = mod4Mask
      ,  workspaces = ["code1", "web", "code2", "code3", "misc1", "misc2"]
      , focusedBorderColor = "#CB4B16"
      , normalBorderColor = "#9E9E9E"
      , borderWidth = 2
      , terminal = "urxvtc"
      , startupHook = do
          spawnOn "web" "firefox"
          spawnOn "web" "Discord"
          spawnOn "code1" "urxvt"
          spawnOn "code1" "emacsclient -c"
      , manageHook = manageSpawn
      , logHook = dynamicLog
      , layoutHook = mylayout
      , handleEventHook = fullscreenEventHook
     }
