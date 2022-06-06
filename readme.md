# Rufaydium Quick Menu

Menu to assist during scripts using [Rufaydium](https://github.com/Xeo786/Rufaydium-Webdriver), a WebDriver library for AutoHotkey.

It will paste the selected entry from a submenu at the current caret location in your editor.

![Rufaydium Quick Menu screenshot](https://raw.githubusercontent.com/hi5/_resources/master/RufaydiumQuickMenu.png)

## Setup

At first startup it will create `RufaydiumQuickMenu.ini`. Available keys:

| Key     | Default |
|---------|---------|
| Hotkey  | ^k      | 
| Editor  | ERROR   |
| Browser | Browser | 
| Session | Session | 

Hotkey in AutoHotkey notation used to show the menu.

Editor one executable name (notepad.exe, notepad++.exe, atom.exe, etc) to make limit the menu to specific program.  

Examples:

Define `Browser` as `Chrome`, in the Menu `Browser:=new Rufaydium()` becomes `Chrome:=new Rufaydium()`  
Define `Session` as `MyPage`, in the Menu `Session.NewTab()` becomes `MyPage.NewTab()`

## Quick Access / Favourites (1)

To add personal favourites to the menu, create a file called `QuickAccess.txt`. Each line in that file will become a menu entry.  
Text after a semi-colon `;` will become a menu hint.  
Restart Rufaydium Quick Menu after editing `QuickAccess.txt` for new/changed entries to be loaded.  

`QuickAccess.txt` will not be part of the Rufaydium Quick Menu repository[1].

Example:

```
Page.Navigate(url)
MyPage.getElementsbyName("img")[0].click() ; Click button
```

## Templates (2)

To add `My Templates` to the menu as entry in the menu, create a `Templates` folder first.  
Place AutoHotkey snippets and (template) files to that folder with the `.ahk` extension.  
Restart Rufaydium Quick Menu, and a new `My Templates` menu item should appear.

The `Templates` folder and the files therein will not be part of the Rufaydium Quick Menu repository[1].

Example:

`Templates\new script.ahk`

```AutoHotkey
#Include Rufaydium.ahk
Chrome:=new Rufaydium()
Page:=Chrome.NewSession()
Page.Navigate()
Return

; code here

#z:: ; winkey-z to close session, webdriver, browser and script
Chrome.QuitAllSessions() ; close all session 
Chrome.Driver.Exit() ; then exits driver
ExitApp
Return
```

## RufaydiumQuickMenu.txt (3)

Nearly all available regular Rufaydium/WebDriver command, functions, methods you may need to write a script.  
Suggestions for `RufaydiumQuickMenu.txt` and the script welcome via pull requests.

As there might be changes to `RufaydiumQuickMenu.txt` is probably best left unmodified.
any changes will be lost when updating from this repository. (See updating below).

## Updating

[1] Both `QuickAccess.txt` and the folder and files in `Templates` will not be part of this 
repository so updating the script should not affect your personal additions.

