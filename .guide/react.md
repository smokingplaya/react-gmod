# Simple React UI

In this example, I will show you how to create a simple web interface using **React (TypeScript)**, **Bun**, **TypeScript**, and **Vite**.

---

## 🚀 Create a New Project

**Project name**: `webui-gmod-test`

```bash
bun create vite webui-gmod-test --template react-ts
cd webui-gmod-test
bun install
```

## ⚠️ Update vite.config.ts
Set ``base`` to ``"./"`` in ``vite.config.ts``
```ts
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  base: "./"
});
```

## ✍️ Write code
Open ``App.tsx`` and paste this code:
```tsx
import { useState, useEffect } from "react";

// Let the TS compiler know that these methods will be declared.
declare global {
  const gmod: {
    getUsername: (callback: (name: string) => void) => void;
  };
}

function App() {
  // Using useState to have the application contain the player's username
  // username - variable, that contains user's name
  // setUsername - function, that
  const [username, setUsername] = useState<string>("n/a");

  // Using useEffect so that it is called once during initialization.
  useEffect(() => {
    // Gmod's API for communicating with JS is set up
    // so that if a function in Lua returns something,
    // JS sees it as a callback
    if (typeof gmod !== "undefined")
      gmod.getUsername(setUsername);
  }, []);

  return (
    <div style={{
      height: "100%",
      display: "flex",
      justifyContent: "center",
      alignItems: "center"
    }}>
      Username: {username}
    </div>
  )
}

export default App;
```
Clean ``index.css`` and paste this code:
```css
:root {
  /* The background should be transparent so we can see the game. */
  background: transparent;
  height: 100%;
}

body {
  height: 100%;
  margin: 0;
}

#root {
  height: 100%;
}
```

## 🔧 Build the Project
```bash
bun run build
```

## 📂 Copy the Built Files to the WebUI Folder

By default, all compiled project files will be located in the ``dist/`` folder.\
Simply copy the files from ``dist/`` to ``GarrysModDS/garrysmod/webui/webui-gmod-test/``.

### Final Folder Structure:
```text
# Vite Project
webui-gmod-test/
  └── dist/

# Garry's Mod DS
GarrysModDS/
  └── garrysmod/
    └── webui/
      └── webui-gmod-test/
        ├── assets/
        └── index.html
```

## 💼 Create Lua UI initializatior
Create file ``GarrysMod/garrysmod/lua/autorun/client/my_webui.lua``, and paste this code:
```lua
// The timer is needed here because **DHTML** will
// not be initialized in Lua when this code is executed.
timer.Simple(0, function()
  webui:create("webui-gmod-test")
    :define("getUsername", function()
      return LocalPlayer():Nick()
    end)
end)
```