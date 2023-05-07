import XMonad
import XMonad.Actions.CycleWindows
import XMonad.Actions.PhysicalScreens
import XMonad.Actions.Warp
import XMonad.Actions.WithAll
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.NoBorders
import qualified XMonad.StackSet as SS
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys, additionalKeysP, additionalMouseBindings)

import Control.Monad
import Control.Monad.Trans.Class
import Control.Monad.Trans.Maybe
import Data.Maybe
import Data.Ratio
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
  xmonad $ ewmhFullscreen $ ewmh . docks $ def
        { manageHook = manageDocks <+> myManageHook <+> manageHook def
        , layoutHook = avoidStruts  $  smartBorders  $  layoutHook def
        , logHook = dynamicLogWithPP xmobarPP
                    { ppOutput = hPutStrLn xmproc
                    , ppTitle = xmobarColor "#f1eddb" "" . shorten 50
                    }
        , focusFollowsMouse  = True
        , borderWidth        = 4
        , terminal           = "run-with-environment alacritty"
        , normalBorderColor  = "#cccccc"
        , focusedBorderColor = "#ff8c00"
        , modMask = mod4Mask     -- Rebind Mod to the Windows key
        } `additionalKeys` myKeys `additionalKeysP` myKeysP `additionalMouseBindings` myMouseBindings

-- keys for selecting physical screens
screenKeys :: [KeySym]
screenKeys = [xK_1, xK_2, xK_3]

-- orders screens by the upper-left-most corner, from left-to-right, bottom to top
lrbtScreenOrderer :: ScreenComparator
lrbtScreenOrderer = screenComparatorByRectangle comparator where
  comparator (Rectangle x1 y1 _ _) (Rectangle x2 y2 _ _) = compare (x1, -y1) (x2, -y2)

myKeys :: [((KeyMask, KeySym), X ())]
myKeys = [ ((mod4Mask .|. shiftMask, xK_l), spawn "lockscreen")
        , ((0, xK_Print), spawn "screenshot -s")
        , ((shiftMask, xK_Print), spawn "screenshot")
        , ((mod4Mask, xK_o), spawn "run-with-environment dmenu_run -fn xft:cantarell:pixelsize=16")
        , ((mod4Mask .|. shiftMask, xK_o), spawn "run-with-environment gmrun")
        , ((mod4Mask .|. controlMask, xK_c), killOthers)
        , ((mod4Mask .|. controlMask, xK_j), cycleRecentWindows [xK_Super_L, xK_Control_L] xK_j xK_k)
        , ((mod4Mask, xK_Tab), spawn "skippy-xd")
        ]
        ++
        -- alt-mod-{screenKeys}
         [((m .|. mod4Mask .|. mod1Mask, key), void $ runMaybeT $ (MaybeT . getScreen lrbtScreenOrderer) sc >>= lift . f)
         | (key, sc) <- zip screenKeys [0..]
         , (f, m) <-
           -- Warp pointer to physical/Xinerama screens 1, 2, 3
           [ (\sc' -> warpToScreen sc' (1%3) (1%3), 0)
           -- Move client to screen 1, 2, 3
           , (\sc' -> screenWorkspace sc' >>= flip whenJust (windows . SS.shift), shiftMask)
           ]]

myKeysP :: [(String, X ())]
myKeysP = [ ("<XF86AudioMute>", spawn "audio-toggle-mute")
        , ("<XF86AudioRaiseVolume>", spawn "audio-volume +5%")
        , ("<XF86AudioLowerVolume>", spawn "audio-volume -5%")
        , ("<XF86MonBrightnessUp>", spawn "mon-brightness -A 5")
        , ("<XF86MonBrightnessDown>", spawn "mon-brightness -U 5")
        ]

myMouseBindings :: [((ButtonMask, Button), Window -> X ())]
myMouseBindings = [ ((mod4Mask .|. shiftMask, button1), \w -> focus w >> mouseResizeWindow w >> windows SS.shiftMaster) ]
