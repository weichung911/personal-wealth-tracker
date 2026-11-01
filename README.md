# 個人資產追蹤 Web App（GitHub Pages + Supabase）

這個版本將網站放在 GitHub Pages，將個人資產紀錄放在 Supabase。每個使用者以 Email/密碼登入，資料表透過 RLS 限制只能讀寫自己的資料。

## 1. 建立 Supabase 專案

1. 到 https://supabase.com 建立一個 project。
2. 開啟 **SQL Editor**，將本專案的 `supabase-schema.sql` 全文貼上並執行。
3. 到 **Project Settings → API**（或 API Keys）複製 Project URL 和 publishable/anon key。
4. 到 **Authentication → URL Configuration**，將 Site URL 設成你的 GitHub Pages 網址，例如 `https://你的帳號.github.io/asset-tracker/`；並將同一網址加入 Redirect URLs。
5. Email confirmation 可保持啟用；註冊後依信件完成驗證再登入。

## 2. 設定前端

1. 用文字編輯器開啟 `config.js`。
2. 將 `YOUR_SUPABASE_PROJECT_URL` 換成 Supabase Project URL。
3. 將 `YOUR_SUPABASE_PUBLISHABLE_OR_ANON_KEY` 換成 publishable key（舊專案可能顯示 anon key）。
4. **不要使用 `service_role` 或 `sb_secret_...` key。** 這類金鑰有管理權限，絕對不可放在前端。

## 3. 部署到 GitHub Pages

1. 在 GitHub 建立一個 repository，例如 `asset-tracker`。
2. 將 `index.html`、`config.js`、`README.md`、`supabase-schema.sql` 上傳到 repository 根目錄。不要上傳私人備份 JSON。
3. 到 repository 的 **Settings → Pages**。
4. 在 Build and deployment 選 **Deploy from a branch**，Branch 選 `main`，Folder 選 `/ (root)`，按 Save。
5. 等 Pages 發布完成，網址通常是 `https://你的帳號.github.io/asset-tracker/`。
6. 把這個網址加入 Supabase Authentication 的 Site URL / Redirect URLs。

GitHub Pages 是靜態網站託管；它不負責保存你的私人紀錄。資產資料只寫入 Supabase，並由資料庫 RLS 規則保護。

## 4. 匯入原本的資產紀錄

1. 開啟部署好的網站，建立帳號並登入。
2. 使用 App 右上角「匯入備份」，選擇你從舊版 App 匯出的 JSON。匯入會取代該帳號目前的雲端紀錄。
3. 如果手邊沒有舊版備份，可使用另外提供的 `asset-initial-data.json` 匯入初始四筆紀錄。該檔案含有個人財務資料，**只在 App 裡匯入，不要上傳至 GitHub**。

## 5. 跨裝置使用

在每一台裝置開啟相同 GitHub Pages 網址，以同一個 Email/密碼登入。儲存或刪除紀錄時會寫入雲端；切換裝置後按「同步」或重新整理即可讀取最新資料。

## 安全提醒

- GitHub repository 建議只放網站程式，不放任何資產紀錄或備份。
- `config.js` 中的 Supabase publishable/anon key 是前端公開識別用 key；安全性依賴已啟用的 RLS policies。
- 絕對不要把 Supabase secret/service_role key 放到 `config.js`、HTML、GitHub 或任何瀏覽器程式碼。
- 請使用強密碼並定期匯出 JSON 備份。
- 本 App 依照原先紀錄方式將四個欄位直接相加；請確認美金資產欄位填的是你已換算成台幣的數值，避免混用幣別。
