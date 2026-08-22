Import:
{
#Requires AutoHotkey v1.1+
#NoEnv
#SingleInstance Force
#Persistent
DetectHiddenWindows, On
SetTitleMatchMode, RegEx
}

RowCount:=16
ColumnCount:=16

Pathways()


Pathways()
{
    global
    Loop, %ColumnCount%
    {
        Loop, %RowCount%
        {
            Random, PosType, 1, 4
            Count++
            If (PosType <= 2)
                X_%Count%:="-"
            If (PosType="3")
                X_%Count%:="|"
            If (PosType="4")       ; RoomGen
            {
                X_Array .= "["
                Loop
                {
                    Random, RoomCoord, 1, 5

                    If (RoomCoord <= 4)
                    {
                        X_Array .= " "
                        Count++
                    }
                    If (RoomCoord = 5)
                    {
                        X_Array .= "]"
                        Count++
                        break
                    }
                }
            }
            X_Array .= X_%Count%
            If (Count > 16)
                break
            ;Msgbox % X_%A_Index%
        }
    }
}

Msgbox % X_Array