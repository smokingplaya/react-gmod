# Simple React UI

In this example, I will show you how to create a simple web interface using **React (TypeScript)**, **Bun**, **TypeScript**, and **Vite**.

---

## 🚀 First Step: Create a New Project

**Project name**: `webui-gmod-test`

```bash
bun create vite webui-gmod-test --template react-ts
cd webui-gmod-test
bun install
```

## 🔧 Second Step: Build the Project
```bash
bun run build
```

## 📂 Third Step: Copy the Built Files to the WebUI Folder

By default, all compiled project files will be located in the ``dist/`` folder.\
Simply copy the files from ``dist/`` to ``GarrysModDS/garrysmod/ui/{project_name}/``.

### Final Folder Structure:
```text
# Vite Project
{project_name}/
  └── dist/

# Garry's Mod DS
GarrysModDS/
  └── garrysmod/
    └── ui/
      └── {project_name}/
        ├── assets/
        └── index.html
```