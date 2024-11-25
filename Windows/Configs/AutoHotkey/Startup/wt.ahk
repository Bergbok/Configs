#Requires AutoHotkey v2.0

; modified from: https://blog.danskingdom.com/Bring-up-the-Windows-Terminal-in-a-keystroke

SwitchToWindowsTerminal() {
    windowHandleId := WinExist("ahk_exe WindowsTerminal.exe")

    if (windowHandleId > 0) {
        activeWindowHandleId := WinExist("A")
        windowIsAlreadyActive := activeWindowHandleId == windowHandleId

        if (windowIsAlreadyActive) {
            WinMinimize("ahk_exe WindowsTerminal.exe")
        }
        else {
            WinActivate("ahk_exe WindowsTerminal.exe")
            WinShow("ahk_exe WindowsTerminal.exe")
        }
    }
    else {
        Run("wt")
    }
}

; Ctrl+Alt+T
^!t:: SwitchToWindowsTerminal()
