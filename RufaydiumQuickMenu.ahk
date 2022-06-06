/*
RufaydiumQuickMenu - v1.0
Quick help menu to assist during scripts using Rufaydium, a WebDriver library for AutoHotkey.

More about Rufaydium:
Github           : https://github.com/Xeo786/Rufaydium-Webdriver
AutoHotkey forum : https://www.autohotkey.com/boards/viewtopic.php?f=6&t=102616
*/

#NoEnv
#SingleInstance, force
SetBatchLines, -1
ListLines, Off
SetKeyDelay, -1
SendMode, Input

Menu, Tray, Icon, res\r.ico

If !FileExist(A_ScriptDir "\RufaydiumQuickMenu.ini")
	{
	 IniWrite, ^k       , %A_ScriptDir%\RufaydiumQuickMenu.ini, settings, Hotkey
	 IniWrite, ERROR    , %A_ScriptDir%\RufaydiumQuickMenu.ini, settings, Editor
	 IniWrite, Browser  , %A_ScriptDir%\RufaydiumQuickMenu.ini, settings, Browser
	 IniWrite, Session  , %A_ScriptDir%\RufaydiumQuickMenu.ini, settings, Session
	}

IniRead, Hotkey , %A_ScriptDir%\RufaydiumQuickMenu.ini, settings, Hotkey  , ^k
IniRead, Editor , %A_ScriptDir%\RufaydiumQuickMenu.ini, settings, Editor
IniRead, Browser, %A_ScriptDir%\RufaydiumQuickMenu.ini, settings, Browser , Browser
IniRead, Session, %A_ScriptDir%\RufaydiumQuickMenu.ini, settings, Session , Session

FileRead, MenuData, RufaydiumQuickMenu.txt

If !RegExMatch(Editor,"\.exe$")
	Editor:="ERROR"

If (Editor <> "ERROR")
	Hotkey, IfWinActive, ahk_exe %Editor%

Hotkey, %Hotkey%, ShowMenu

If (Browser <> "Browser")
	MenuData:=RegExReplace(MenuData,"imU)^(\s+)Browser","$1" Browser)
If (Session <> "Session")
	MenuData:=RegExReplace(MenuData,"imU)^(\s+)Session","$1" Session)
If (Browser <> "Browser") or (Session <> "Session")
	MenuData:=RegExReplace(MenuData,"imU)Session:=Browser",Session ":=" Browser)

SubmenuCounter:=0

Gui, RQMSetup:New
Gui, RQMSetup: +ToolWindow AlwaysOnTop
Gui, RQMSetup:Font, bold
Gui, RQMSetup:Add, Link, x5 y5   , Rufaydium Quick Menu @ <a href="https://github.com/hi5/RufaydiumQuickMenu">GitHub</a> @ <a href="https://www.autohotkey.com/boards/viewtopic.php?f=6&t=104985">AHK forum</a>.
Gui, RQMSetup:Font,
Gui, RQMSetup:Add, Link, x5 yp+20, <a href="https://github.com/Xeo786/Rufaydium-Webdriver">Rufaydium</a> is a Webdriver Library for AutoHotkey by <a href="https://github.com/Xeo786/Rufaydium-Webdriver">Xeo786</a>.
Gui, RQMSetup:Add, Button, x5     yp+30  w100 h25 gSetup, Setup
Gui, RQMSetup:Add, Button, xp+190 yp     w100 h25 gClose, Close
Menu, RQM, Add, Rufaydium Quick Menu - v1, MenuHandler
Menu, RQM, Icon, Rufaydium Quick Menu - v1, res\r.ico
Menu, RQM, Default, Rufaydium Quick Menu - v1
Menu, RQM, Add,

If FileExist("QuickAccess.txt")
	{
	 Loop, Read, QuickAccess.txt
		{
		 line:=Trim(A_LoopReadLine,"`r`n")
		 QuickMenuTitle:=Trim(StrSplit(line,";").1)
		 QuickMenuTip:=Trim(StrSplit(line,";").2) ? ": " Trim(StrSplit(line,";").2) : ""
		 Menu, RQM, Add, % "&" QuickMenuTitle "`t" QuickMenuTip, MenuHandler
		}
	 Menu, RQM, Add,
	}

If (FileExist(A_ScriptDir "\Templates") = "D")
	{
	 Loop, Files, %A_ScriptDir%\Templates\*.ahk, F
		MyTemplateFiles .= A_LoopFileName "`n"
	 MyTemplateFiles:=Trim(MyTemplateFiles,"`n")
	 Sort, MyTemplateFiles
	 Loop, parse, MyTemplateFiles, `n
	 	Menu, Templates, Add, %A_LoopField%, MenuHandler
	 Menu, RQM, Add, My &Templates, :Templates
	 Menu, RQM, Add,
	}

Loop, parse, MenuData, `n, `r
	{
	 line:=A_LoopField
	 If (line = "")
		Continue
	 If RegExMatch(line,"^\w")
	 {
		Try ; we start a new 1st level menu, so add previous 2nd level to previous 1st level
			Menu, RQM, Add, % "&" MenuTitle "`t" MenuTip, :%MenuTitle%
;		Switch MenuTitle ; disable for now, need to check available icons
;			{
;			 Case "Driver and Browsers": Menu, RQM, Icon, % "&" MenuTitle "`t" MenuTip, %A_WinDir%\System32\shell32.dll, 14
;			 Case "Window position":     Menu, RQM, Icon, % "&" MenuTitle "`t" MenuTip, %A_WinDir%\System32\shell32.dll, 3
;			 Case "Screenshot / PDF":    Menu, RQM, Icon, % "&" MenuTitle "`t" MenuTip, %A_WinDir%\System32\shell32.dll, 59
;			 Case "Mouse":               Menu, RQM, Icon, % "&" MenuTitle "`t" MenuTip, %A_WinDir%\System32\setupapi.dll, 2
;			 Case "SendKey":             Menu, RQM, Icon, % "&" MenuTitle "`t" MenuTip, %A_WinDir%\System32\setupapi.dll, 3
;			}
		MenuTitle:=Trim(StrSplit(line,";").1)
		MenuTip:=Trim(StrSplit(line,";").2)
		SubmenuCounter++
		Continue
	 }
		; create 2nd level (submenu)
		SubMenuTitle:=Trim(StrSplit(line,";").1)
		SubMenuTip:=Trim(StrSplit(line,";").2) ? ": " Trim(StrSplit(line,";").2) : ""
	 	Menu, %MenuTitle%, Add, % SubMenuTitle "`t" SubMenuTip, MenuHandler
	}

Menu, RQM, Add,
Menu, RQM, Add, E&xit, MenuHandler

Return

ShowMenu:
MenuX:=A_CaretX+10
MenuY:=A_CaretY+10
If (A_CaretX =0) and (A_CaretY =0)
	{
	 MouseGetPos, MenuX, MenuY
	 MenuX+=10, MenuY+=10
	}
Menu, RQM, Show, %MenuX%, %MenuY%
Return

MenuHandler:
If (A_ThisMenuItem = "E&xit")
	{
	 ExitApp
	 Return
	}
If !(A_ThisMenuItem = "Rufaydium Quick Menu - v1")
	{
	 ClipboardSave:=ClipboardAll
	 Clipboard:=""
	 Item:=Ltrim(StrSplit(A_ThisMenuItem,A_Tab).1,"&")
	 If RegExMatch(Item,"\.ahk$")
		FileRead, item, %A_ScriptDir%\Templates\%item%
	 Clipboard:=Item
	 ClipWait, 1
	 Send, ^v
	 Clipboard:=ClipboardAll
	 ClipboardSave:=""
	 Return
	}
Gui, RQMSetup:Show, w300 h90, Rufaydium Quick Menu
Return

Setup:
Gui, RQMSetup:Hide
Run, notepad %A_ScriptDir%\RufaydiumQuickMenu.ini
Return

Close:
Gui, RQMSetup:Hide
Return
