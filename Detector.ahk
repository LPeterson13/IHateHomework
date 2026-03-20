#Requires AutoHotkey v2.0               ;Version of Autohotkey
#Include Findtext.ahk                   ;Added Library for image searching
Esc::ExitApp                            ;Esc for exit of program
^+!s::                                  ;Ctrl+shift+alt+s to start the program
{
    CoordMode "Pixel"                   ;Interprets the coordinates below as relative to the screen rather than the active window's client area.
    SetKeyDelay 100, 50                 ;Delay to allow website to load proper
    SendMode "Event"                    ;Changes send mode to listen to set key delay
    Initializer()                       ;Main funtion 
    return
}
return


Initializer()           ;Runs all other funtions to make it nice and neat 
{
    reloads := 1                        ;Number of times sites reloaded          
    Ans := []                           ;Array of answers to the quiz

    NumQues := InputBox("Enter Number of Questions in quiz", "NumQues").value ;Use input for Total num of Questions on Quiz
    loop NumQues{                       ;Building array by making every ans D for the num of ques        
        Ans.push(4)             
    }
      
    while reloads <= 3{                 ;Question Loop
        {
            RefreshLoop()

            QuestionLoop(NumQues, Ans, reloads)
            
        }
        reloads += 1                    ;Add one to realods for question purposes and loop
    }
    RefreshLoop()
    AnweringLoop(NumQues, Ans)
}


RefreshLoop()           ;Loop Refreshes the main page
{
    Nobutton := 0           ;If resume button got found            
    startbutton := 0        ;If start putton was found
    send "{Browser_Refresh}"        ;self-explanitiory

        while Nobutton != 1{    ;Check for the Box saying resume after refresh
            if ImageSearch(&FoundX, &FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, "C:\Users\t-lpeterson\OneDrive - Microsoft\Documents\AutoHotkey\No.png")          ;Diffrent types of boxes that can appear on refresh
            || ImageSearch(&FoundX, &FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, "C:\Users\t-lpeterson\OneDrive - Microsoft\Documents\AutoHotkey\Restart.png")     ; ---/\
            {
                Nobutton := 1       ;When found set no to 1 and break searchloop
            }
        }
    Click FoundX, FoundY            ;Click the "No" Button

    while startbutton != 1{         ;Check for start Button
            if ImageSearch(&FoundX, &FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, "C:\Users\t-lpeterson\OneDrive - Microsoft\Documents\AutoHotkey\Start.png")       ;Diffrent types of boxes that can appear on refresh
            || ImageSearch(&FoundX, &FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, "C:\Users\t-lpeterson\OneDrive - Microsoft\Documents\AutoHotkey\Start2.png")      ; ---/\
            {
                startbutton := 1    ;When found set start to 1 and break searchloop
            }
        }
    Click FoundX, FoundY            ;Select start
    sleep 1000                        ;Let the program catch up
    ;send "{Click 1107 608}"        ;Select the top of the quiz to stablize the cursor(Broken after Q1) [DO NOT UNCOMMENT]
}

QuestionLoop(NumQues, Ans, reloads)         ;This loop goes through each question in the quiz sellecting the ans related to reload and checks it
{            
    itteration := 1                 ;Current question of the quiz
    while itteration <= NumQues{        ;while the question you are on is below or = to the total questions run loop
        
        ;Says Select
        Text:="|<>*138$71.0000000000000000300000007U00C0000000zs00Q0000003vk00s00006060001k0000A0Q0003U0000M0s01y70T0DVz0k07yC1zVzjy1s0QCQ633U301y0kAsQ7C0600z3UNkkCM0A00T71nVkQk0M00DDzb3ztU0k00CQ0C60301U00Qs0QA0603000tk0sQ0C06003Vk1kM0Q0A0Dz1zlszsTsTUTs1z3kzkTkT000000000000000000000000000000000000000000000000000000000001"
        if (ok:=FindText(&X, &Y, 0, 0, A_ScreenWidth, A_ScreenHeight, 0, 0, Text))
        {       ;If Select found Enter Multichoice Function
            ;Multichoice()
        }
        else
        {
            send "{Tab}"        ;Moves to Keyboard Navagation
            send "{Tab}"        ;Move to Questions
            switch reloads                  ;Checks which itteration were on to determine how many times down is pressed
            {
                case 2:             ;Selects B on relaod 2
                    send "{Down}"
                case 3:             ;Selects C on reload 3
                    send "{Down}"
                    send "{Down}"
                default:            ;Selects A on reload 1
            }
            send "{Space}"  ;Clicks ANS
            send "{Tab}"    ;Move to Continue/Checkmark
            send "{Space}"  ;Clicks continue
            
            sleep 100       ;Let box appear on screen
            if ImageSearch(&Zes, &Ces, 0, 0, A_ScreenWidth, A_ScreenHeight, "C:\Users\t-lpeterson\OneDrive - Microsoft\Documents\AutoHotkey\Correct.png"){
                ;Checking if question is right (only thing we care about)
                Ans.RemoveAt(itteration)    ;Removes Filler letter and replaces with real letter
                Ans.InsertAt(itteration, reloads)
            }
            else
            {
            }
            send "{Tab}"        ;Moves to Continue on popup explination screen
            send "{Space}"      ;Click continue 
        }
        itteration += 1
    }
}

Multichoice()           ;Under Construction
{
                    ;I have no clue what to do about this multiple choice problem 
                    ;I could have it try every option but that would take forever
                    ;It also doesnt actually detect every multiple choice box meaning its near impossible to properly deal with it
                    ;Solutions 
                        ;1. Have a human input the correct ans
                        ;2. Build an AI to figure out the correct Ans then have the program take the ans and input it

                    ;Short term 
                        ;Select 1 box (any box) then procide
                        
    ;Multi Choice Box
    Text:="|<>*224$35.000000Dzzzy0zzzzz3k000S70000CCzzzzQNzzzysnzzzxlbzzzvX0000760000CA0000QM0000sk0001lU0003X0000760000CA0000QM0000sk0001lU0003X0000760000CA0000QM0000sk0001lU0003X0000770000CD0000wDzzzzkDzzzzU3zzzk000000000000E"
    while (ok:=FindText(&X, &Y, 0, 0, A_ScreenWidth, A_ScreenHeight, 0, 0, Text)){      ;Grab all the multibox cords
    MultiBoxH := []                           ;Array for the Y value of the Multi Boxes          
    MultiBoxH.push(Y)
    }
    MultiBoxH.Sort()
    MsgBox(MultiBoxH)
                                ;Boxes need to be sorted to get the correct positions 


}


AnweringLoop(NumQues, Ans)      ;Final loop that answers the questions
{

    itteration := 1             ;Current question of the quiz
    while itteration <= NumQues{            ;while the question you are on is below or = to the total questions run loop
        send "{Tab}"        ;Moves to Keyboard Navagation
        send "{Tab}"        ;Move to Questions
        switch Ans.Get(itteration)                  ;Checks which itteration were on to determine letter
            {
            case 2:                 ;Selects B if Ans array at itteration is 2
                send "{Down}"       
            case 3:                 ;Selects C if Ans array at itteration is 3
                send "{Down}"
                send "{Down}"
            case 4:                 ;Selects D if Ans array at itteration is 4
                send "{Down}"
                send "{Down}"
                send "{Down}"
            default:                ;Selects A if Ans array at itteration is 1
            }
        send "{Space}"      ;Clicks ANS
        send "{Tab}"        ;Move to Continue/Checkmark
        send "{Space}"      ;Clicks continue
        send "{Tab}"        ;Moves to Continue on popup explination screen
        send "{Space}"      ;Click continue 

        sleep 100
        itteration += 1
    }

}


;Would you like to resume (1240, 1063), Knowledge Start (1658, 1270) , Continue aft ques (1154 961) , Top of Quiz (1107 608)
;{Tab} , {Down} , {Browser_Refresh} , {Click [Options]}
;MouseGetPos &Posx, &Posy
;MsgBox Posx " " Posy