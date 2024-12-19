--- WebUI-GMod
---
--- WebUI-GMod is a library for the game Garry's Mod
--- that allows you to conveniently develop web-based interfaces.
---
--- Created by smokingplaya @ 2024-2025
--- Distributed under the GNU GPLv3

--- Config
-- ? Should we check version of webui-gmod or not
local versionValidatorEnabled = true

--- Constants
local VERSION = "1.0.3"
local ADDON_JSON = "https://raw.githubusercontent.com/smokingplaya/webui-gmod/refs/heads/main/addon.json"

--- Logs
local logColor = Color(0, 255, 255)
local whitespace = " "

local log = function(...)
  MsgC(logColor, "[webui-gmod]", whitespace, color_white, ...)
  MsgN()
end

--- addon.json getter
local getAddonData = function(onSuccess, onFailure)
  http.Fetch(
    ADDON_JSON,
    function(body, _, _, code)
      if (code != 200) then
        return onFailure("HTTP Code " .. code)
      end

      onSuccess(util.JSONToTable(body))
    end,
    function(message)
      log("Unable to load webui-gmod's data due to:", message)
      onFailure(message)
    end
  )
end

--- Version Validator
local getVersion = function(onSuccess, onFailure)
  getAddonData(function(data)
    onSuccess(data.version)
  end, onFailure)
end

local splitVersion = function(version)
  local parts = {}

  for part in string.gmatch(version, "(%d+)") do
    parts[#parts+1] = tonumber(part)
  end

  return parts
end

local isOutdated = function(currentVersion)
  local v1 = splitVersion(VERSION)
  local v2 = splitVersion(currentVersion)

  for i = 1, math.max(#v1, #v2) do
    local part1 = v1[i] or 0
    local part2 = v2[i] or 0
    if part1 < part2 then
      return true
    elseif part1 > part2 then
      return false
    end
  end

  return false
end

local validateVersion = function(onSuccess)
  if (!versionValidatorEnabled) then
    return onSuccess()
  end

  getVersion(function(version)
    if (isOutdated(version)) then
      return log(("You're on an outdated version! Your %s, new %s"):format(VERSION, version))
    end

    onSuccess()
  end, function(error)
    log("Version check error: " .. error)
    log("Version check failed, webui-gmod will not be enabled.")
  end)
end

local updateResources = function()
  --- Todo @ add files through 'resource' library
end

--- Addon load
if (SERVER) then
  validateVersion(function()
    log(("WebUI-GMod %s by smokingplaya<3"):format(VERSION))
    log("\thttps://github.com/smokingplaya/webui-gmod")

    updateResources()
  end)
end

--- Clientside
if (!CLIENT) then
  return
end

webui = webui || {
  base = "asset://garrysmod/" .. (game.SinglePlayer() and "webui/%s/%s" or "data/%s/%s"),
  list = {},

  create = function(self, page)
    local cache = self:get(page)

    if (IsValid(cache)) then
      return cache
    end

    local panel = vgui.Create("webuiHtml")

    if (page) then
      panel:setPage(page)
    end

    self:set(page, panel)

    return panel
  end,

  --- Gets a cached page
  get = function(self, page)
    return self.list[page]
  end,

  set = function(self, page, panel)
    self.list[page] = panel
  end
}

local indexDefault = "index.html"
vgui.Register("webuiHtml", {
  --- It should be private
  --- JavaScript code, that sends custom Event to JavaScript
  _jsEventEmit = [[
    window.dispatchEvent(new CustomEvent("message", {
      detail: {
        type: "%s",
        body: %s
      }
    }));
  ]],
  --- Gmod default methods
  Init = function(self)
    self:OnScreenSizeChanged(nil, nil, ScrW(), ScrH())
  end,
  OnScreenSizeChanged = function(self, _, _, w, h)
    self:SetSize(w, h)
    self:SetPos(0, 0)
  end,
  --- WebUI-Gmod methods
  --- Alias for PANEL:OpenURL method
  setUrl = function(self, url)
    self:OpenURL(url)

    return self
  end,
  --- MakePopup managment method
  setFocus = function(self, isFocused)
    self:SetMouseInputEnabled(isFocused)
    self:SetKeyBoardInputEnabled(isFocused)

    return self
  end,
  --- Sets index page
  setIndex = function(self, index)
    self.index = index

    return self
  end,
  --- Gets index pages
  getIndex = function(self)
    return self.index || indexDefault
  end,
  --- Sets page
  setPage = function(self, page)
    self:setUrl(webui.base:format(page, self:getIndex()))

    return self
  end,
  --- Alias for Show method
  show = function(self)
    self:Show()

    return self
  end,
  --- Alias for Hide method
  hide = function(self)
    self:Hide()

    return self
  end,
  --- Adds function into JavaScript
  define = function(self, name, callback)
    self:AddFunction("gmod", name, callback)

    return self
  end,
  --- Send event to JavaScript
  emit = function(self, messageBody, messageTypeId)
    --- There's no other way to do this
    local id = messageTypeId || "message"
    local body = util.TableToJSON(messageBody)

    self:QueueJavascript(self._jsEventEmit:format(id, body))

    return self
  end,
  --- Removes panel after some time
  removeIn = function(self, time)
    timer.Simple(time, function()
      if (IsValid(self)) then
        self:Remove()
      end
    end)

    return self
  end
}, "DHTML")