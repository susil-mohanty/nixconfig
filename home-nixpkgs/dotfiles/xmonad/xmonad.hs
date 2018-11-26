import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Actions.SpawnOn
import XMonad.Hooks.EwmhDesktops
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing

mylayout = spacing 2 $ smartBorders tiled ||| smartBorders Full
  where
     tiled   = Tall nmaster delta ratio
     nmaster = 1
     delta   = 3/100
     ratio   = 1/2

main = xmonad =<< statusBar myBar myPP toggleStrutsKey myConfig

myBar = "xmobar"

-- Custom PP, configure it as you like. It determines what is being written to the bar.
myPP = xmobarPP { ppCurrent = xmobarColor "#429942" "" . wrap "<" ">" }

-- Key binding to toggle the gap for the bar.
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

myConfig = defaultConfig
    {   modMask = mod4Mask
      ,  workspaces = ["code1", "web", "code2", "code3", "misc1", "misc2"]
      , focusedBorderColor = "#FF5C8F"
      , normalBorderColor = "#282A36"
      , borderWidth = 3
      , terminal = "urxvtc"
      , startupHook = do
          spawnOn "web" "firefox"
          spawnOn "web" "Discord"
          spawnOn "web" "weechat"
          spawnOn "code1" "urxvt"
          spawnOn "code1" "emacs --eval '(server-start)'"
      , manageHook = manageSpawn
      , logHook = dynamicLog
      , layoutHook = mylayout
      , handleEventHook = fullscreenEventHook
     }
