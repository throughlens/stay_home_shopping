
Logger(text){
    
    FormatTime, CurrentDateTime,, yyyy-MM-dd-HH:mm:ss
    FileAppend, %CurrentDateTime% %text%`n, G:\Test Blue Iris Recording\Dropbox\Auto Shopping Log\autobooking.log
    
}


LoggerError(text){
    
    FormatTime, CurrentDateTime,, yyyy-MM-dd-HH:mm:ss
    FileAppend, %CurrentDateTime% %text%`n, G:\Test Blue Iris Recording\Dropbox\Auto Shopping Log\autobookingError.log
    
}

PrintScreen(){
    
    Send {PrintScreen}
    IfWinExist untitled - Paint
    {
        WinActivate, untitled - Paint
    }
    else
    {
        Run mspaint
        ; WinWait untitled - Paint
        WinActivate, untitled - Paint
    }
    sleep, 1000
    Send ^v
    sleep, 1000
    FormatTime, T, %A_Now%, yyyy-MMM-dd HH-mm-ss
    Send ^s
    WinWait Save As
    WinActivate
    SendInput G:\Test Blue Iris Recording\Dropbox\Auto Shopping Log\%T%{Tab}j{Enter}
    ; WinWait %T%.JPG - Paint
    sleep, 1000
    WinActivate, %T%.JPG - Paint
    ; WinClose, %T%.JPG - Paint
    SendInput {LAlt Down}{F4} {LAlt Up}
    sleep, 200
    return
    
}

NotifyAlexa(NotifyAlexFlag)
{
    if(NotifyAlexFlag!=1)
    return
    url = "ulr to call your own alexa with secretes"
    WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1") 
    WebRequest.Open("GET", url)
    ; WebRequest.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
    WebRequest.Send(POSTDATA)
    ; Result := WebRequest.ResponseText
    ; WebRequest := ""
}
