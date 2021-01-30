{-# LANGUAGE DeriveDataTypeable #-}
import XMonad
import Data.Monoid
import System.Exit
import XMonad.Util.Run
import XMonad.Util.SpawnOnce
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders
import XMonad.Hooks.DynamicLog
import XMonad.Actions.Submap
import qualified XMonad.Util.ExtensibleState as XS
import qualified XMonad.StackSet as W
import qualified Data.Map        as M

data Estado = Estado [Char] deriving Typeable
instance ExtensionClass Estado where
    initialValue = Estado ""
myTerminal      = "alacritty"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
myBorderWidth   = 3

-- Funcs feeded to myAutolocker
myLocker = "~/bin/i3lockconf"
myKiller = "'systemctl suspend'"

-- lock and killer are commands for locking the session and suspending or something similar
myAutolocker :: String -> String -> String
myAutolocker lock killer = "xautolock -time 10 -locker " ++ lock ++ " -killtime 10 -killer " ++ killer ++ " -detectsleep"

myModMask       = mod4Mask

myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]

-- Border colors for unfocused and focused windows, respectively.
myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = "#ff0000"

-- The same as submap but keep on mode until some key that is not 
-- mapped is pressed
modalmap :: M.Map (KeyMask, KeySym) (X ()) -> X ()
modalmap s = submap $ M.map (\x -> x >> modalmap s) s

-- Key bindings
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
    -- launch dmenu
    , ((modm,               xK_p     ), spawn "dmenu_run")
    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)
     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)
    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)
    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)
    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)
    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )
    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )
    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)
    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )
    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )
    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)
    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)
    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)
    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))
    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))
    , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")
    , ((modm              , xK_g     ), spawn $ myAutolocker myLocker myKiller)

    , ((modm .|. shiftMask, xK_m    ), modalmap . M.fromList $
        -- Media
        [ ((0, xK_j),   spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%")
        , ((0, xK_k),   spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")
        , ((0, xK_l),   spawn "playerctl next")
        , ((0, xK_h),   spawn "playerctl previous")
        , ((0, xK_space),   spawn "playerctl play-pause")
        , ((0, xK_n),   spawn "~/bin/next_sink")
        ])

    , ((modm .|. shiftMask, xK_x    ), submap . M.fromList $
        -- Power management
        [ ((0, xK_l),   io (exitWith ExitSuccess))
        , ((0, xK_s),   spawn "systemctl suspend")
        , ((0, xK_p),   spawn "systemctl poweroff")
        , ((0, xK_r),   spawn "systemctl reboot")
        ])
    ]
    ++

    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

myLayout = avoidStruts ( tiled ||| Mirror tiled ||| noBorders Full)
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = smartSpacing 3 $ Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]

myEventHook = mempty

myLogHook xmproc0 xmproc1 = dynamicLogWithPP $ xmobarPP
                                { ppOutput = hPutStrLn xmproc0
                                , ppTitle = xmobarColor "green" "" . shorten 50
                                }

myStartupHook = do
        spawnOnce "nitrogen --restore &"
        spawnOnce "picom &"
        spawnOnce $ (myAutolocker myLocker myKiller) ++ " &"

main = do
        xmproc0 <- spawnPipe "xmobar -x 0 ~/.config/xmobar/xmobarrc0"
        xmproc1 <- spawnPipe "xmobar -x 1 ~/.config/xmobar/xmobarrc1"
        xmonad $ docks $ defaults xmproc0 xmproc1

defaults xmproc0 xmproc1 = def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook xmproc0 xmproc1,
        startupHook        = myStartupHook
    }

