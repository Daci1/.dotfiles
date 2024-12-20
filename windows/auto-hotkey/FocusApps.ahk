SnapToZone() {
	Send("#{Up}")
}

MoveCursorToWindow(windowTitleOrExe) {
	;if WinExist(windowTitleOrExe) ; Check if the window exists
	;{
		; Get the position of the window
			;WinGetPos(&x, &y, &width, &height, windowTitleOrExe)

			; Calculate the center position
			;xPos := x + (width / 2)
			;yPos := y + (height / 2)

			; Move the mouse to the center of the window
			;MouseMove xPos, yPos, 0
	;}
}

OpenWindowsExplorer() {
    if WinExist("ahk_class CabinetWClass") ; Check if it's running
    {
        WinActivate() ; Bring the window to the front
    }
    else
    {
        Run("explorer.exe") ; Launch if not running
    }
    MoveCursorToWindow("ahk_class CabinetWClass")
}

; #1::OpenWindowsExplorer() ; Win + 1 hotkey
#e::OpenWindowsExplorer() ; Win + e hotkey

#2:: ; Win + 2 hotkey
{
    if WinExist("ahk_exe brave.exe") ; Check if it's running
    {
        WinActivate() ; Bring the window to the front
    }
    else
    {
        Run("brave.exe") ; Launch if not running
    }
    MoveCursorToWindow("ahk_exe brave.exe")
}

#3:: ; Win + 3 hotkey
{
    if WinExist("ahk_exe Discord.exe") ; Check if it's running
    {
        WinActivate() ; Bring the window to the front
    }
    else
    {
        Run("C:\Users\daci\AppData\Local\Discord\Update.exe --processStart Discord.exe") ; Launch if not running
    }
    MoveCursorToWindow("ahk_exe Discord.exe")
}

#4:: ; Win + 4 hotkey
{
    if WinExist("ahk_exe steamwebhelper.exe") ; Check if it's running
    {
        WinActivate() ; Bring the window to the front
    }
    else
    {
        Run("D:\Steam\steam.exe") ; Launch if not running
    }
    MoveCursorToWindow("ahk_exe steamwebhelper.exe")
}

#5:: ; Win + 5 hotkey
{
    if WinExist("ahk_exe Battle.net.exe") ; Check if it's running
    {
        WinActivate() ; Bring the window to the front
    }
    else
    {
        Run("D:\Battle.net\Battle.net Launcher.exe") ; Launch if not running
    }
    MoveCursorToWindow("ahk_exe Battle.net.exe")
}


#t:: ; Win + t hotkey
{
    if WinExist("ahk_exe WindowsTerminal.exe") ; Check if it's running
    {
        WinActivate() ; Bring the window to the front
    }
    else
    {
        Run("wt.exe") ; Launch if not running
	WinWait("ahk_exe WindowsTerminal.exe") ; Wait for the terminal window to appear
    	WinActivate("ahk_exe WindowsTerminal.exe") ; Activate and focus the terminal window
	SnapToZone()
    }
    MoveCursorToWindow("ahk_exe WindowsTerminal.exe")
}

#q::Send("{Alt down}{F4}{Alt Up}")

#1:: ; Win + 1 hotkey
{
    ; Get information about the second monitor
    MonitorGet(2, &left, &top, &right, &bottom)


    ; Calculate the center position of the second monitor
    xPos := left + (right - left) / 2
    yPos := top + (bottom - top) / 2

    ; Move the mouse to the center of the second monitor
    MouseMove(xPos, yPos, 0)
    Click()
}
