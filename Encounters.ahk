;v1.0.0
;Todo:
;Homebrew encounters
;Character encounters
;Story arcs

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

Prompt:
{
	GUI, Color, 050505	;GUI bg color
		Gui, Font, s14 cWhite, Centaur
		GUI, add, text, w300 y10, 0=.Scenes`n1=Buildings`n2=Castles`n3=Caverns`n4=City Interiors`n5=Cityscapes`n6=Coast`n7=Deserts`n8=Dungeons`n9=Forest`n10=Interiors`n11=Jungle`n12=Mountains`n13=Plains`n14=Ruins`n15=Shopkeeper`n16=Sky`n17=Space`n18=Swamp`n19=Townscapes`n20=Tropical`n21=Tundra`n22=Underdark`n23=Underwater`n24=Valley`n25=Waterfall
	Gui, Show, x800 y250
	
	Inputbox, SceneDir,,,,200,100
}

IfStatements:
{
	if SceneDir = 0
		SceneDir = .Scenes
	if SceneDir = 1
		SceneDir = Buildings
	if SceneDir = 2
		SceneDir = Castles
	if SceneDir = 3
		SceneDir = Caverns
	if SceneDir = 4
		SceneDir = City Interiors
	if SceneDir = 5
		SceneDir = Cityscapes
	if SceneDir = 6
		SceneDir = Coast
	if SceneDir = 7
		SceneDir = Deserts
	if SceneDir = 8
		SceneDir = Dungeons
	if SceneDir = 9
		SceneDir = Forest
	if SceneDir = 10
		SceneDir = Interiors
	if SceneDir = 11
		SceneDir = Jungle
	if SceneDir = 12
		SceneDir = Mountains
	if SceneDir = 13
		SceneDir = Plains
	if SceneDir = 14
		SceneDir = Ruins
	if SceneDir = 15
		SceneDir = Shopkeeper
	if SceneDir = 16
		SceneDir = Sky
	if SceneDir = 17
		SceneDir = Space
	if SceneDir = 18
		SceneDir = Swamp
	if SceneDir = 19
		SceneDir = Townscapes
	if SceneDir = 20
		SceneDir = Tropical
	if SceneDir = 21
		SceneDir = Tundra
	if SceneDir = 22
		SceneDir = Underdark
	if SceneDir = 23
		SceneDir = Underwater
	if SceneDir = 24
		SceneDir = Valley
	if SceneDir = 25
		SceneDir = Waterfall
		
	GUI, Destroy
}

Image:
{
;Gui, Destroy
array := []  ; initialise array
loop, files, %ImgDir%\%SceneDir%\*.*  ; match any file
    array.push(a_loopFileFullPath)  ; append file to the end of the array

total_file_count := array.maxIndex()
random, random_number, 1, % total_file_count
random_file := array[random_number]
Clipboard = %random_file%
;MsgBox, % random_file
}

ImageGUI:
{
	If InStr(random_file, "webp")
	{
		filePath = %random_file%
		hBitmap := HBitmapFromWebP(filePath, width, height)
		random_file = HBITMAP:%hBitmap%
		#Include, D:\Documents\Notes\DND\DND\DM\Scripts\Libraries\DecodeWebP.ahk
	}
	
	Gui, MainWindow:New
	Gui, Margin, 0, 0
	Gui , Add, Picture, h600 w-1, %random_file%

	Gui, Color, %color%
	Gui, +LastFound -Caption +ToolWindow -Border +Resize
	;Winset, TransColor, %color%
	Gui, Show, x250 y150
	GUI, New
	Gui, +LastFound -Caption +ToolWindow -Border +Resize
}

GUIBody:
{
	
	GUI, Color, 050505	;GUI bg color
	Gui, Font, s14 cWhite, Centaur
	GUI, add, text, x10 w600, 
	
	Gui, Show, x800 y250
	
	NPC_Body = %FullGender% %Race% | %NPC_Role% | %NPC_Family% | Worships %NPC_Gods%`n~Currently thinking about %NOUN%`n~%NPC_Goal%
}

Encounters()
{
	global
	Gui, Encounters:New	
	Gui, Encounters:Color, 050505
	Gui +LastFound
	Gui, Encounters:-Caption
	
	BGImg := GUI_Backgrounds(BGImg)
	GUI_CheckAvatarImg()

	Gui, Encounters:Add, Picture, x0 y0 w500 h300 , %BGImg%
	Gui, Encounters:Add, Picture, y10 x10 w480 h280 BackgroundTrans, %MaskShape%
	
	Gui, Encounters:Add, Picture, y24 x20 h56 w56 BackgroundTrans, %Icon%
	Gui, Encounters:Font, s16
	Gui, Encounters:Add, Text, cWhite BackgroundTrans w325 x86 y28 r1, %CategoryTitle%
	Gui, Encounters:Add, Text, cWhite BackgroundTrans w325 x86 y58 r2 %Align%, %Line2%
	Gui, Encounters:Add, Picture, x30 y92 w430 h6 , %Bin%\Divider.png
	;Gui, Encounters:Add, Text, cGray BackgroundTrans w500 x20 y80 r3, -----------------------------------------------------------------
	Gui, Encounters:Font, s12
	IniRead, RunCount, %MusicIni%, Count, RunCount
	Gui, Encounters:Add, Text, cGray w100 x370 y30 BackgroundTrans right, #%RunCount%
	Gui, Encounters:Add, Text, cGray w100 x370 y50 BackgroundTrans right, v%Version%
	Gui, Encounters:Add, Text, cGray w100 x370 y70 BackgroundTrans right, %Cho%

	Gui, Encounters:Add, Text, cGray BackgroundTrans r2 x30 y110, Reroll: 0
	Gui, Encounters:Add, Text, cGray BackgroundTrans r2 x30 y130, CYO: 1
	Gui, Encounters:Add, Text, cGray BackgroundTrans r2 x30 y150, Debug: 2
	Gui, Encounters:Add, Text, cGray BackgroundTrans r2 x30 y170, Reload: 3
	
	If (Debug = 0)
		Gui, Encounters:Add, Picture, y40 x535 h24 w48, %A_ScriptDir%\Libraries\Icons\DebugOff.png
	If (Debug = 1)
		Gui, Encounters:Add, Picture, y40 x530 h24 w48, %A_ScriptDir%\Libraries\Icons\DebugOn.png
		
	Gui, Encounters:Add, Edit, vLauncher x30 w130 y200
	Gui, Encounters:Add, Button, default gButtonOK x30 y240, OK

	Gui, Encounters:Show, w500 h300 x1150, Encounters	
	;Winset, Alwaysontop, On, Encounters
	return
	
	GuiClose:
		return
	ButtonOK:
	{
		Gui, Encounters:Submit
		WinClose, Encounters

		If (Launcher = "")
		{
			;MainRun()
		}
		If (Launcher = "r")		;Debug
		{
			Reload
		}
		If (Launcher = "0")		;Reroll
		{
			Reroll := RegexReplace(CategoryTitle, "`n.+")
			%Reroll%()
			Gui, Encounters:Destroy
			;Msgbox %CategoryTitle%
			Encounters()
		}
		If (Launcher = "2")		;Debug
		{
			Debug = 1
			;MainRun()
		}
		If (Launcher = "3")		;Debug
		{
			Reload
		}
	return
	}
}

GUI_Backgrounds(BGImg)
{
	global
	count := 0
	Loop, %Bin%\Backgrounds\*.jpg
	{
		if A_LoopFileAttrib contains H,R,S
			continue
		count += 1
	}
	Random, FileNumber, 1, %count%

	Loop, Files, %Bin%\Backgrounds\*.jpg, F
	{
		;Msgbox %A_Index% %Count%
		if (A_Index > FileNumber)
		{
			BGImg = %Bin%\Backgrounds\%A_LoopFileName%
			break
		}
		;count += 1
	}
	return %BGimg%
}

GUI_CheckAvatarImg()
{
	global
	If (InStr(CategoryTitle, "YouTube"))		;Channel Art
		ArtistImg = %Bin%\YouTube
	Else
	{
		ArtistImg = G:\Pictures\Art
		Artist := LineOutput
	}
	If (InStr(CategoryTitle, "List")) || If (InStr(CategoryTitle, "Genre"))
		ArtistImg = %Bin%\List
	;Msgbox %Artist%
	
	;Msgbox %LineOutput%
	Loop, Files, %ArtistImg%\*, F
	{
		ImgFile := StrReplace(A_LoopFileName, "." 	A_LoopFileExt)
		;Msgbox %ImgFile% %LineOutput%

		if (InStr(Artist, ImgFile))
		{
			If (InStr(CategoryTitle, "YouTube"))
			{
				BGImg = %ArtistImg%\%ImgFile%-banner.jpg
				FileToFind = %Artist%.jpg
			}
			Else
				FileToFind = %A_LoopFileName%

			Avatar = %ArtistImg%\%FileToFind%
			;Msgbox %ImgFile% in %Artist%
			;Msgbox %Avatar%
			break
		}
	}
return
}

;### Hotkeys
; ================================
Hotkeys:
{
	Escape::
	{
		Reload
	}
	+Escape::ExitApp
}
return