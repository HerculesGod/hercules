Set oShell = CreateObject("WScript.Shell")
Set oFSO = CreateObject("Scripting.FileSystemObject")

Function IsAdmin()
    On Error Resume Next
    Dim sTestFile
    sTestFile = "C:\Windows\System32\testadm_" & Int(Rnd * 99999) & ".tmp"
    Set oTestFile = oFSO.CreateTextFile(sTestFile, True)
    If Err.Number = 0 Then
        oTestFile.Close
        oFSO.DeleteFile sTestFile, True
        IsAdmin = True
    Else
        IsAdmin = False
    End If
    On Error GoTo 0
End Function

Do While Not IsAdmin()
    Set oShellApp = CreateObject("Shell.Application")
    oShellApp.ShellExecute "wscript.exe", Chr(34) & WScript.ScriptFullName & Chr(34), "", "runas", 0
    WScript.Sleep 10000
    If IsAdmin() Then WScript.Quit
Loop

Sub LimparPasta(sCaminho)
    On Error Resume Next
    If oFSO.FolderExists(sCaminho) Then
        Dim oFolder
        Set oFolder = oFSO.GetFolder(sCaminho)
        Dim oFile
        For Each oFile In oFolder.Files
            oFSO.DeleteFile oFile.Path, True
        Next
        Dim oSubFolder
        For Each oSubFolder In oFolder.SubFolders
            oFSO.DeleteFolder oSubFolder.Path, True
        Next
    End If
    On Error GoTo 0
End Sub

Sub DeletarArquivo(sArquivo)
    On Error Resume Next
    If oFSO.FileExists(sArquivo) Then
        oFSO.DeleteFile sArquivo, True
    End If
    On Error GoTo 0
End Sub

Dim sTemp, sWinTemp, sPrefetch, sAppData, sLocalAppData

sTemp         = oShell.ExpandEnvironmentStrings("%TEMP%")
sWinTemp      = "C:\Windows\Temp"
sPrefetch     = "C:\Windows\Prefetch"
sAppData      = oShell.ExpandEnvironmentStrings("%APPDATA%")
sLocalAppData = oShell.ExpandEnvironmentStrings("%LOCALAPPDATA%")

LimparPasta sTemp
LimparPasta sWinTemp
LimparPasta sPrefetch

LimparPasta sLocalAppData & "\Google\Chrome\User Data\Default\Cache"
LimparPasta sLocalAppData & "\Google\Chrome\User Data\Default\Code Cache"
DeletarArquivo sLocalAppData & "\Google\Chrome\User Data\Default\Cookies"
DeletarArquivo sLocalAppData & "\Google\Chrome\User Data\Default\Cookies-journal"

LimparPasta sLocalAppData & "\Microsoft\Edge\User Data\Default\Cache"
LimparPasta sLocalAppData & "\Microsoft\Edge\User Data\Default\Code Cache"
DeletarArquivo sLocalAppData & "\Microsoft\Edge\User Data\Default\Cookies"
DeletarArquivo sLocalAppData & "\Microsoft\Edge\User Data\Default\Cookies-journal"

Dim sFirefoxProfiles
sFirefoxProfiles = sAppData & "\Mozilla\Firefox\Profiles"
If oFSO.FolderExists(sFirefoxProfiles) Then
    Dim oProfilesFolder
    Set oProfilesFolder = oFSO.GetFolder(sFirefoxProfiles)
    Dim oProfile
    For Each oProfile In oProfilesFolder.SubFolders
        DeletarArquivo oProfile.Path & "\cookies.sqlite"
        DeletarArquivo oProfile.Path & "\cookies.sqlite-wal"
        DeletarArquivo oProfile.Path & "\cookies.sqlite-shm"
        LimparPasta oProfile.Path & "\cache2"
        LimparPasta oProfile.Path & "\startupCache"
    Next
End If

LimparPasta sAppData & "\Opera Software\Opera Stable\Cache"
DeletarArquivo sAppData & "\Opera Software\Opera Stable\Cookies"
DeletarArquivo sAppData & "\Opera Software\Opera Stable\Cookies-journal"

LimparPasta sLocalAppData & "\BraveSoftware\Brave-Browser\User Data\Default\Cache"
LimparPasta sLocalAppData & "\BraveSoftware\Brave-Browser\User Data\Default\Code Cache"
DeletarArquivo sLocalAppData & "\BraveSoftware\Brave-Browser\User Data\Default\Cookies"
DeletarArquivo sLocalAppData & "\BraveSoftware\Brave-Browser\User Data\Default\Cookies-journal"