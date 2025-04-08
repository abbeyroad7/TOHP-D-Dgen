;v1.0.0
;Todo:
;Alt mode on encounter style, 1 boss, 3 mini boss, goons, etc

Import:
{
#Requires AutoHotkey v1.1+
#NoEnv
#SingleInstance Force
#Persistent
DetectHiddenWindows, On
SetTitleMatchMode, RegEx

IconChange:
	{
		I_Icon = C:\Program Files\AutoHotkey\Icons\Names.ico
		ICON [I_Icon]                        ;Changes a compiled script's icon (.exe)
		if I_Icon <>
		IfExist, %I_Icon%
			Menu, Tray, Icon, %I_Icon%   ;Changes menu tray icon 
	}
	
	ImgDir = K:\Documents\Foundry\Data\moulinette\tiles\custom\TOHP\Tokens\Homebrew\Scenes
	SceneDir = .Scenes
}

Variables:
{
	PartyLevel = 5
	PartyHealth:
	{
		P1_HP = 49	;Borislav
		P2_HP = 30	;Freya
		P3_HP = 22	;Goobert
		P4_HP = 31	;Renroc
		P5_HP = 26	;Scribbles
		P6_HP = 39	;Yeldarb
		PartyHealth := P1_HP + P2_HP + P3_HP + P4_HP + P5_HP + P6_HP
		;Msgbox % PartyHealth
	}
}

Prompt:
{	
	;Inputbox, EnemyCount, Enemy Count,,,200,100
	
	GUIInput:
	GUI, 1:New
	Gui, 1:add, Text,, Trivial=1 // Easy=2 // Medium=3 // Hard=4 // VeryHard=5 // God=6
	Gui, 1:Add, Edit, vCR
	Gui, 1:add, Text,, Enemy Count:
	Gui, 1:Add, Edit, vEnemyCount
	Gui, 1:Add, Button, Hidden w0 h0 Default, Save
	Gui, 1:Show
	return
	
	GUIBody:
	GUI, 2:New
	GUI, 2:Color, 050505	;GUI bg color
	Gui, 2:Font, s14 cWhite, Centaur
	GUI, 2:add, text, x10 w600, CR : %CR%
	GUI, 2:add, text, x10 w600, EnemyCount : %EnemyCount%
	Stats = %HP% HP Str %Str% Dex %Dex% Wis %Wis% Cha %Cha% Int %Int%
	GUI, 2:add, text, x10 w600, %Stats%
	;Clipboard = %Stats%
	
	Gui, 2:Show, x800 y250
	
	#IfWinActive, Statblock.ahk
	Enter::
	{
		Goto, ButtonSave
	return
	}
	#IfWinActive
	
	ButtonSave:
	GuiControlGet, CR
	GuiControlGet, EnemyCount
	GuiControlGet, weight
	Random, rndStat, -5, 5
	Random, rndStat1, -5, 5
	Random, rndStat2, -5, 5
	Random, rndStat3, -5, 5
	Random, rndStat4, -5, 5
	Random, rndStat5, -5, 5
	CreatureStats:
	{
		HP := Ceil((0.05 * CR * PartyLevel * PartyHealth - (rndStat * CR)) / EnemyCount)
		Str := Ceil(((CR*2.25) + 8) * 1.15 + (rndStat1 * 1.2))
		Dex := Ceil(((CR*2.25) + 8) * 1.15 + (rndStat2 * 1.2))
		Wis := Ceil(((CR*2.25) + 8) * 1.15 + (rndStat3 * 1.2))
		Cha := Ceil(((CR*2.25) + 8) * 1.15 + (rndStat4 * 1.2))
		Int := Ceil(((CR*2.25) + 8) * 1.15 + (rndStat5 * 1.2))
	}
	
	;Msgbox %CR%
	Gui, Submit
	Gui, Destroy
	Goto, GUIBody
Return
}

EndofFile:
{
Escape::
{
	Reload
}
+Escape::ExitApp
}
return