# 移機與跨環境安裝指南 (Migration & Setup Guide)

本指南說明在更換電腦、移至新主機或建置全新開發環境時，如何快速將此 Skills 專案庫安裝並配置到各類 AI 助理（Antigravity、Claude Code、Codex、Gemini App、Cursor 等）。

---

## 目錄
1. [第一步：在新環境取得專案庫](#1-第一步在新環境取得專案庫)
2. [第二步：本機一鍵安裝（支援 Agent Skills / Claude / Antigravity）](#2-第二步本機一鍵安裝支援-agent-skills--claude--antigravity)
3. [第三步：各主流 Agent 官方安裝途徑（選用）](#3-第三步各主流-agent-官方安裝途徑選用)
4. [第四步：在 Gemini 桌面 App 與網頁版使用](#4-第四步在-gemini-桌面-app-與網頁版使用)
5. [第五步：新專案首次初始化配置](#5-第五步新專案首次初始化配置)

---

## 1. 第一步：在新環境取得專案庫

在新的主機上，透過 Git 將專案庫下載至本地（例如 `D:\Workspace\skills` 或 `~/skills`）：

```bash
git clone https://github.com/mattpocock/skills.git
cd skills
```

---

## 2. 第二步：本機一鍵安裝（支援 Agent Skills / Claude / Antigravity）

本專案提供了跨平台的本機安裝腳本，會將 Engineering 與 Productivity 等核心 Skills 自動部署到各 Agent 認定的標準目錄（`~/.agents/skills` 與 `~/.claude/skills`）。

### A. Windows 環境 (PowerShell)

在專案根目錄下以 PowerShell 執行：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install-skills.ps1 -IncludeInProgress
```

* 作用：將 35 個 Skills 完整複製至：
  * `C:\Users\<使用者名稱>\.agents\skills\`（供 Antigravity、Codex 及 Agent Skills 標準工具讀取）
  * `C:\Users\<使用者名稱>\.claude\skills\`（供 Claude Code 本地讀取）

### B. macOS / Linux 環境 (Bash)

在終端機中執行內建的符號連結腳本：

```bash
chmod +x ./scripts/link-skills.sh
./scripts/link-skills.sh
```

* 作用：在 `~/.agents/skills` 與 `~/.claude/skills` 建立指向此專案庫的軟連結（Symlinks），日後只要執行 `git pull` 即可自動同步更新。

### C. Antigravity / Gemini 工作區原生註冊

若要在 Antigravity 工作區中直接載入本專案，確保專案根目錄的 `.agents/skills.json` 存在並包含以下設定：

```json
{
  "entries": [
    { "path": "skills/engineering" },
    { "path": "skills/productivity" }
  ]
}
```

---

## 3. 第三步：各主流 Agent 官方安裝途徑（選用）

如果您在另一台主機上使用的是特定 Agent 的命令列套件管理器，可直接使用以下命令：

### Claude Code (外掛自動更新)
```bash
claude plugin install mattpocock-skills@claude-plugins-official
```

### Codex (市集套件)
```bash
codex plugin marketplace add mattpocock/skills
codex plugin add mattpocock-skills@mattpocock
```

### GitHub Copilot (CLI & VS Code)
```bash
copilot plugin marketplace add mattpocock/skills
copilot plugin install mattpocock-skills@mattpocock
```
並在 `~/.copilot/settings.json` 加入：
```json
{
  "extraKnownMarketplaces": {
    "mattpocock": { "source": { "source": "github", "repo": "mattpocock/skills" }, "autoUpdate": true }
  }
}
```

### Gemini CLI
```bash
gemini skills install https://github.com/mattpocock/skills.git --path skills/engineering
gemini skills install https://github.com/mattpocock/skills.git --path skills/productivity
```

### 其他 Agent (Cursor, Windsurf, OpenCode, Devin 等)
透過 skills.sh 套件管理器：
```bash
npx skills@latest add mattpocock/skills -a <agent>
# <agent> 可選: cursor, windsurf, opencode, devin, amp, pi
```

> **注意**：每台機器、每個 Agent 選擇一種安裝方式即可（套件安裝或本機檔案連結二選一），避免同一個技能被載入兩次。

---

## 4. 第四步：在 Gemini 桌面 App 與網頁版使用

在非 Agent 程式碼編輯器（如 Google Gemini 桌面 App、gemini.google.com 網頁版、手機版 App）中，模型處於純對話模式，可透過以下方式載入技能：

### 推薦方案：建立專屬 Gem (自訂助理)
1. 開啟 Gemini App 或網頁版，在左側邊欄點選「... 顯示更多」➜「Gems」➜「新建自訂 Gem」。
2. 為 Gem 命名（例如：`架構訪談專家 (Grill-Me)`、`代碼審查員 (Code Review)`）。
3. 開啟本機對應的 `SKILL.md`（例如 `skills/productivity/grill-me/SKILL.md`），複製全文貼入「操作說明 (Instructions)」。
4. 儲存後，該 Gem 會常駐在左側選單，隨時點選即可啟動該技能的對話模式。

### 臨時使用方案：上傳檔案
1. 點擊輸入框旁的「+」（上傳檔案）。
2. 選取本機的 `SKILL.md` 檔案上傳。
3. 提示詞輸入：「請嚴格依據附件 SKILL.md 的指引與規則，對我接下來提出的需求進行深度訪談 (Grill) / 審查。」

---

## 5. 第五步：新專案首次初始化配置

當在新的程式專案中要開始使用這些技能時：

1. 在 Agent 對話框中輸入：
   ```text
   /setup-matt-pocock-skills
   ```
2. Agent 會引導您確認三項設定：
   * **Issue Tracker**：工作任務存放在何處（GitHub Issues、GitLab、或本地 Markdown `.scratch/`）。
   * **Triage Labels**：Issue 分類標籤命名。
   * **Domain Docs**：專案領域名詞表（`GLOSSARY.md`）與架構決策（`docs/adr/`）的存放路徑。
3. 設定完成後，即可直接調用 `/ask-matt`、`/grill-me`、`/to-spec`、`/tdd` 等指令開始高品質工程開發。
