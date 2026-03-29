' ============================================================
' Stream Hub Chrome Launcher  Ver 178.2  — 線上同步版
' ============================================================
' 修訂說明（2026-03-15）：
'   ✅ 移除 Port 8178 chrome_history_server.py（已廢棄）
'      Ver 178.2 HTML 使用 Chrome Extension 同步，不需本地 Python history server
'   ✅ 保留 Port 8078 HTTP server（必要：讓 Extension 可正確橋接頁面）
'   ✅ 修正 htmlFile 對應最新檔名 Ver-178_2
'   ✅ 新增 Chrome Extension 存在提示
' ============================================================
Option Explicit

Dim WshShell, FSO
Set WshShell = CreateObject("WScript.Shell")
Set FSO      = CreateObject("Scripting.FileSystemObject")

' ── 路徑設定（如有需要請修改此區塊）────────────────────────
Dim siteDir, htmlFile, url, chromePath
siteDir    = "C:\Users\Administrator\OneDrive\Desktop\StreamHub-Extension"
htmlFile   = "Stream-Hub_Ver-178_2_with_98-XP_sound-Smooth-Carousel_Securd.html"
url        = "http://localhost:8078/" & htmlFile
chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"
' ────────────────────────────────────────────────────────────

' ── 檢查：網站資料夾是否存在 ─────────────────────────────────
If Not FSO.FolderExists(siteDir) Then
    MsgBox "❌ 找不到網站資料夾：" & Chr(13) & siteDir & Chr(13) & Chr(13) & _
           "請確認路徑是否正確。", vbCritical, "Stream Hub 啟動錯誤"
    WScript.Quit 1
End If

' ── 檢查：HTML 主檔是否存在 ──────────────────────────────────
If Not FSO.FileExists(siteDir & "\" & htmlFile) Then
    MsgBox "❌ 找不到 HTML 主檔：" & Chr(13) & htmlFile & Chr(13) & Chr(13) & _
           "請確認檔案已放入資料夾：" & Chr(13) & siteDir, vbCritical, "Stream Hub 啟動錯誤"
    WScript.Quit 1
End If

' ── 檢查：Chrome 是否已安裝 ──────────────────────────────────
If Not FSO.FileExists(chromePath) Then
    MsgBox "❌ 找不到 Chrome：" & Chr(13) & chromePath & Chr(13) & Chr(13) & _
           "請確認 Google Chrome 已安裝。", vbCritical, "Stream Hub 啟動錯誤"
    WScript.Quit 1
End If

' ── 啟動 HTTP 靜態伺服器（Port 8078）────────────────────────
' 用途：讓 Chrome 以 http:// 開啟 HTML，使 Extension 事件橋接正常運作
' 如已在執行則跳過
Dim chk1
chk1 = WshShell.Run( _
    "cmd /c netstat -ano | find "":8078"" | find ""LISTENING"" > nul 2>&1", _
    0, True)
If chk1 <> 0 Then
    WshShell.Run "cmd /c cd /d """ & siteDir & """ && python -m http.server 8078", 0, False
    WScript.Sleep 2500
End If

' ── NOTE：Port 8178 chrome_history_server.py 已移除 ──────────
' Ver 178.2 使用 Chrome Extension (streamhub:request_history) 同步歷史紀錄
' 不再需要本地 Python history server，Port 8178 不再使用。

' ── 啟動 Chrome，開啟 Stream Hub ─────────────────────────────
WshShell.Run """" & chromePath & """ --new-window """ & url & """"

' ── 提醒：確認 Extension 已啟用 ─────────────────────────────
WScript.Sleep 2000
MsgBox "✅ Stream Hub 已啟動！" & Chr(13) & Chr(13) & _
       "📌 如歷史紀錄顯示「擴充功能未連接」：" & Chr(13) & _
       "   1. 開啟 chrome://extensions" & Chr(13) & _
       "   2. 確認「StreamHub History Bridge」已啟用" & Chr(13) & Chr(13) & _
       "Port 8078 HTTP Server：執行中 ✅" & Chr(13) & _
       "Port 8178 History Server：不需要 ✅（已移除）", _
       vbInformation, "Stream Hub Ver 178.2"
