#include %A_ScriptDir%\FindText.ahk
#include %A_ScriptDir%\util.ahk
; make sure to set browser resolution 80%%
CoordMode, Mouse, Screen

Logger("=============================================")
Logger("Application Started")

AutoPlaceOrder:=0 ;0 is pause, 1 is to auto order
NotifyAlexFlag:=1

StartVideoTime = 20200404000020
EndVideoTime = 20200404000400

ClickIntoPosition("Click Chrome Browser to focus",117,24,200) ;click home button 

send, {WheelUp 6} ;in case page has scroll bar

sleep,500

recording :=0

while !HasPayment(){
    
    
    refreshButton_x:=88
    refreshButton_y:=60
    
    homebuttonX:=117
    homebuttonY:=62
    
    ;home address https://www.amazon.com/gp/cart/view.html?ref_=nav_cart
    ClickIntoPosition("Click Home Button",homebuttonX,homebuttonY,200) ;click home button 


    ;=========================
    ;cart page
    ;=====================
    Text:="|<>*142$71.0000000000000000000000000000000000000000000000000000000000000000000000000000000000007800U0008000EE010010M0010wwuHYL1Fz0219+58cY2mG042HoAFF8DYY044Y8IWWEF980D9DCYtwkXGE00000000000000000000000000000000000000000000000000000000000000000000000000000000004"
    
    if (ok:=FindText(0,0 ,950,1024, 0.1, 0.1, Text))
    {
        CoordMode, Mouse
        X:=ok.1.x, Y:=ok.1.y
        ClickIntoPosition("Click Check Out",X,Y,5000)
        
        
    }
    else
    {
        msg = [Error]Cannot find Check Out button as expected on Cart Page, try later....
        PrintScreen()
        Logger(msg)
        continue
    }


    ;=================================
    ;before you check out
    ;==================================

    Text:="|<>*151$42.S001000E00E000kSSxTNDUGGFNNNknGFNNTEGGFNNMSSGRNDDU"
    
    if (ok:=FindText(0,0,1800,1800, 0.2, 0.2, Text))
    {
        CoordMode, Mouse
        X:=ok.1.x, Y:=ok.1.y, Comment:=ok.1.id
        ClickIntoPosition("Click Continue at Before you Check Out Page",X,Y,5000)
    }
    else{
         msg = [Error]Cannot find continue button on Before you check out page , continue again....
         PrintScreen()
        Logger(msg)
        continue
    }


    ;===============
    ;critical to check if the slot is grabbed
    ;===========================

    Text:="|<>*159$71.00000000000000000000000000000000000000000000000000000000000Dw000A000000Tw000M000000kM0000000001UkwMRUsklUkP1XwMn7wnX1lbzAAlaANba1XDsTtaATnDM3CNkzlgNzXqk3MllU3slU7jU6lVnb7VX6DC0D31Xw737wCQ0C63XkC67kMs0Q00000000000k00000000007U0000000000C000000000000000000000000000000000000000000000000000000000001"
    if (ok:=FindText(0,0,1800,1800, 0.2, 0.2, Text))
    {
        NotifyAlexa(NotifyAlexFlag)
        txt = [Slot]Booked Slot, Take Action
        PrintScreen()
        Logger(txt)
        MsgBox, %txt%
        ExitApp
    }

    
    t1:=A_TickCount, X:=Y:=""
    
    ; for today's text
    Text:="|<>*158$30.y0300803008QTCN8WH3/8WHD+8mHPC8QTD6000040000AU"
    
    day1_x:=100
    day1_y:=100
    
    if (ok:=FindText(0,0 ,950,1024, 0.2, 0.2, Text))
    {
        day1_x:= ok.1.x
        day1_y:= ok.1.y
        
    }
    else{ ;no today found, then try to click countinue because some cart changes
        
        
        Text:="|<>*147$40.S00200340100083baj9CUNPGqYa155++LwKIIcd8SCHOWwy"
        if (ok:=FindText(0,0 ,950,1024, 0.2, 0.2, Text))
        {
            contx:= ok.1.x
            conty:= ok.1.y
            ClickIntoPosition("Click Continue Button because some cart changes",contx,conty,200)
        }
        else{
            
            ;break if no today found
            
            
            ; PrintScreen()
            txt = [Error]Cannot find check out button as expected, continue....
            PrintScreen()
            Logger(txt)
            continue
        }
        
    }
    
    ; ToolTip, Found Today Keyword!, day1_x, day1_y
    
    day_offset_x:= 184
    slot_offset_y:= 41
    
    
    nextday_x:= day1_x
    nextday_y:= day1_y
    
    ; Click, %nextday_x%,%nextday_y%
    nextday_x:=nextday_x ; + day_offset_x + day_offset_x 
    
    
    Loop, 3
    {
        
        
        ; todo, continue is clicked, what to do?
        
        ;click the day tab
        ClickIntoPosition("Click Day Tab at Slot Page",nextday_x,nextday_y,1000)
        
        slotX:= day1_x - 67 ;75
        slotY:= day1_y + 87 ;669
        
        ;check message No doorstep delivery windows are available ....
        Text:="|<>*193$66.1zk0000000030Q000000004060000000080300000000E31U0000000k20U0680100U00U0780100U60k059sDCSUC0E04f8PHHU60E04v8FFHU60E04P8NHHUA0k049sDCSUD0U0000000kD0U0000000EA1U0000000803000000006060000000030Q000000001zk00000000U"
        
        if (ok:=FindText(809-150000, 781-150000, 809+150000, 781+150000, 0.2, 0.2, Text)){
            nextday_x:=nextday_x + day_offset_x
            continue
        }
        ;else
        
        ;NotifyMeAndExit() 
        

        
        Logger("Found Slot!")
        PrintScreen()
        
        
        loop, 7 { ;click into 7 slot
            ClickSlotAndContinue(slotX,slotY) 
            slotY:=slotY + slot_offset_y
            
            ;no payment at night!!!
            TryPaymentPage()
            
        }
        
        
        nextday_x:=nextday_x + day_offset_x
        
        ;dont delete!
        Text:="|<Place your order>*127$71.0000000000000000000000000000000000000000000000000000000000000000000000300000000000600000000000Bs117V2D0S7by836NW4M1aANsM29V48U64EVkE4H38F0AAV3zUBY6EW0EN6700+AAV40km4C20QMF281V48S80sNWAE1a8NrU0US3cU1sETU0100000000000600000000000s00000000000000000000000000000000000000000000000000000000000000000001"
        
    }
    
}
return
^c:: 
ExitApp ;control c to forcce exit

TrytoPlaceOrder(AutoPlaceOrder){
    
    ;text place your oder dont delete!!
    Text:="|<>*143$64.yE00000000250000000008IstkGQUsQvyEIcV/+22+G1DEy3ccc8d855D0AmaUWaUHnbUllu1mA000030000000000M00000U"
    if (ok:=FindText(518, 23, 923, 503, 0.1, 0.1, Text))
    {
        CoordMode, Mouse
        X:=ok.1.x, Y:=ok.1.y
        
        
        if(AutoPlaceOrder==1){
            ClickIntoPosition("Click PlaceOrder Button",X,Y,5000)
            MsgBox, "Order Made Sucessfully"
            ExitApp
        }
        else{
            NotifyMeAndExit()
        }
        
    }
    
}

ClickSlotAndContinue(slotx,sloty){
    
    ClickIntoPosition("Click Into Slot",slotx,sloty,200)
    
    
    ;click continue button at time slot page
    Text:="|<>*227$41.S00G001a00U0020xvfmPo3/OKowcKIoddztgddHHkSDHOayx"
    CLickIntoText("Click Continue Button",Text,2000)
    
}

TryPaymentPage(){
    ; payment page keywords!!
    Text:="|<>*164$69.1U30l00000M0A0M0M000030RbXwrUC7bnszxyTaw3tyyzDngH6n0lUrCNaBzMqM60SlXDljv6n0kAqAMSRUMqM6D6ln0zjnwnkTTq7tvgwTaC1lqkT7U" 
    if (ok:=FindText(173-150000, 213-150000, 173+150000, 213+150000, 0.2, 0.2, Text))
    {
        send, {WheelUp 6}
        sleep,500
        paymentContinueBtnX:= 800
        paymentContinueBtnY:= 214
        
        ClickIntoPosition("Click Confirm Payment Button",paymentContinueBtnX,paymentContinueBtnY,200)
        
        send, {WheelUp 6}
        sleep,500
        
        TrytoPlaceOrder(AutoPlaceOrder)
        
        NotifyMeAndExit()
        
    } 
    
    ; todo check keyword and popup message
    Text:="|<>*225$71.zzzzzzzzzzzy00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000D00900000000n00E000000010SxptBs000021Zh/OSE00004/+OIozk0000AqIodds00000D7dhHTS08"
    if (!ok:=FindText(809-150000, 781-150000, 809+150000, 781+150000, 0.2, 0.2, Text)){
        NotifyMeAndExit()
        ; todo, continue is clicked, what to do? 
        
    }
    
}

NotifyMeAndExit(){
    
    ;PrintScreen()
    ;NotifyAlexa()
    MsgBox, "Check screen, Found something!!!!"
    ExitApp
}

;to check if page loading is done
checkAmzonIconForLoading(timesChecking){
    
    ;sleep,100
    if(100==timesChecking){
        ;too long waiting, exit!
        
        ; PrintScreen()
        Logger("[Error] Failed to find Amazon Icon")
        PrintScreen()
        ;MsgBox, "Waiting for too long for the page to load, existing..."
        return false
    }
    Text:="|<>*137$29.zzzzzzzzzzzzzzzzzzzzzzzzzU07zy1k7zw7sDzsRkTzk3UzzUz1zz3a3zy7Q7zwDsDzsCkTzk00zzU01zz003zy007zw00Dzw00zzzzzzzzzzzzzzzzzzzzz"
    
    ;import: need to pricise to find amazon loading icon
    if (ok:=FindText(0, 0, 50, 50, 0.0, 0.0, Text))
    {
        return
    }

    ; ;check "We're sorry title"
    ; Text:="|<>*138$45.TzzzzzzfzzzzzzxTzzzzzzj6DVVk1ZtgwtaNAjM7bSrRhvDz/qvVzQzwArSQvUwACvnbzzzzzyTzzzzzzbzzzzzztzU"
    ; if (ok:=FindText(0, 0, 150, 150, 0.1, 0.1, Text)){
    ;     Text:="|<>*149$59.00000000000000000000000000000000000000000000000000000000000000000000007U00k00000M008000000UQyvSHS001155aaaY0022+/BBBs0044oKOOO0007j8aorrU00000000000000000000000000000000000000000000000000000000000000000000000000000008"
    ;     CLickIntoText("CLick into We are sorry page continue button",Text,200);
    ; }
    
    sleep,200
    timesChecking := timesChecking + 1
    checkAmzonIconForLoading(timesChecking)
    
    
}

;to check if page loading is done
checkIfBeingRedirecttoMystorePage(timesChecking){
    
    
    if(10==timesChecking){
        ;too long waiting, exit!
        
        ; PrintScreen()
        MsgBox, "Too many attempts to Slot Reserve Page, exit....."
        ExitApp
    }
    
    ;cart symbol
    Text:="|<>*128$26.zzzzzzzzz3zzzUTzbls80wS20D7s37ls0ly0EATU03Xzzzzzzzzzzzzzs"
    
    if (!ok:=FindText(0, 0, 927, 200, 0.1, 0.1, Text))
    {
        return 
    }
    else{
        
        ; PrintScreen()
        ;click cart icon
        X:=ok.1.x, Y:=ok.1.y,
        ;ClickIntoPosition(X,Y,2000)
        
        
        
        
        timesChecking := timesChecking + 1
        ;checkIfBeingRedirecttoMystorePage(timesChecking)
    }
    
}

ClickIntoPosition(actionDescription,x,y,sleepTime){
    Click, %X%, %Y% 
    sleep, sleepTime
    Logger(actionDescription)
    checkAmzonIconForLoading(1)
    
}

Cart_Page(timesChecking){
    
    
    if(3==timesChecking){
        msg = Cannot find Check Out button as expected on Cart Page, exit....
        Logger(msg)
        return false
    }
    ;cart page
    Text:="|<>*142$71.0000000000000000000000000000000000000000000000000000000000000000000000000000000000007800U0008000EE010010M0010wwuHYL1Fz0219+58cY2mG042HoAFF8DYY044Y8IWWEF980D9DCYtwkXGE00000000000000000000000000000000000000000000000000000000000000000000000000000000004"
    
    if (ok:=FindText(0,0 ,950,1024, 0.1, 0.1, Text))
    {
        CoordMode, Mouse
        X:=ok.1.x, Y:=ok.1.y
        ClickIntoPosition("Click Check Out",X,Y,5000)
        
        
    }
    else
    {
        timesChecking = timesChecking + 1
    }
    
}

Before_you_checkout(timesChecking){
    
    if(3==timesChecking){
        
        ; PrintScreen()
        msg = Cannot find continue button on Before you check out page , exit....
        Logger(msg)
        MsgBox, %msg%
        ExitApp
        
    }
    
    ; PrintScreen()
    ;before check out page
    Text:="|<>*151$42.S001000E00E000kSSxTNDUGGFNNNknGFNNTEGGFNNMSSGRNDDU"
    
    if (ok:=FindText(0,0,1800,1800, 0.2, 0.2, Text))
    {
        CoordMode, Mouse
        X:=ok.1.x, Y:=ok.1.y, Comment:=ok.1.id
        ClickIntoPosition("Click Continue at Before you Check Out Page",X,Y,5000)
    }
    else{
        
        
        timesChecking = timesChecking + 1
    }
    ; PrintScreen()
}

TrySlotandContinue_bckp(slottext){
    
    CLickIntoText("Click into Slot",slottext,1000)
    
    Text:="|<>*217$57.DU000k00036000U0000kM0040000407btyTaAwU36tYnAlgI0MqAaMaB3U32lYm4ljw1MKAaEaD0kP6lYm4lc36MqAaEaRXDUwlbm4Tbo"
    
    if (ok:=FindText(809-150000, 781-150000, 809+150000, 781+150000, 0.2, 0.2, Text)){
        CLickIntoText("Click into Slot",Text,1000)
    }
    
    else{
        MsgBox, "Check Slot, Continue Button is not clickable!"
        ; ExitApp
    }
    
}

httpQuery()
{
    
    url :="https://api.notifymyecho.com/v1/NotifyMe?notification=Hello%20Yuan%20Go%20Cosco%20Shopping%20Now!&accessCode=amzn1.ask.account.AEX6TSFQ64XPEFMT4IKCLT6QDMVVUBR6U533SAV2JCNV2VDIGE42344ZCWLW2WYB2XAC5DSDCT52S4EFO7Q6KLYXPUBCFVLE2T3BIWCZYVEFRJCBHNDFO6BGASOQZK3KAWREKWIRDZFOHOTOSZP5UHGJRHGENRDBVWPCMZERG2H3I6TE6V5CF4P4YFJRHGKGN67L4JHEDTTIQEI"
    WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1") 
    WebRequest.Open("GET", url)
    ; WebRequest.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
    WebRequest.Send(POSTDATA)
    ; Result := WebRequest.ResponseText
    ; WebRequest := ""
}

CLickIntoText(actionDescription,text,sleeptimeafterclick){
    
    if (ok:=FindText(0,0 ,950,1024, 0.2, 0.2, Text))
    {
        X:=ok.1.x, Y:=ok.1.y
        ClickIntoPosition(actionDescription,X,Y,sleeptimeafterclick)
    }
    
}

;************** click continue button *************
ClickContinue(){
    t1:=A_TickCount, X:=Y:=""
    
    Text:="|<>*217$71.00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000w000M0000003A004k000000AA0080000000M1twvTAlk000U6PAanNaE0010AqNBan8k0030NgmPBazU0066nNYqPAU00069an9gqNa0007VtaTNbls00000000000000000000000000000000000000000000000000000000000001"
    
    if (ok:=FindText(1705-150000, 315-150000, 1705+150000, 315+150000, 0.2, 0.2, Text))
    {
        CoordMode, Mouse
        X:=ok.1.x, Y:=ok.1.y, Comment:=ok.1.id
        Click, %X%, %Y%
    }
}

;***********Check to see if payment information is returned*******************
HasPayment(){
    return false
}