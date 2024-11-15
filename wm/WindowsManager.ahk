#Requires AutoHotkey v2.0
#SingleInstance

SetWorkingDir(A_ScriptDir)
DetectHiddenWindows 1

hVirtualDesktopAccessor := DllCall("LoadLibrary", "Str", "VirtualDesktopAccessor.dll", "Ptr")

GetDesktopCountProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "GetDesktopCount", "Ptr")
MoveWindowToDesktopNumberProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "MoveWindowToDesktopNumber", "Ptr")
GoToDesktopNumberProc := DllCall("GetProcAddress", "Ptr", hVirtualDesktopAccessor, "AStr", "GoToDesktopNumber", "Ptr")

GetDesktopCount() {
    global GetDesktopCountProc
    count := DllCall(GetDesktopCountProc, "Int")
    return count
}

MoveCurrentWindowToDesktop(number) {
    global MoveWindowToDesktopNumberProc, GoToDesktopNumberProc
    activeHwnd := WinGetID("A")
    DllCall(MoveWindowToDesktopNumberProc, "Ptr", activeHwnd, "Int", number, "Int")
    DllCall(GoToDesktopNumberProc, "Int", number, "Int")
}

RunOrActivateWindow(winCriteria, winExePath, desktopNumber) {
    if WinExist(winCriteria) {
        WinActivate(winCriteria)
    }
    else {
        Run winExePath
        WinWait winCriteria
        WinActivate
        MoveCurrentWindowToDesktop(desktopNumber)
    }
}

;BrowserPath := "C:\Users\" A_UserName "\AppData\Local\Yandex\YandexBrowser\Application\"
#1::
{
    ;Run BrowserPath 'browser.exe --profile-directory="Profile 2"
    RunOrActivateWindow("((WorkProfile)) ahk_exe browser.exe", A_Programs "\browser2.lnk", 1)
}

#2::
{
    ;Run BrowserPath 'browser.exe --profile-directory="Profile 1"'
    RunOrActivateWindow("((ChillProfile)) ahk_exe browser.exe", A_Programs "\browser1.lnk", 1)
}

IDEList := [
    {criteria: "ahk_exe phpstorm64.exe", path: A_Programs "\JetBrains Toolbox\PhpStorm.lnk", desktop: 0},
    {criteria: "ahk_exe pycharm64.exe", path: A_Programs "\JetBrains Toolbox\PyCharm.lnk", desktop: 0},
    {criteria: "ahk_exe idea64.exe", path: A_Programs "\JetBrains Toolbox\IntelliJ IDEA Ultimate.lnk", desktop: 0},
    {criteria: "ahk_exe studio64.exe", path: A_Programs "\JetBrains Toolbox\Android Studio.lnk", desktop: 0},
]

IDECurrentIndex := 1 ; @todo: set current index


#3::
{
    RunOrActivateWindow(IDEList[IDECurrentIndex].criteria, IDEList[IDECurrentIndex].path, IDEList[IDECurrentIndex].desktop)
}

#4::
{
    RunOrActivateWindow("ahk_exe Obsidian.exe", A_Programs "\Obsidian.lnk", 1)
}

#5::
{
    Run A_ProgramsCommon "\KeePassXC\KeePassXC.lnk", , , &RunPid
}

#6::
{
    RunOrActivateWindow("ahk_exe Яндекс Музыка.exe", A_Programs "\Яндекс Музыка.lnk", 2)
}

#7::
{
    RunOrActivateWindow("ahk_exe Discord.exe", A_Programs "\Discord Inc\Discord.lnk", 2)
}

#8::
{
    Run A_Programs "\Яндекс.Диск\Яндекс.Диск.lnk"
}

#9::
{
    RunOrActivateWindow("ahk_exe Telegram.exe", A_Programs "\Telegram Desktop\Telegram.lnk", 2)
}
