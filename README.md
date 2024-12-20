# WebUI-GMod
``WebUI-GMod`` is a Lua library that makes it\
very easy to create client Web interfaces in Garry's Mod.

[Discord Server](https://discord.com/invite/HspPfVkHGh)

## Pluses
* Lightweight
* The library consumes almost no resources
* The library provides a very user-friendly API (``Lua`` <-> ``Javascript``)
* Not technology dependent as it uses already built pages.

## Minuses
* Awesomium does not support a lot of modern features (js/css), so every player on the client needs to install Chromium + GMODCefFix patch (see [Installing on client](#client))
* Resource consumption will be higher than if you use VGUI (of course, depending on the cases)

# Installing/update
### Server:
1. Download [latest release of WebUI-GMod](https://github.com/smokingplaya/webui-gmod/releases/latest)
2. Copy ``lua`` folder from archive and paste it in ``GarrysModDS/garrysmod/``
3. Customize the config to your liking:
```lua
-- ? Should we check version of webui-gmod or not
local versionValidatorEnabled = true
-- ? Should we use custom webserver for UI's hosting
local customWebserver = false;
-- ? Custom webserver url
-- ! There should be no slash at the end
local customWebserverUrl = "https://example.com";
-- ? On which port the web server will be binded
local webserverPort = 8091
```
Or don't touch anything if you don't understand why it's necessary.

4. If you are not using a custom web server, then install the [WebUI-Server](https://github.com/smokingplaya/webui-server) module (you need to build a web server that will send UI files).

### Client:
1. Install [GMODCefFix](https://github.com/solsticegamestudios/GModCEFCodecFix) or just use [PrettyGMOD](https://github.com/smokingplaya/prettygmod) (utility that installs many necessary patches)

# Guides
* [Simple username rendering with ReactJS in 2 minutes](./.guide/react.md)

# The idea
VGUI is cool, as long as you don't need to make the interface more complicated than Windows 98.\
You need to think how to make roundings, how to work with stensils (by the way, there are still no normal guides on them), and at the same time you should not forget about optimization.\
But why reinvent the wheel when there is a Web that already has all the necessary functions?\
This is the question I asked myself, and this is what we got.

# Documentation
You can see documentation [here](./.guide).

# License
The library is distributed under the [GNU GPL v3 license](LICENSE)

# Contribution
We are always open to improvements!\
If you have ideas, comments, or fixes, feel free to open a pull request.

##### made w/<3 by smokingplaya @ 2024-2025