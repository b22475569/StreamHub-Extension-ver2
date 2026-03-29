' ============================================================
' Stream Hub Chrome Launcher  Ver 192.18  — Online Sync Edition
' ============================================================
' Revision Notes (2026-03-29):
'   [OK] Unlocker Hovor let music preview play audio and increase volume icon and feature
'   [OK] Removed Port 8178 chrome_history_server.py (deprecated)
'        Ver 192.18 HTML syncs via Chrome Extension — no local Python
'        history server required.
'   [OK] Kept Port 8078 HTTP server (required: allows Extension to
'        correctly bridge page events via http:// protocol)
'   [OK] htmlFile updated to match latest filename Ver-178_2
'   [OK] Added Chrome Extension status reminder on launch
' ============================================================
Option Explicit

Dim WshShell, FSO
Set WshShell = CreateObject("WScript.Shell")
Set FSO      = CreateObject("Scripting.FileSystemObject")

' ── Path Configuration (edit this block if needed) ─────────
Dim siteDir, htmlFile, url, chromePath
siteDir    = "C:\Users\Administrator\OneDrive\Desktop\StreamHub-Extension"
htmlFile   = "Stream-Hub_Ver-192_18_with_98-XP_sound-Smooth-Carousel_Securd.html"
url        = "http://localhost:8078/" & htmlFile
chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"
' ────────────────────────────────────────────────────────────

' ── Check: site folder exists ────────────────────────────────
If Not FSO.FolderExists(siteDir) Then
    MsgBox "ERROR: Site folder not found:" & Chr(13) & siteDir & Chr(13) & Chr(13) & _
           "Please verify the folder path is correct.", vbCritical, "Stream Hub Launch Error"
    WScript.Quit 1
End If

' ── Check: HTML main file exists ─────────────────────────────
If Not FSO.FileExists(siteDir & "\" & htmlFile) Then
    MsgBox "ERROR: HTML file not found:" & Chr(13) & htmlFile & Chr(13) & Chr(13) & _
           "Please make sure the file is placed in:" & Chr(13) & siteDir, vbCritical, "Stream Hub Launch Error"
    WScript.Quit 1
End If

' ── Check: Chrome is installed ───────────────────────────────
If Not FSO.FileExists(chromePath) Then
    MsgBox "ERROR: Chrome not found:" & Chr(13) & chromePath & Chr(13) & Chr(13) & _
           "Please confirm Google Chrome is installed.", vbCritical, "Stream Hub Launch Error"
    WScript.Quit 1
End If

' ── Start HTTP static server (Port 8078) ─────────────────────
' Purpose: Serves the HTML over http:// so the Chrome Extension
'          event bridge (streamhub:request_history) works correctly.
'          Skipped automatically if already running.
Dim chk1
chk1 = WshShell.Run( _
    "cmd /c netstat -ano | find "":8078"" | find ""LISTENING"" > nul 2>&1", _
    0, True)
If chk1 <> 0 Then
    WshShell.Run "cmd /c cd /d """ & siteDir & """ && python -m http.server 8078", 0, False
    WScript.Sleep 2500
End If

' ── NOTE: Port 8178 chrome_history_server.py has been removed --
' Ver 178.2 syncs Chrome history via the Chrome Extension
' (streamhub:request_history CustomEvent + chrome.history API).
' A local Python history server is no longer needed.
' Port 8178 is no longer used.

' ── Launch Chrome and open Stream Hub ────────────────────────
WshShell.Run """" & chromePath & """ --new-window """ & url & """"


