require 'action'
require 'profile'

----------------------------------------------------------------------------------------------------
-- Settings
----------------------------------------------------------------------------------------------------
local mash = {'ctrl', 'alt'}

local windowFilter = hs.window.filter.new()
windowFilter:setDefaultFilter({allowTitles=1})

local expose = hs.expose.new(windowFilter)
hs.expose.ui.minimizedStripPosition = 'left'
hs.expose.ui.showExtraKeys = true
hs.expose.ui.showThumbnails = false
hs.expose.ui.showTitles = false

hs.window.animationDuration = 0.15

hs.grid.setMargins({0, 0})
hs.grid.setGrid('6x4', nil)
hs.grid.HINTS = {
  {'f1', 'f2','f3', 'f4', 'f5', 'f6', 'f7', 'f8'},
  {'1', '2', '3', '4', '5', '6', '7', '8'},
  {'Q', 'W', 'E', 'R', 'T', 'Z', 'U', 'I'},
  {'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K'},
  {'Y', 'X', 'C', 'V', 'B', 'N', 'M', ','}
}

----------------------------------------------------------------------------------------------------
-- Profiles
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
					 -- Retina, Horizontal Dell, Vertical Dell
Profile.new('Work', {69731906, 725376209, 724062932}, mash, {
  ["iTerm"]              = {Action.MoveToScreen(1), Action.Maximize()},
  ["iTunes"]              = {Action.MoveToScreen(1), Action.Maximize()},
  ["Calendar"]              = {Action.MoveToScreen(1), Action.Maximize()},
  ["Messages"]              = {Action.MoveToScreen(1), Action.Maximize()},
  ["Google Chrome"]     = {Action.MoveToScreen(3), Action.Maximize()},
  ["WebStorm"]           = {Action.MoveToScreen(1), Action.Maximize()},
  ["_"]                 = {Action.Snap()}
}, {
  ['a'] = 'Atom',
  ['c'] = 'Google Chrome',
  ['d'] = 'Dash',
  ['e'] = 'TextMate',
  ['f'] = 'Finder',
  ['g'] = 'Tower',
  ['i'] = 'iTunes',
  ['p'] = 'Parallels Desktop',
  ['m'] = 'Activity Monitor',
  ['s'] = 'MacPass',
  ['t'] = 'Terminal',
  ['x'] = 'Xcode',
})

----------------------------------------------------------------------------------------------------
-- Hotkey Bindings
--------------------------------------------------------------------------------------------------

function focusedWin() return hs.window.focusedWindow() end

hs.hotkey.bind(mash, 'UP',    function() Action.Maximize()(focusedWin()) end)
hs.hotkey.bind(mash, 'DOWN',  function() Action.MoveToNextScreen()(focusedWin()) end)
hs.hotkey.bind(mash, 'LEFT',  function() Action.MoveToUnit(0.0, 0.0, 0.5, 1.0)(focusedWin()) end)
hs.hotkey.bind(mash, 'RIGHT', function() Action.MoveToUnit(0.5, 0.0, 0.5, 1.0)(focusedWin()) end)
hs.hotkey.bind(mash, 'SPACE', function() for _, win in pairs(hs.window.visibleWindows()) do hs.grid.snap(win) end end)
hs.hotkey.bind(mash, '1',     function() expose:toggleShow() end)
hs.hotkey.bind(mash, '2',     function() hs.grid.toggleShow() end)
hs.hotkey.bind(mash, 'p',     function()
  local profile = Profile.designated()
  if profile then profile:activate() end
end)

----------------------------------------------------------------------------------------------------
-- Watcher
----------------------------------------------------------------------------------------------------

function screenEvent()
  local profile = Profile.designated()
  if not profile then
      utils.notify("unknown profile, see console for screen information", 3.0, function() hs.toggleConsole() end)
      for _, screen in pairs(hs.screen.allScreens()) do print("found screen: " .. screen:id() .. ": " .. screen:name()) end
      return
  end
  profile:activate()
end

hs.screen.watcher.new(screenEvent):start()

screenEvent()
