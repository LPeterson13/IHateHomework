#Requires AutoHotkey v2.0
#Include Findtext.ahk
Esc::ExitApp
^+!s::
{
    CoordMode "Pixel"                   ;Interprets the coordinates below as relative to the screen rather than the active window's client area.
    SetKeyDelay 100, 50                 ;Delay to allow website to load proper
    SendMode "Event"
    reloads := 1                        ;Number of times sites reloaded
    NumQues := 20       ;Total num of Questions on Quiz          
    Ans := []                           ;Array of answers to the quiz

    loop NumQues{                       ;Building array from            
        Ans.push(4)           
    }
            
    while reloads <= 3{     
        {
            RefreshLoop()

            QuestionLoop(NumQues, Ans, reloads)
            
        }
        reloads += 1
    }
    RefreshLoop()
    AnweringLoop(NumQues, Ans)
}
return

RefreshLoop()
{
    Nobutton := 0   ;If resume button got found            
    startbutton := 0    ;If start putton was found
    send "{Browser_Refresh}"    
        while Nobutton != 1{    ;Check for the Box saying resume after refresh
            if ImageSearch(&FoundX, &FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, "C:\Users\t-lpeterson\OneDrive - Microsoft\Documents\AutoHotkey\No.png") 
            || ImageSearch(&FoundX, &FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, "C:\Users\t-lpeterson\OneDrive - Microsoft\Documents\AutoHotkey\Restart.png")
            {
                Nobutton := 1
            }
        }

    Click FoundX, FoundY            ;Select the "No" Button
    while startbutton != 1{         ;Check for start Button
            if ImageSearch(&FoundX, &FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, "C:\Users\t-lpeterson\OneDrive - Microsoft\Documents\AutoHotkey\Start.png")
            || ImageSearch(&FoundX, &FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, "C:\Users\t-lpeterson\OneDrive - Microsoft\Documents\AutoHotkey\Start2.png")
            {
                startbutton := 1
            }
        }
    Click FoundX, FoundY            ;Select start
    sleep 50
    ;send "{Click 1107 608}"        ;Select the top of the quiz to stablize the cursor(Broken after Q1)
}

QuestionLoop(NumQues, Ans, reloads)
{            
    itteration := 1     ;Itteration of quiz (Should be related to questions)
    while itteration <= NumQues{        ;while the question you are on is below or = to the total questions run loop
        
        ;Says Select
        Text:="|<>*138$71.0000000000000000300000007U00C0000000zs00Q0000003vk00s00006060001k0000A0Q0003U0000M0s01y70T0DVz0k07yC1zVzjy1s0QCQ633U301y0kAsQ7C0600z3UNkkCM0A00T71nVkQk0M00DDzb3ztU0k00CQ0C60301U00Qs0QA0603000tk0sQ0C06003Vk1kM0Q0A0Dz1zlszsTsTUTs1z3kzkTkT000000000000000000000000000000000000000000000000000000000001"
        if (ok:=FindText(&X, &Y, 0, 0, A_ScreenWidth, A_ScreenHeight, 0, 0, Text))
        {       ;If Select found Enter loop
            ;Multi Choice Box
            Text:="|<>*224$35.000000Dzzzy0zzzzz3k000S70000CCzzzzQNzzzysnzzzxlbzzzvX0000760000CA0000QM0000sk0001lU0003X0000760000CA0000QM0000sk0001lU0003X0000760000CA0000QM0000sk0001lU0003X0000770000CD0000wDzzzzkDzzzzU3zzzk000000000000E"
            while (ok:=FindText(&X, &Y, 0, 0, A_ScreenWidth, A_ScreenHeight, 0, 0, Text))
            {
            MultiBox := []                           ;Array for the Y value of the Multi Boxes          
            MultiBox.push(Y)           

            }
        }
        send "{Tab}"        ;Clicks the submit button
        send "{Space}"
        send "{Tab}"        ;Clicks the continue button
        send "{Space}"
        }
        else{
            send "{Tab}"                    ;Question answering mechanism
            send "{Tab}"
            switch reloads                  ;Checks which itteration were on to determine letter
            {
                case 2:
                    send "{Down}"
                case 3:
                    send "{Down}"
                    send "{Down}"
                default:
            }
            send "{Space}"  ;Clicks ANS
            send "{Tab}"    ;Clicks continue
            send "{Space}"
            
            sleep 100       ;Let box appear on screen
            if ImageSearch(&Zes, &Ces, 0, 0, A_ScreenWidth, A_ScreenHeight, "C:\Users\t-lpeterson\OneDrive - Microsoft\Documents\AutoHotkey\Correct.png"){
                ;Checking if question is right (only thing we care about)
                Ans.RemoveAt(itteration)    ;Removes Filler letter and replaces with real letter
                Ans.InsertAt(itteration, reloads)
            }
            else
            {
            }
            send "{Tab}"
            send "{Space}"
        }
        itteration += 1
    }
AnweringLoop(NumQues, Ans)
{

    itteration := 1     ;Itteration of quiz (Should be related to questions)
    while itteration <= NumQues{        ;while the question you are on is below or = to the total questions run loop
        
        send "{Tab}"                    ;Question answering mechanism
        send "{Tab}"
        switch Ans.Get(itteration)                  ;Checks which itteration were on to determine letter
            {
            case 2:
                send "{Down}"
            case 3:
                send "{Down}"
                send "{Down}"
            case 4:
                send "{Down}"
                send "{Down}"
                send "{Down}"
            default:
            }
        send "{Space}"
        send "{Tab}"
        send "{Space}"
        send "{Tab}"
        send "{Space}"

        sleep 100
        itteration += 1
    }

}


;Would you like to resume (1240, 1063), Knowledge Start (1658, 1270) , Continue aft ques (1154 961) , Top of Quiz (1107 608)
;{Tab} , {Down} , {Browser_Refresh} , {Click [Options]}
;MouseGetPos &Posx, &Posy
;MsgBox Posx " " Posy