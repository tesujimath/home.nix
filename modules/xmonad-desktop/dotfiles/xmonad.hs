import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.NoBorders
import qualified XMonad.StackSet as W
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys, additionalKeysP, additionalMouseBindings)
import System.IO

myManageHook = composeAll
    [ appName =? "Ediff"       --> doFloat
    , className =? "Gimp-2.8"  --> doFloat
    , className =? "Gpick"     --> doFloat
    --, className =? "Sxiv"      --> doFloat
    , className =? "mpv"       --> doFloat
    , className =? "Zathura"   --> doFloat
    , className =? "Rumno-background" --> doFloat <+> hasBorder False
    , className =? "Screenruler.rb"   --> doFloat <+> hasBorder False
    -- for screen recording
    --, className =? "Google-chrome" --> hasBorder False
    , isFullscreen             --> doFullFloat
    ]

main = do
  xmproc <- spawnPipe "xmobar"
  xmonad $ ewmh def
        { manageHook = manageDocks <+> myManageHook <+> manageHook def
        , layoutHook = avoidStruts  $  smartBorders  $  layoutHook def
        , handleEventHook = mconcat
                            [ docksEventHook
                            , fullscreenEventHook
                            , handleEventHook def ]
        , logHook = dynamicLogWithPP xmobarPP
                    { ppOutput = hPutStrLn xmproc
                    , ppTitle = xmobarColor "#f1eddb" "" . shorten 50
                    }
        , focusFollowsMouse  = True
        , borderWidth        = 4
        , terminal           = "run-with-environment gnome-terminal"
        , normalBorderColor  = "#cccccc"
        , focusedBorderColor = "#ff8c00"
        , modMask = mod4Mask     -- Rebind Mod to the Windows key
        } `additionalKeys` myKeys `additionalKeysP` myKeysP `additionalMouseBindings` myMouseBindings

myKeys :: [((KeyMask, KeySym), X ())]
myKeys = [ ((mod4Mask .|. shiftMask, xK_l), spawn "lockscreen")
        , ((0, xK_Print), spawn "screenshot -s")
        , ((shiftMask, xK_Print), spawn "screenshot")
        , ((mod4Mask, xK_o), spawn "run-with-environment dmenu_run -fn xft:cantarell:pixelsize=16")
        , ((mod4Mask .|. shiftMask, xK_o), spawn "run-with-environment gmrun")
        , ((mod4Mask, xK_Tab), spawn "skippy-xd")
        ]
        ++
        -- alt-mod-{2,3,1} %! Switch to physical/Xinerama screens 1, 2, 3
        -- alt-mod-shift-{2,3,1} %! Move client to screen 1, 2, 3
        -- adapted from xmonad/src/XMonad/Config.hs
        -- unsure why the physical screens to logical screen isn't quite right
        [((m .|. mod4Mask .|. mod1Mask, key), screenWorkspace sc >>= flip whenJust (windows . f))
            | (key, sc) <- zip [xK_2, xK_3, xK_1] [0..]
            , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

myKeysP :: [(String, X ())]
myKeysP = [ ("<XF86AudioMute>", spawn "audio-toggle-mute")
        , ("<XF86AudioRaiseVolume>", spawn "audio-volume +5%")
        , ("<XF86AudioLowerVolume>", spawn "audio-volume -5%")
        , ("<XF86MonBrightnessUp>", spawn "mon-brightness -A 5")
        , ("<XF86MonBrightnessDown>", spawn "mon-brightness -U 5")
        ]

myMouseBindings :: [((ButtonMask, Button), Window -> X ())]
myMouseBindings = [ ((mod4Mask .|. shiftMask, button1), \w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster) ]
