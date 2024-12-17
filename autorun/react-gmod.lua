--- React GMOD
---
--- React GMOD is a library for the game Garry's Mod
--- that allows you to conveniently develop web-based interfaces.
---
--- Created by smokingplaya @ 2024-2025
--- Distributed under the GNU GPLv3

--- Config
-- ? Should we check version of react-gmod or not
local versionValidatorEnabled = false

--- Constants
local VERSION = "1.0.0"
local ADDON_JSON = "https://raw.githubusercontent.com/smokingplaya/react-gmod/refs/heads/main/addon.json"

--- addon.json getter
local getAddonData = function(onSuccess, onFailure)
  http.Fetch(
    ADDON_JSON,
    function(body)
      onSuccess(util.JSONToTable(body))
    end,
    function(message)
      print("Unable to load react-gmod's data due to:", message)
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

local validateVersion = function(onSuccess)
  if (!versionValidatorEnabled) then
    return onSuccess()
  end

  getVersion(function(version)
    if (isOutdated(version)) then
      return print(("You're on an outdated version! Your %s, new %s"):format(VERSION, version))
    end

    onSuccess()
  end, function()
    print("Version check failed, react-gmod will not be enabled.")
  end)
end

--- Addon load
if (SERVER) then
  validateVersion(function()
    print(("React GMod %s by smokingplaya<3"):format(VERSION))
    print("\thttps://github.com/smokingplaya/react-gmod")
  end)
end