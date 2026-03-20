#Requires AutoHotkey v2.0               ;Version of Autohotkey
#Include Findtext.ahk                   ;Added Library for image searching
Esc::ExitApp                            ;Esc for exit of program
^+!s::                                  ;Ctrl+shift+alt+s to start the program
{
    CoordMode "Pixel"                   ;Interprets the coordinates below as relative to the screen rather than the active window's client area.
    SetKeyDelay 150, 50                 ;Delay to allow website to load proper
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
    sleep 500                        ;Let the program catch up
}

QuestionLoop(NumQues, Ans, reloads)         ;This loop goes through each question in the quiz sellecting the ans related to reload and checks it
{            
    itteration := 1                 ;Current question of the quiz
    while itteration <= NumQues{        ;while the question you are on is below or = to the total questions run loop
        
        ;Says Select
        select := MultichoiceDetector()         ;If Select found Enter Multichoice Function
        if (select == 1){
            MultichoiceBypass()
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
            send "{Space}"  ;Clicks continue/Checkmark
            
            sleep 300       ;Let box appear on screen
                            ;Text says Correct
            Text:="|<>**20$69.0000000000000000000000000000000000000000000000DzU000000003kQ00000001sstU0000000T6TxzbzzzyDzTr7QCqRXlvkkRk7CyjfxnQzTg0rvnwzTTTvxU6nStiPxv3Mg0aNqBXTiMP5U4lilgM1m3Mi0aNqBXTyMP6s6nSlgP0P3MnzrvqBXTvTvz7jSylgQxRzjS3wCqBVkPkyNztzblw7zDzz00000000000000000000000000000000004"
            if (ok:=FindText(&X, &Y, 0, 0, A_ScreenWidth, A_ScreenHeight, 0, 0, Text))    ;Checking if question is right (only thing we care about)
            {
                Ans.RemoveAt(itteration)    ;Removes Filler letter and replaces with real letter
                Ans.InsertAt(itteration, reloads)
            }
            send "{Tab}"        ;Moves to Continue on popup explination screen
            send "{Space}"      ;Click continue 
        }
        itteration += 1
    }
}

MultichoiceDetector()
{
    sleep 400
    Text1:="|<>**20$75.00000000000000000000000000000000000001s0000S000000C1y003k000003kzw00S000010QDzU03k0000Q7Vk000S00003UsS0003k0000Q73k07wS1z0zjysD01znkTwTzzr1w0SDS7bXtjws7w3UvlsQw0Q70Tsw7SC3r03Us0Tbzvlzys0Q700yzzSDzb03Us03rznlzws0Q700Sw0SC0703Us03rU3ls0w0Q71UwS0S70bk3UwDzVztwzwTwTrVzs7zDXzVzVyQ3s0D003k1U23k00000000000C000000000001s0000000000000000000000000000000000000000000000004"
    Text:="|<>**20$75.00000000000000000000000000000000000000Q000070000007UzU00s000000sTy00700000kD3zk00s000071kw000700001sS70000s0000D3ks01y70zUTrzS7U0zssDy7yzvUT077b3ltwnyQ3z1sQsQ7C0D3U7wC3b3Uvk1sQ0DlzwszzS0D3U0DDzb7zvk1sQ00tzsszyS0D3U07C077U3k1sS00tk0sQ0C0D3kkDD0b3k1s1sC7zkzwyDz7z7tkzw3zXkzsTkzD0y07U01s0s0Us000000000007U00000000000Q0000000000000000000000000000000000000000000000004"
    if (ok:=FindText(&X, &Y, 0, 0, A_ScreenWidth, A_ScreenHeight, 0, 0, Text)) || (ok:=FindText(&X, &Y, 0, 0, A_ScreenWidth, A_ScreenHeight, 0, 0, Text1))
    {
        return 1
    }   
}

MultichoiceBypass()
{
    ;Checks for the horizontal line
    Text:="|<>**50$99.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007zzzzzzzzzzzzzzzszzzzzzzzzzzzzzzz7zzzzzzzzzzzzzzzszzzzzzzzzzzzzzzz7U000000000000000w0000000000000007U000000000000000w0000000000000007U000000000000004"
    send "{tab}"        ;Move past the Navagate Button
    send "{tab}"        ;Move past the first ans
    send "{tab}"        ;Move past the second ans
    while (ok:=FindText(&X, &Y, 0, 0, A_ScreenWidth, A_ScreenHeight, 0, 0, Text)){
        send "{tab}"    ;Moving down through the questions
    }
    send "{shift down}{tab}{shift up}"  ;Goes back to the last ans
    send "{Space}"      ;Clicks las anser
    send "{tab}"        ;Moves to continue/checkmark
    send "{Space}"      ;Clicks continue/Checkmark
    sleep 200
    send "{tab}"        ;Moves to Continue on popup explination screen
    send "{Space}"      ;Click continue 

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

        select := MultichoiceDetector()         ;If Select found Enter Multichoice Function
        if (select == 1){
            MultichoiceBypass()
        }
        else{
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
        }

        sleep 50
        itteration += 1
    }

}


;Would you like to resume (1240, 1063), Knowledge Start (1658, 1270) , Continue aft ques (1154 961) , Top of Quiz (1107 608)
;{Tab} , {Down} , {Browser_Refresh} , {Click [Options]}
;MouseGetPos &Posx, &Posy
;MsgBox Posx " " Posy