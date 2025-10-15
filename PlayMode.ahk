Import:
{
#Requires AutoHotkey v1.1+
#NoEnv
#SingleInstance Force
#Persistent
SetTitleMatchMode, RegEx
}

Loop	;Screenshot every 10 mins
{
	;Msgbox start loop
	If WinActive("Foundry Virtual Tabletop")
	{
		Send #{PrintScreen}
		;Msgbox Sleeping for 10m
		Sleep 600000
	}
	#IfWinActive
	Sleep 15000
}