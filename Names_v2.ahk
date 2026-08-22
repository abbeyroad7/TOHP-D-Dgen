Version = 4.3.0
;Todo:
{
	;Support me/credits
	;Output folder
	;Loot generator
	;Change family dynamics per race, var set for sibling max, etc
	;Incorporate beast generation
}

Import:
{
	#Requires AutoHotkey v1.1+
	#SingleInstance Force
	#Include, %A_ScriptDir%\Libraries\WebPLib.ahk
	
	FileEncoding UTF-8
	IconChange()
	FolderVarSet()
	
	PlayerCount = 5
	PlayerLevel = 6
	ProficiencyBonus = 3	;https://5e.tools/tables.html#proficiency%20bonus_xphb	Lvls 5-8
	Habitat = Inferno
	
	Loop, Read, %NPCDir%\Goals.ini
		Goals_Lines = %A_Index%
	Loop, Read, %NPCDir%\Roles.ini
		Roles_Lines = %A_Index%
	Loop, Read, %BaseDir%\Loot\Banks\.Gods.ini
		Gods_Lines = %A_Index%
	Loop, Read, %BaseDir%\Loot\Banks\NPC\Traits.ini
		Traits_Lines = %A_Index%
	Loop, Read, %BaseDir%\Loot\Banks\NPC\Quirks.ini
		Quirks_Lines = %A_Index%
	SettingsRead()
	InitializeGUI()
	Start()
}

Start()
{
	global
	;Race:="Human", Gender:="Male"	;Debug
	SettingsRead()
	SettingModifiers()
	NPC()
	Generate()
	NamesGUI()
	UpdateIni()
	;SettingsPage()
return
}
;# ============================================================================ #
;# GUI
NamesGUI()
{
	global
	Gui, GenGUI:New
	Gui, GenGUI:Color, 050505
	Gui +LastFound
	Gui, GenGUI:-Caption

	Gui, GenGUI:Font, s16
	Gui, GenGUI:Add, Text, cWhite BackgroundTrans w200 x%Row1% y28 r1 gChangeRace vRace, %FullGender% %Race%
	Gui, GenGUI:Font, s14
	Gui, GenGUI:Add, Text, cGray BackgroundTrans w200 x%Row1% gChangeRole vRole y58 r2, %NPC_Role%
	Gui, GenGUI:Add, Text, cGray BackgroundTrans w200 x%Row1% gChangeClass vClass y88 r3, Level %NPC_Level% // %NPC_Class%
	Gui, GenGUI:Font, s12
	Gui, GenGUI:Add, Text, cGray BackgroundTrans w%Margin_w% x%Row1% y210 r1 r2 vFamily gChangeFamily, %NPC_Family%
	Gui, GenGUI:Add, Text, cGray BackgroundTrans w%Margin_w% x%Row1% y250 r1 r2 vTrait gChangeTrait, %Traits%
	Gui, GenGUI:Add, Text, cGray BackgroundTrans w%Margin_w% x%Row1% y290 r1 r2 vGoal gChangeGoal, %NPC_Goal%
	Gui, GenGUI:Add, Text, cGray BackgroundTrans w%Margin_w% x%Row1% y330 r1 r2 vQuirk gChangeQuirk, Has a %NPC_Quirk%.
	Gui, GenGUI:Add, Text, cGray BackgroundTrans w%Margin_w% x%Row1% y370 r1 r2 vEquipment gChangeEquipment, Equipped w/ %NPC_Weapons%, %NPC_Armor%
	
	Gui, GenGUI:Font, s12
	IniRead, RunCount, %Ini%, Names, RunCount
	Gui, GenGUI:Add, Text, cGray w20 x1135 y60 BackgroundTrans left, #%RunCount%
	Gui, GenGUI:Add, Text, cGray w100 x%Row3% y30 BackgroundTrans right, v%Version%
	
	;Names
	N_y:=140, NA_y:=N_y+2
	N1_x:=640, N2_x:=N1_x+180, N3_x:=N2_x+180
	N1t_x:=N1_x+5, N2t_x:=N2_x+5, N3t_x:=N3_x+5
	Gui, GenGUI:Font, s13
	Gui, GenGUI:Add, Picture, y410 x%N1_x% h100 w550 gChangeStats,	;Stats reroll button
	Gui, GenGUI:Add, Picture, y%N_y% x%N1_x% h60 w175, %Bin%\Icons\WhiteMaskShape.png
	Gui, GenGUI:Add, Picture, y%N_y% x%N2_x% h60 w175, %Bin%\Icons\WhiteMaskShape.png
	Gui, GenGUI:Add, Picture, y%N_y% x%N3_x% h60 w175, %Bin%\Icons\WhiteMaskShape.png
	Gui, GenGUI:Add, Text, cBlack BackgroundTrans w165 x%N1t_x% h50 y%NA_y% vName1 gFoundryName1 center, %NameArray1%
	Gui, GenGUI:Add, Text, cBlack BackgroundTrans w165 x%N2t_x% h50 y%NA_y% vName2 gFoundryName2 center, %NameArray2%
	Gui, GenGUI:Add, Text, cBlack BackgroundTrans w165 x%N3t_x% h50 y%NA_y% vName3 gFoundryName3 center, %NameArray3%
	
	;Saving Throws
	Gui, GenGUI:Font, s12
	ST_y:=420, STMod_y:=ST_y+2
	Gui, GenGUI:Add, Picture, y%ST_y% x650 h24 w80, %Bin%\Icons\WhiteMaskShape.png
	Gui, GenGUI:Add, Picture, y%ST_y% x740 h24 w80, %Bin%\Icons\WhiteMaskShape.png
	Gui, GenGUI:Add, Picture, y%ST_y% x830 h24 w80, %Bin%\Icons\WhiteMaskShape.png
	Gui, GenGUI:Add, Picture, y%ST_y% x920 h24 w80, %Bin%\Icons\WhiteMaskShape.png
	Gui, GenGUI:Add, Picture, y%ST_y% x1010 h24 w80, %Bin%\Icons\WhiteMaskShape.png
	Gui, GenGUI:Add, Picture, y%ST_y% x1100 h24 w80, %Bin%\Icons\WhiteMaskShape.png
	Gui, GenGUI:Add, Text, cBlack BackgroundTrans w70 x655 y%STMod_y% vSTR_s center, %STR_mod%%STR_s%
	Gui, GenGUI:Add, Text, cBlack BackgroundTrans w70 x745 y%STMod_y% vDEX_s center, %DEX_mod%%DEX_s%
	Gui, GenGUI:Add, Text, cBlack BackgroundTrans w70 x835 y%STMod_y% vCON_s center, %CON_mod%%CON_s%
	Gui, GenGUI:Add, Text, cBlack BackgroundTrans w70 x925 y%STMod_y% vINT_s center, %INT_mod%%INT_s%
	Gui, GenGUI:Add, Text, cBlack BackgroundTrans w70 x1015 y%STMod_y% vWIS_s center, %WIS_mod%%WIS_s%
	Gui, GenGUI:Add, Text, cBlack BackgroundTrans w70 x1105 y%STMod_y% vCHA_s center, %CHA_mod%%CHA_s%
	
	;Ability Scores
	ASShapes_y:=ST_y+30, AS_y:=ASShapes_y+2, AS_h:=50	;lol ass shape
	Gui, GenGUI:Add, Picture, y%ASShapes_y% x650 h%AS_h% w80, %Bin%\Icons\WhiteMaskShape.png
	Gui, GenGUI:Add, Picture, y%ASShapes_y% x740 h%AS_h% w80, %Bin%\Icons\WhiteMaskShape.png
	Gui, GenGUI:Add, Picture, y%ASShapes_y% x830 h%AS_h% w80, %Bin%\Icons\WhiteMaskShape.png
	Gui, GenGUI:Add, Picture, y%ASShapes_y% x920 h%AS_h% w80, %Bin%\Icons\WhiteMaskShape.png
	Gui, GenGUI:Add, Picture, y%ASShapes_y% x1010 h%AS_h% w80, %Bin%\Icons\WhiteMaskShape.png
	Gui, GenGUI:Add, Picture, y%ASShapes_y% x1100 h%AS_h% w80, %Bin%\Icons\WhiteMaskShape.png
	Gui, GenGUI:Add, Text, cBlack BackgroundTrans w70 x655 y%AS_y% vSTR center, STR`n%STR%
	Gui, GenGUI:Add, Text, cBlack BackgroundTrans w70 x745 y%AS_y% vDEX center, DEX`n%DEX%
	Gui, GenGUI:Add, Text, cBlack BackgroundTrans w70 x835 y%AS_y% vCON center, CON`n%CON%
	Gui, GenGUI:Add, Text, cBlack BackgroundTrans w70 x925 y%AS_y% vINT center, INT`n%INT%
	Gui, GenGUI:Add, Text, cBlack BackgroundTrans w70 x1015 y%AS_y% vWIS center, WIS`n%WIS%
	Gui, GenGUI:Add, Text, cBlack BackgroundTrans w70 x1105 y%AS_y% vCHA center, CHA`n%CHA%

	ImageGUI()
	Gui, GenGUI:Add, Picture, h-1 w600 x10 y10 gChangeAvatar vAvatar, %random_file%
	CheckFile := random_file
	If (CheckFile := "")
		Gui, GenGUI:Add, Picture, h-1 w550 x10 y10 gChangeAvatar, %Bin%\Icons\Placeholder.jpg

	Bag_h:=80, Bag_w:=80, Bag_x:=650, Bag_y:=520
	Gui, GenGUI:Add, Picture, y%Bag_y% x%Bag_x% h%Bag_h% w%Bag_w%, %Bin%\Icons\WhiteMaskShape.png
	Gui, GenGUI:Add, Picture, y%Bag_y% x%Bag_x% h%Bag_h% w%Bag_w% BackgroundTrans, %Bin%\Icons\Bag.png
	
	Gui, GenGUI:Add, Picture, y570 x1150 h35 w35 BackgroundTrans gButtonSettings, %Bin%\Icons\Settings.png

	Gui, GenGUI:Show, w1200 h620 x350, GenGUI
	return
	ButtonSettings:
	SettingsPage()
	;Gui, Settings:Show, w600 h620 x1730, Settings
	Gui, Settings:Show, w600 h620 x730, Settings
	return
}
ImageGUI()
{
	global
	;Image:
	{
		array := [], random_file:=""  ; initialise array
		loop, Files, %ImgDir%\*, FDR  ; match any file
			array.push(a_loopFileFullPath)  ; append file to the end of the array
		total_file_count := array.maxIndex()
		random, random_number, 1, % total_file_count
		random_file := array[random_number]
		ImgPath := array[random_number]
		;Clipboard = %random_file%
		;MsgBox, % random_file
	}
	If InStr(random_file, "webp")
	{
		;Msgbox % random_file
		;filePath := []
		;filePath = %random_file%
		;hBitmap := HBitmapFromWebP(random_file, width, height)
		;random_file := "HBITMAP:" hBitmap
		random_file := "HBITMAP: " . HBitmapFromWebP(random_file)
		;Msgbox % random_file
	}
	return
}

GUI_Backgrounds(BGImg)
{
	global
	count := 0
	Loop, %BackgroundDir%\*.jpg
	{
		if A_LoopFileAttrib contains H,R,S
			continue
		count += 1
	}
	Random, FileNumber, 1, %count%
	Loop, Files, %BackgroundDir%\*.jpg, F
	{
		;Msgbox %A_Index% %Count%
		if (A_Index > FileNumber)
		{
			BGImg = %BackgroundDir%\%A_LoopFileName%
			break
		}
		;count += 1
	}
	return %BGimg%
}

	; ============================================================================ #
	;# Internal Functions
	IconChange()
	{
		global
		I_Icon = C:\Program Files\AutoHotkey\Icons\Names.ico
		ICON [I_Icon]                        ;Changes a compiled script's icon (.exe)
		if I_Icon <>

			IfExist, %I_Icon%
				Menu, Tray, Icon, %I_Icon%   ;Changes menu tray icon
		return
	}

	FolderVarSet()
	{
		global
		SrcDir = K:\Documents\Foundry\Data\moulinette\tiles\custom\TOHP\Tokens\Homebrew
		Bin = D:\Documents\Notes\DND\DND\DM\Scripts\Libraries
		Ini = %Bin%\Generate.ini
		SapientDir = %SrcDir%\Sapient
		BeastDir = %SrcDir%\Beasts
		ExportDir = K:\Documents\Foundry\Data\moulinette\tiles\custom\TOHP\Tokens\NPC

		BaseDir = %A_ScriptDir%
		Dir = %A_ScriptDir%\Names
		LootDir = %A_ScriptDir%\Loot\Banks
		NPCDir = %A_ScriptDir%\Loot\Banks\NPC
		RaceList = %A_ScriptDir%\Names\.List.txt
		BackgroundDir = %SrcDir%\Scenes\.UI\Backgrounds\Rectangle
		return
	}

	InitializeGUI()
	{
		global
		GUI_w:=600, GUI_h:=400
		Margin_x:=20, Margin_y:=20
		Margin_w:= GUI_w - (Margin_x * 5), Margin_h:= GUI_h - 20
		Row1:=650, Row2:=860, Row3:=1070, Row4:=1200
		Col1:=105, Col2:=135, Col3:=165, Col4:=195, Col5:=225, Col6:=255

		;Icons
		Gui, GenGUI:Add, Picture, x650 y120 w520 h6 gChangeNames, %Bin%\Icons\Divider.png
		Gui, GenGUI:Add, Picture, x1160 y210 w15 h200 gChangeBody , %Bin%\Icons\VerticalDivide.png
		Gui, GenGUI:Add, Picture, y55 x1130 h48 w48 gStart, %Bin%\Icons\D20.png
		;Gui, GenGUI:Add, Picture, y5 x10 h36 w72 gStart, %Bin%\Icons\TabScene.jpg
		Gui, GenGUI:Add, Picture, y30 x1100 h20 w-1 gSettingsPage BackgroundTrans, %Bin%\Icons\Settings.png
		return
	}

	; ============================================================================ #
	;# NPC Guts
	NPC()
	{
		global
		;Level
		{
			PlayerLevelMax := PlayerLevel + 2
			Random, NPC_Level, 0, %PlayerLevelMax%
		}
		;ChallengeRating
		{
			MaxCR := Round(PlayerCount / 4 * PlayerLevel * 1.2, 0)
			Random, CR, 0.0, %MaxCR%.0
			;Msgbox %CR%
		}
		;Classes:
		{
			Loop, Read, %NPCDir%\Classes.ini
				Classes_Lines = %A_Index%
			Random, ClassesRnd, 1, Classes_Lines
			FileReadLine, NPC_Class, %NPCDir%\Classes.ini, ClassesRnd
		}
		;Statblock	;4d6 drop low method
		{
			Loop 6
			{
				LST:=[]
				StatRoll:=[]
				Loop 4
				{
					StatRollRnd := 0
					Random, StatRollRnd, 1, 6
					StatRoll[A_Index]:=StatRollRnd
					LST.=StatRoll[A_Index] "`n"
				}
				Sort LST,R
				;MsgBox % LST

				DIV:=InStr(LST,"`n")
				Lowest_Roll:=SubStr(LST,6,DIV)
				;MsgBox % Lowest_Roll
				StatRoll := StrReplace(LST, Lowest_Roll,,,1)
				;Msgbox %StatRoll%

				StatRoll := StrSplit(StatRoll, "`n")
				StatRoll%A_Index% := StatRoll.1 + StatRoll.2 + StatRoll.3
				;Msgbox % StatRoll%A_Index%
			}

			;Scores
			{
				STR = % StatRoll1
				DEX = % StatRoll2
				CON = % StatRoll3
				INT = % StatRoll4
				WIS = % StatRoll5
				CHA = % StatRoll6

				STR_s := Floor((STR - 10) / 2)
				DEX_s := Floor((DEX - 10) / 2)
				CON_s := Floor((CON - 10) / 2)
				INT_s := Floor((INT - 10) / 2)
				WIS_s := Floor((WIS - 10) / 2)
				CHA_s := Floor((CHA - 10) / 2)

				If (STR_s < 0)
					STR_mod := ""
				Else
					STR_mod := "+"
				If (DEX_s < 0)
					DEX_mod := ""
				Else
					DEX_mod := "+"
				If (CON_s < 0)
					CON_mod := ""
				Else
					CON_mod := "+"
				If (INT_s < 0)
					INT_mod := ""
				Else
					INT_mod := "+"
				If (WIS_s < 0)
					WIS_mod := ""
				Else
					WIS_mod := "+"
				If (CHA_s < 0)
					CHA_mod := ""
				Else
					CHA_mod := "+"

			}
		}
		;Classes_StatIntegration
		{
			;LoadoutQty:
			{
				If NPC_Level > 3
					Loadout = 2
				If NPC_Level < 4
					Random, Loadout, 0, 2
				SimpleMartial = Simple
				MeleeRanged = Melee
				ArmorType = Light
				Shield := []
			}
			If NPC_Class = Artificer
			{
				;ArtificerClass_Proficiency
				{
					Random, Class_cho, 1, 2
					If Class_cho = 1
						SavingThrowINT := INT + ProficiencyBonus
					If Class_cho = 2
						SavingThrowCON := CON + ProficiencyBonus
				}

				;ArtificerWeapon
				{
					Random, MeleeRanged, 1, 2
					If MeleeRanged = 1
						MeleeRanged = Melee
					If MeleeRanged = 2
						MeleeRanged = Ranged

					SimpleMartial = Simple
				}

				;ArtificerArmor
				{
					Random, Shield, 0, 1
					If Shield = 0
						Shield := []
					If Shield = 1
						Shield = , Shield
					Random, ArmorType, 1, 2
					If ArmorType = 1
						ArmorType = Light
					If ArmorType = 2
						ArmorType = Medium
				}
			}
			If NPC_Class = Barbarian
			{
				Random, Class_cho, 1, 3
				If Class_cho = 1
					SavingThrowSTR := STR + ProficiencyBonus
				If Class_cho = 2
					SavingThrowDEX := DEX + ProficiencyBonus
				If Class_cho = 3
					SavingThrowWIS := WIS + ProficiencyBonus

				;BarbarianWeapon
				{
					Random, SimpleMartial, 1, 100
					If SimpleMartial between 1 and 40
						SimpleMartial = Simple
					If SimpleMartial between 41 and 100
						SimpleMartial = Martial

					MeleeRanged = Melee
				}

				;BarbarianArmor
				{
					Random, Shield, 0, 1
					If Shield = 0
						Shield := []
					If Shield = 1
						Shield = , Shield
					Random, ArmorType, 1, 2
					If ArmorType = 1
						ArmorType = Light
					If ArmorType = 2
						ArmorType = Medium
				}
			}
			If NPC_Class = Bard
			{
				Random, Class_cho, 1, 6
				If Class_cho = 1
					SavingThrowSTR := STR + ProficiencyBonus
				If Class_cho = 2
					SavingThrowDEX := DEX + ProficiencyBonus
				If Class_cho = 3
					SavingThrowWIS := WIS + ProficiencyBonus
				If Class_cho = 4
					SavingThrowCON := CON + ProficiencyBonus
				If Class_cho = 5
					SavingThrowINT := INT + ProficiencyBonus
				If Class_cho = 6
					SavingThrowCHA := CHA + ProficiencyBonus

				;BardWeapon:
				{
					Random, MeleeRanged, 1, 100
					If MeleeRanged between 1 and 60
						MeleeRanged = Melee
					If MeleeRanged between 61 and 100
						MeleeRanged = Ranged

					SimpleMartial = Simple
				}

				;BardArmor:
				{
					Shields := []
					ArmorType = Light
				}
			}
			If NPC_Class = Cleric
			{
				Random, Class_cho, 1, 3
				If Class_cho = 1
					SavingThrowWIS := WIS + ProficiencyBonus
				If Class_cho = 2
					SavingThrowINT := INT + ProficiencyBonus
				If Class_cho = 3
					SavingThrowCHA := CHA + ProficiencyBonus

				;ClericWeapon:
				{
					Random, MeleeRanged, 1, 100
					If MeleeRanged between 1 and 60
						MeleeRanged = Melee
					If MeleeRanged between 61 and 100
						MeleeRanged = Ranged

					SimpleMartial = Simple
				}

				;ClericArmor:
				{
					Random, Shield, 0, 1
					If Shield = 0
						Shield := []
					If Shield = 1
						Shield = , Shield
					Random, ArmorType, 1, 2
					If ArmorType = 1
						ArmorType = Light
					If ArmorType = 2
						ArmorType = Medium
				}
			}
			If NPC_Class = Druid
			{
				Random, Class_cho, 1, 2
				If Class_cho = 1
					SavingThrowWIS := WIS + ProficiencyBonus
				If Class_cho = 2
					SavingThrowINT := INT + ProficiencyBonus

				;DruidWeapon:
				{
					Random, MeleeRanged, 1, 100
					If MeleeRanged between 1 and 60
						MeleeRanged = Melee
					If MeleeRanged between 61 and 100
						MeleeRanged = Ranged

					SimpleMartial = Simple
				}

				;DruidArmor:
				{
					Random, Shield, 0, 1
					If Shield = 0
						Shield := []
					If Shield = 1
						Shield = , Shield
					ArmorType = Light
				}
			}
			If NPC_Class = Fighter
			{
				Random, Class_cho, 1, 3
				If Class_cho = 1
					SavingThrowSTR := STR + ProficiencyBonus
				If Class_cho = 2
					SavingThrowDEX := DEX + ProficiencyBonus
				If Class_cho = 3
					SavingThrowWIS := WIS + ProficiencyBonus

				;FighterWeapon:
				{
					Random, SimpleMartial, 1, 100
					If SimpleMartial between 1 and 20
						SimpleMartial = Simple
					If SimpleMartial between 21 and 100
						SimpleMartial = Martial

					MeleeRanged = Melee
				}

				;FighterArmor:
				{
					Random, Shield, 0, 1
					If Shield = 0
						Shield := []
					If Shield = 1
						Shield = , Shield
					Random, ArmorType, 1, 3
					If ArmorType = 1
						ArmorType = Light
					If ArmorType = 2
						ArmorType = Medium
					If ArmorType = 3
						ArmorType = Heavy
				}
			}
			If NPC_Class = Monk
			{
				Random, Class_cho, 1, 3
				If Class_cho = 1
					SavingThrowSTR := STR + ProficiencyBonus
				If Class_cho = 2
					SavingThrowDEX := DEX + ProficiencyBonus
				If Class_cho = 3
					SavingThrowINT := INT + ProficiencyBonus

				;MonkWeapon:
				{
					Random, MeleeRanged, 1, 100
					If MeleeRanged between 1 and 60
						MeleeRanged = Melee
					If MeleeRanged between 61 and 100
						MeleeRanged = Ranged

					Random, SimpleMartial, 1, 100
					If SimpleMartial between 1 and 45
						SimpleMartial = Simple
					If SimpleMartial between 46 and 100
						SimpleMartial = Martial
				}

				;MonkArmor:
				{
					Shield := []
					ArmorType := []
				}
			}
			If NPC_Class = Paladin
			{
				Random, Class_cho, 1, 3
				If Class_cho = 1
					SavingThrowSTR := STR + ProficiencyBonus
				If Class_cho = 2
					SavingThrowCHA := CHA + ProficiencyBonus
				If Class_cho = 3
					SavingThrowWIS := WIS + ProficiencyBonus

				;PaladinWeapon:
				{
					Random, MeleeRanged, 1, 100
					If MeleeRanged between 1 and 60
						MeleeRanged = Melee
					If MeleeRanged between 61 and 100
						MeleeRanged = Ranged

					Random, SimpleMartial, 1, 100
					If SimpleMartial between 1 and 45
						SimpleMartial = Simple
					If SimpleMartial between 46 and 100
						SimpleMartial = Martial
				}

				;PaladinArmor:
				{
					Random, Shield, 0, 1
					If Shield = 0
						Shield := []
					If Shield = 1
						Shield = , Shield
					Random, ArmorType, 1, 3
					If ArmorType = 1
						ArmorType = Light
					If ArmorType = 2
						ArmorType = Medium
					If ArmorType = 3
						ArmorType = Heavy
				}
			}
			If NPC_Class = Ranger
			{
				Random, Class_cho, 1, 3
				If Class_cho = 1
					SavingThrowSTR := STR + ProficiencyBonus
				If Class_cho = 2
					SavingThrowDEX := DEX + ProficiencyBonus
				If Class_cho = 3
					SavingThrowWIS := WIS + ProficiencyBonus

				;RangerWeapon:
				{
					Random, SimpleMartial, 1, 100
					If SimpleMartial between 1 and 20
						SimpleMartial = Simple
					If SimpleMartial between 21 and 100
						SimpleMartial = Martial

					MeleeRanged = Ranged
				}

				;RangerArmor:
				{
					Random, Shield, 0, 1
					If Shield = 0
						Shield := []
					If Shield = 1
						Shield = , Shield
					Random, ArmorType, 1, 2
					If ArmorType = 1
						ArmorType = Light
					If ArmorType = 2
						ArmorType = Medium
				}
			}
			If NPC_Class = Rogue
			{
				Random, Class_cho, 1, 4
				If Class_cho = 1
					SavingThrowDEX := DEX + ProficiencyBonus
				If Class_cho = 2
					SavingThrowWIS := WIS + ProficiencyBonus
				If Class_cho = 3
					SavingThrowINT := INT + ProficiencyBonus
				If Class_cho = 4
					SavingThrowCHA := CHA + ProficiencyBonus

				;RogueWeapon:
				{
					Random, SimpleMartial, 1, 100
					If SimpleMartial between 1 and 20
						SimpleMartial = Simple
					If SimpleMartial between 21 and 100
						SimpleMartial = Martial

					MeleeRanged = Ranged
				}

				;RogueArmor:
				{
					Shield := []
					ArmorType = Light
				}
			}
			If NPC_Class = Sorcerer
			{
				Random, Class_cho, 1, 2
				If Class_cho = 1
					SavingThrowCHA := CHA + ProficiencyBonus
				If Class_cho = 2
					SavingThrowINT := INT + ProficiencyBonus

				;SorcererWeapon:
				{
					Random, MeleeRanged, 1, 100
					If MeleeRanged between 1 and 80
						MeleeRanged = Melee
					If MeleeRanged between 81 and 100
						MeleeRanged = Ranged

					SimpleMartial = Simple
				}

				;SorcererArmor:
				{
					Shield := []
					ArmorType := []
				}
			}
			If NPC_Class = Warlock
			{
				Random, Class_cho, 1, 2
				If Class_cho = 1
					SavingThrowCHA := CHA + ProficiencyBonus
				If Class_cho = 2
					SavingThrowINT := INT + ProficiencyBonus

				;WarlockWeapon:
				{
					Random, MeleeRanged, 1, 100
					If MeleeRanged between 1 and 80
						MeleeRanged = Melee
					If MeleeRanged between 81 and 100
						MeleeRanged = Ranged

					SimpleMartial = Simple
				}

				;WarlockArmor:
				{
					Shield := []
					ArmorType = Light
				}
			}
			If NPC_Class = Wizard
			{
				Random, Class_cho, 1, 2
				If Class_cho = 1
					SavingThrowWIS := WIS + ProficiencyBonus
				If Class_cho = 2
					SavingThrowINT := INT + ProficiencyBonus

				;WizardWeapon:
				{
					Random, MeleeRanged, 1, 100
					If MeleeRanged between 1 and 80
						MeleeRanged = Melee
					If MeleeRanged between 81 and 100
						MeleeRanged = Ranged

					SimpleMartial = Simple
				}

				;WizardArmor:
				{
					Shield := []
					ArmorType := []
				}
			}

			;Races_StatIntegration:
			{
				#Include %A_ScriptDir%\Libraries\Races_StatIntegration.ahk
			}

			;Msgbox %STR% STR | %DEX% DEX | %CON% CON | %INT% INT | %WIS% WIS | %CHA% CHA
			;AbilityScores = %STR% STR | %DEX% DEX | %CON% CON | %INT% INT | %WIS% WIS | %CHA% CHA
		}
		;Goals:
		{
			Random, GoalsRnd, 1, Goals_Lines
			FileReadLine, NPC_Goal, %NPCDir%\Goals.ini, GoalsRnd
		}
		;Family:
		{
			Random, 1d6, 1, 4
			Random, 1d6x2, 1, 4

			;Siblings:
			{
				Random, SiblingsVar, 0, 4
				If SiblingsVar = 0
					Siblings = only child
				If SiblingsVar = 1
					Siblings = %1d6% brothers
				If SiblingsVar = 2
					Siblings = %1d6% sisters
				If SiblingsVar between 3 and 4
					Siblings = %1d6% sisters, %1d6x2% brothers
			}
			;Parents:
			{
				Random, ParentsVar, 0, 12
				If ParentsVar = 0
					Parents = Deceased parents,
				If ParentsVar = 1
					Parents = A father,
				If ParentsVar = 2
					Parents = A mother,
				If ParentsVar = 3
					Parents = Abandoned by father,
				If ParentsVar = 4
					Parents = Abandoned by mother,
				If ParentsVar = 5
					Parents = Abandoned by both parents,
				If ParentsVar = 6
					Parents = Parents are missing,
				If ParentsVar between 7 and 12
					Parents = A mother and father,
			}
			;Relationship:
			{
				Random, RelationshipVar, 0, 25
				If RelationshipVar = 0
					Relationship = Lonely
				If RelationshipVar between 1 and 3
					Relationship = Single
				If RelationshipVar between 4 and 5
					Relationship = Cheating
				If RelationshipVar between 6 and 8
					Relationship = Married
				If RelationshipVar between 9 and 10
					Relationship = Widowed
				If RelationshipVar = 11
					Relationship = Gay relationship
				If RelationshipVar = 12
					Relationship = Polymarous relationship
				If RelationshipVar = 13
					Relationship = Complicated relationship
				If RelationshipVar = 14
					Relationship = Obsessed
				If RelationshipVar between 15 and 16
					Relationship = Recent breakup
				If RelationshipVar = 17
					Relationship = Infatuated
				If RelationshipVar = 18
					Relationship = Polygamous relationship
				If RelationshipVar between 19 and 20
					Relationship = Dating
				If RelationshipVar between 21 and 25
					Relationship = Straight relationship
			}
			NPC_Family = %Parents% %Siblings% | %Relationship%
		}
		;Role:
		{
			Random, RolesRnd, 1, Roles_Lines
			FileReadLine, NPC_Role, %NPCDir%\Roles.ini, RolesRnd
		}
		;Religion:
		{
			Random, GodsRnd, 1, Gods_Lines
			FileReadLine, NPC_Gods, %BaseDir%\Loot\Banks\.Gods.ini, GodsRnd
		}
		;Traits:
		{
			Random, TraitRnd1, 1, Traits_Lines
			FileReadLine, NPC_Trait1, %BaseDir%\Loot\Banks\NPC\Traits.ini, TraitRnd1
			Random, TraitRnd2, 1, Traits_Lines
			FileReadLine, NPC_Trait2, %BaseDir%\Loot\Banks\NPC\Traits.ini, TraitRnd2

			Traits = Others would describe them as %NPC_Trait1% and %NPC_Trait2%.

		}
		;Quirks:
		{
			Random, QuirksRnd, 1, Quirks_Lines
			FileReadLine, NPC_Quirk, %BaseDir%\Loot\Banks\NPC\Quirks.ini, QuirksRnd
		}
		;Weapons:
		{
			Random, MagicMundane, 1, 100
			if MagicMundane between 1 and 90	;MundaneWeapons
				WeaponFolder = WeaponsMundane
			if MagicMundane between 91 and 100	;MagicWeapons
			{
				Random, WeaponMagicRnd, 1, 100
				if WeaponMagicRnd between 1 and 70
					WeaponMagic = Uncommon
				if WeaponMagicRnd between 71 and 80
					WeaponMagic = Rare
				if WeaponMagicRnd between 81 and 90
					WeaponMagic = VeryRare
				if WeaponMagicRnd between 98 and 99
					WeaponMagic = Legendary
				if WeaponMagicRnd = 100
					WeaponMagic = Artifact

				WeaponFolder = WeaponsMagic\Rarity_%WeaponMagic%
			}

			WeaponFile = %LootDir%\%WeaponFolder%\%SimpleMartial%%MeleeRanged%.ini
			;Msgbox %WeaponFile%	;debug
			if !FileExist(WeaponFile)
			{
				;Msgbox Reroll	;debug
				MagicMundane := []
				WeaponMagicRnd := []
			}

			Loop, Read, %WeaponFile%
				Weapons_Lines = %A_Index%
			Random, WeaponsRnd, 1, Weapons_Lines
			FileReadLine, NPC_Weapons, %WeaponFile%, WeaponsRnd
		}
		;Armors:
		{
			ArmorFile = %LootDir%\Armors\%ArmorType%Armor.ini
			Loop, Read, %ArmorFile%
				Armor_Lines = %A_Index%
			Random, ArmorRnd, 1, Armor_Lines
			FileReadLine, NPC_Armor, %ArmorFile%, ArmorRnd

			;Msgbox %ArmorType% Armor %Shield%
			NPC_Armor = %NPC_Armor%%Shield%
		}
		return
	}

	Gender()
	{
		global
		If (InStr(Gender, "Any"))
			Random, MF, 1, 2
		if (MF = "1") || if (Gender = "M")
		{
			Gender = M
			FullGender = Male
			ImgDir = %SapientDir%\%Race%\Male
		}
		if (MF = "2") || if (Gender = "F")
		{
			Gender = F
			FullGender = Female
			ImgDir = %SapientDir%\%Race%\Female
		}
		return
	}
	; ============================================================================ #
	;# Generate
	SettingModifiers()
	{
		global
		DebugMode := 0, BeastMode := 0

		If InStr(Race, "db")
		{
			DebugMode = 1
			Race = Squaloan
			Gender = m
		}

		If InStr(Race, "beast")
		{
			Random, BeastAttitudeRnd, 1, 100
			if BeastAttitudeRnd between 1 and 40
				BeastAttitude = Aggressive
			if BeastAttitudeRnd between 41 and 80
				BeastAttitude = Neutral
			if BeastAttitudeRnd between 81 and 100
				BeastAttitude = Friendly

			ImgDir = %BeastDir%\%BeastAttitude%
			BeastMode = 1
			Race = Beast
		}

		If (InStr(Race, "All"))
		{
			Loop, Read, %RaceList%
				Races_Lines = %A_Index%
			Random, RacesRnd, 1, Races_Lines
			FileReadLine, Race, %RaceList%, RacesRnd
			;Race := "Elemental"	;Debug
			;Msgbox % Race
		}
		ImgDir = %SapientDir%\%Race%\%Gender%
		Gender()

		;Nongendered races // search root folder instead
		If (Race = "Elemental") || If (Race = "Misc") || If (Race = "Beastiary")
		{
			ImgDir = %SapientDir%\%Race%
		}

		FirstFile = %Dir%\%Race%\%Race%_%Gender%.txt
		;Msgbox %FirstFile%
		LastFile_0 = %Dir%\%Race%\%Race%_s0.txt
		LastFile_1 = %Dir%\%Race%\%Race%_s1.txt
		LastFile_2 = %Dir%\%Race%\%Race%_s2.txt
		RaceSetDir = %SapientDir%\%Race%
		if !FileExist(RaceSetDir)
		{
			Msgbox Error 404: %RACE% not found
			Reload
		}
		If (DebugMode = 1)
		{
			random_file = %SapientDir%\.debug.png
			;ImageGUI()
		}
		return
	}

	Generate()
	{
		global
		;CountNames:
		{
			Loop, Read, %FirstFile%
				fLines = %A_Index%
			;Msgbox %fLines%
			If FileExist(LastFile_0)
			{
				Loop, Read, %LastFile_0%
					s0Lines = %A_Index%
				Sur0 = true
			}
			Loop, Read, %LastFile_1%
				s1Lines = %A_Index%
			Loop, Read, %LastFile_2%
				s2Lines = %A_Index%
			;Msgbox %fLines% %s1Lines% %s2Lines%	;Count names for race
		}

		Loop, 3
		{
			;GenerateMain:
			{
				Random, FirstRnd, 1, %fLines%
				Random, LastRnd_0, 1, %s0Lines%
				Random, LastRnd_1, 1, %s1Lines%
				Random, LastRnd_2, 1, %s2Lines%

				;Read:
				FileReadLine, First, %FirstFile%, %FirstRnd%
				If FileExist(LastFile_0)
					FileReadLine, Last_0, %LastFile_0%, %LastRnd_0%
				FileReadLine, Last_1, %LastFile_1%, %LastRnd_1%
				FileReadLine, Last_2, %LastFile_2%, %LastRnd_2%
				StringLower, Last_2b, Last_2
				;Msgbox %First% %Last_0% | %First% %Last_1% | %First% %Last_2%

				ColorFile = %A_ScriptDir%\Loot\Banks\.Colors.ini
				Loop, Read, %ColorFile%
					C_Lines = %A_Index%
				Random, ColorRnd, 1, %C_Lines%
				FileReadLine, COLOR, %ColorFile%, %ColorRnd%
				COLOR := StrSplit(COLOR, A_Tab)
				Last_0 := StrReplace(Last_0, "{COLOR}", Color.1)
				Last_1 := StrReplace(Last_1, "{COLOR}", Color.1)
				Last_2 := StrReplace(Last_2, "{COLOR}", Color.1)
				;MainGenNoun:
				{
					Random, NounsRnd, 1, 6
					Loop, Read, %A_ScriptDir%\Loot\Banks\Nouns\Nouns%NounsRnd%.txt
						Noun_Lines = %A_Index%
					Random, NounsRndLine, 1, %Noun_Lines%
					FileReadLine, Noun, %A_ScriptDir%\Loot\Banks\Nouns\Nouns%NounsRnd%.txt, NounsRndLine
				}
			}

			;IfStatements:
			{
				If (InStr(Last_0, "{FLORA}")) || If (InStr(Last_1, "{FLORA}")) || If (InStr(Last_2, "{FLORA}"))
				{
					FloraFile = %LootDir%\Beastiary\Flora\%Habitat%.ini
					Loop, Read, %FloraFile%
						Flora_Lines = %A_Index%
					Random, FloraRnd, 1, Flora_Lines
					FileReadLine, Flora, %FloraFile%, FloraRnd
					;Msgbox %Habitat%	;Debug
					Last_0 := StrReplace(Last_0, "{FLORA}", Flora)
					Last_1 := StrReplace(Last_1, "{FLORA}", Flora)
					Last_2 := StrReplace(Last_2, "{FLORA}", Flora)
				}
				If (InStr(NPC_Goal, "{FAMILY}")) || If (InStr(NPC_Flaw, "{FAMILY}")) || If (InStr(NPC_Bond, "{FAMILY}")) || If (InStr(NPC_Ideal, "{FAMILY}")) || If (InStr(NPC_Quirk, "{FAMILY}"))
				{
					FAMILYFile = %A_ScriptDir%\Loot\Banks\NPC\Family.ini
					Loop, Read, %FAMILYFile%
						FAMILY_Lines = %A_Index%
					Random, FAMILYRnd, 1, FAMILY_Lines
					FileReadLine, FAMILY, %FAMILYFile%, FAMILYRnd
					;NPC_FamilyReplacements:
					{
						NPC_Goal := StrReplace(NPC_Goal, "{FAMILY}", FAMILY)
						NPC_Flaw := StrReplace(NPC_Flaw, "{FAMILY}", FAMILY)
						NPC_Bond := StrReplace(NPC_Bond, "{FAMILY}", FAMILY)
						NPC_Quirk := StrReplace(NPC_Quirk, "{FAMILY}", FAMILY)
						NPC_Ideal := StrReplace(NPC_Ideal, "{FAMILY}", FAMILY)
					}
				}
				If (InStr(NPC_Goal, "{BEAST}")) || If (InStr(NPC_Flaw, "{BEAST}")) || If (InStr(NPC_Bond, "{BEAST}")) || If (InStr(NPC_Ideal, "{BEAST}")) || If (InStr(NPC_Quirk, "{BEAST}"))
				{
					BEASTFile = %LootDir%\Beastiary\.Global.txt
					Loop, Read, %BEASTFile%
						BEAST_Lines = %A_Index%
					Random, BEASTRnd, 1, BEAST_Lines
					FileReadLine, BEAST, %BEASTFile%, BEASTRnd
					;NPC_BEASTReplacements:
					{
						NPC_Goal := StrReplace(NPC_Goal, "{BEAST}", BEAST)
						NPC_Flaw := StrReplace(NPC_Flaw, "{BEAST}", BEAST)
						NPC_Bond := StrReplace(NPC_Bond, "{BEAST}", BEAST)
						NPC_Quirk := StrReplace(NPC_Quirk, "{BEAST}", BEAST)
						NPC_Ideal := StrReplace(NPC_Ideal, "{BEAST}", BEAST)
					}
				}
				If (InStr(NPC_Goal, "{EMBLEM}")) || If (InStr(NPC_Flaw, "{EMBLEM}")) || If (InStr(NPC_Bond, "{EMBLEM}")) || If (InStr(NPC_Ideal, "{EMBLEM}")) || If (InStr(NPC_Quirk, "{EMBLEM}"))
				{
					EMBLEMFile = %LootDir%\Misc\.Emblems.ini
					Loop, Read, %EMBLEMFile%
						EMBLEM_Lines = %A_Index%
					Random, EMBLEMRnd, 1, EMBLEM_Lines
					FileReadLine, EMBLEM, %EMBLEMFile%, EMBLEMRnd
					;NPC_EMBLEMReplacements:
					{
						NPC_Goal := StrReplace(NPC_Goal, "{EMBLEM}", EMBLEM)
						NPC_Flaw := StrReplace(NPC_Flaw, "{EMBLEM}", EMBLEM)
						NPC_Bond := StrReplace(NPC_Bond, "{EMBLEM}", EMBLEM)
						NPC_Quirk := StrReplace(NPC_Quirk, "{EMBLEM}", EMBLEM)
						NPC_Ideal := StrReplace(NPC_Ideal, "{EMBLEM}", EMBLEM)
					}
				}
				If (InStr(NPC_Goal, "{DRUG}")) || If (InStr(NPC_Flaw, "{DRUG}")) || If (InStr(NPC_Bond, "{DRUG}")) || If (InStr(NPC_Ideal, "{DRUG}")) || If (InStr(NPC_Quirk, "{DRUG}"))
				{
					DRUGFile = %A_ScriptDir%\Loot\Banks\Misc\.Drugs.ini
					Loop, Read, %DRUGFile%
						DRUG_Lines = %A_Index%
					Random, DRUGRnd, 1, DRUG_Lines
					FileReadLine, DRUG, %DRUGFile%, DRUGRnd
					;NPC_DrugReplacements:
					{
						NPC_Goal := StrReplace(NPC_Goal, "{DRUG}", DRUG)
						NPC_Flaw := StrReplace(NPC_Flaw, "{DRUG}", DRUG)
						NPC_Bond := StrReplace(NPC_Bond, "{DRUG}", DRUG)
						NPC_Quirk := StrReplace(NPC_Quirk, "{DRUG}", DRUG)
						NPC_Ideal := StrReplace(NPC_Ideal, "{DRUG}", DRUG)
					}
				}
				If (InStr(NPC_Goal, "{DISEASE}")) || If (InStr(NPC_Flaw, "{DISEASE}")) || If (InStr(NPC_Bond, "{DISEASE}")) || If (InStr(NPC_Ideal, "{DISEASE}")) || If (InStr(NPC_Quirk, "{DISEASE}"))
				{
					DISEASEFile = %A_ScriptDir%\Loot\Banks\Effects\Disease.ini
					Loop, Read, %DISEASEFile%
						DISEASE_Lines = %A_Index%
					Random, DISEASERnd, 1, DISEASE_Lines
					FileReadLine, DISEASE, %DISEASEFile%, DISEASERnd
					;NPC_DISEASEReplacements:
					{
						NPC_Goal := StrReplace(NPC_Goal, "{DISEASE}", DISEASE)
						NPC_Flaw := StrReplace(NPC_Flaw, "{DISEASE}", DISEASE)
						NPC_Bond := StrReplace(NPC_Bond, "{DISEASE}", DISEASE)
						NPC_Quirk := StrReplace(NPC_Quirk, "{DISEASE}", DISEASE)
						NPC_Ideal := StrReplace(NPC_Ideal, "{DISEASE}", DISEASE)
					}
				}
				If (InStr(NPC_Goal, "{ROLE}")) || If (InStr(NPC_Flaw, "{ROLE}")) || If (InStr(NPC_Bond, "{ROLE}")) || If (InStr(NPC_Ideal, "{ROLE}")) || If (InStr(NPC_Quirk, "{ROLE}"))
				{
					ROLEFile = %LootDir%\NPC\Roles.ini
					Loop, Read, %ROLEFile%
						ROLE_Lines = %A_Index%
					Random, ROLERnd, 1, ROLE_Lines
					FileReadLine, ROLE, %ROLEFile%, ROLERnd
					;NPC_ROLEReplacements:
					{
						NPC_Goal := StrReplace(NPC_Goal, "{ROLE}", ROLE)
						NPC_Flaw := StrReplace(NPC_Flaw, "{ROLE}", ROLE)
						NPC_Bond := StrReplace(NPC_Bond, "{ROLE}", ROLE)
						NPC_Quirk := StrReplace(NPC_Quirk, "{ROLE}", ROLE)
						NPC_Ideal := StrReplace(NPC_Ideal, "{ROLE}", ROLE)
					}
				}
				If (InStr(NPC_Goal, "{GOD}")) || If (InStr(NPC_Flaw, "{GOD}")) || If (InStr(NPC_Bond, "{GOD}")) || If (InStr(NPC_Ideal, "{GOD}")) || If (InStr(NPC_Quirk, "{GOD}"))
				{
					Random, GODRnd, 1, Gods_Lines
					FileReadLine, GOD, %BaseDir%\Loot\Banks\.Gods.ini, GODRnd
					;NPC_GODReplacements:
					{
						NPC_Goal := StrReplace(NPC_Goal, "{GOD}", GOD)
						NPC_Flaw := StrReplace(NPC_Flaw, "{GOD}", GOD)
						NPC_Bond := StrReplace(NPC_Bond, "{GOD}", GOD)
						NPC_Quirk := StrReplace(NPC_Quirk, "{GOD}", GOD)
						NPC_Ideal := StrReplace(NPC_Ideal, "{GOD}", GOD)
					}
				}
				If (InStr(NPC_Goal, "{LANGUAGE}")) || If (InStr(NPC_Flaw, "{LANGUAGE}")) || If (InStr(NPC_Bond, "{LANGUAGE}")) || If (InStr(NPC_Ideal, "{LANGUAGE}")) || If (InStr(NPC_Quirk, "{LANGUAGE}"))
				{
					Loop, Read, %LootDir%\.Languages.ini
						Languages_Lines = %A_Index%
					Random, LANGUAGERnd, 1, LANGUAGEs_Lines
					FileReadLine, LANGUAGE, %LootDir%\.Languages.ini, LANGUAGERnd
					;NPC_LANGUAGEReplacements:
					{
						NPC_Goal := StrReplace(NPC_Goal, "{LANGUAGE}", LANGUAGE)
						NPC_Flaw := StrReplace(NPC_Flaw, "{LANGUAGE}", LANGUAGE)
						NPC_Bond := StrReplace(NPC_Bond, "{LANGUAGE}", LANGUAGE)
						NPC_Quirk := StrReplace(NPC_Quirk, "{LANGUAGE}", LANGUAGE)
						NPC_Ideal := StrReplace(NPC_Ideal, "{LANGUAGE}", LANGUAGE)
					}
				}
				If (InStr(NPC_Goal, "{SUBJECT}")) || If (InStr(NPC_Flaw, "{SUBJECT}")) || If (InStr(NPC_Bond, "{SUBJECT}")) || If (InStr(NPC_Ideal, "{SUBJECT}")) || If (InStr(NPC_Quirk, "{SUBJECT}"))
				{
					Subject = {NOUN}
					;NPC_SUBJECTReplacements:
					{
						NPC_Goal := StrReplace(NPC_Goal, "{SUBJECT}", SUBJECT)
						NPC_Flaw := StrReplace(NPC_Flaw, "{SUBJECT}", SUBJECT)
						NPC_Bond := StrReplace(NPC_Bond, "{SUBJECT}", SUBJECT)
						NPC_Quirk := StrReplace(NPC_Quirk, "{SUBJECT}", SUBJECT)
						NPC_Ideal := StrReplace(NPC_Ideal, "{SUBJECT}", SUBJECT)
					}
				}
				If (InStr(NPC_Goal, "{ADJ}")) || If (InStr(NPC_Flaw, "{ADJ}")) || If (InStr(NPC_Bond, "{ADJ}")) || If (InStr(NPC_Ideal, "{ADJ}")) || If (InStr(NPC_Quirk, "{ADJ}"))
				{
					Random, ADJsRnd, 1, 12
					Loop, Read, %LootDir%\Adj\Adj%ADJsRnd%.txt
						ADJ_Lines = %A_Index%
					Random, ADJsRndLine, 1, %ADJ_Lines%
					FileReadLine, ADJ, %LootDir%\Adj\Adj%ADJsRnd%.txt, ADJsRndLine
					;NPC_ADJReplacements:
					{
						NPC_Goal := StrReplace(NPC_Goal, "{ADJ}", ADJ)
						NPC_Flaw := StrReplace(NPC_Flaw, "{ADJ}", ADJ)
						NPC_Bond := StrReplace(NPC_Bond, "{ADJ}", ADJ)
						NPC_Quirk := StrReplace(NPC_Quirk, "{ADJ}", ADJ)
						NPC_Ideal := StrReplace(NPC_Ideal, "{ADJ}", ADJ)
					}
				}
				If (InStr(NPC_Goal, "{NOUN}")) || If (InStr(NPC_Flaw, "{NOUN}")) || If (InStr(NPC_Bond, "{NOUN}")) || If (InStr(NPC_Ideal, "{NOUN}")) || If (InStr(NPC_Quirk, "{NOUN}"))
				{
					Random, NounsRnd, 1, 6
					Loop, Read, %A_ScriptDir%\Loot\Banks\Nouns\Nouns%NounsRnd%.txt
						Noun_Lines = %A_Index%
					Random, NounsRndLine, 1, %Noun_Lines%
					FileReadLine, Noun, %A_ScriptDir%\Loot\Banks\Nouns\Nouns%NounsRnd%.txt, NounsRndLine
					;NPC_NOUNReplacements:
					{
						NPC_Goal := StrReplace(NPC_Goal, "{NOUN}", NOUN)
						NPC_Flaw := StrReplace(NPC_Flaw, "{NOUN}", NOUN)
						NPC_Bond := StrReplace(NPC_Bond, "{NOUN}", NOUN)
						NPC_Quirk := StrReplace(NPC_Quirk, "{NOUN}", NOUN)
						NPC_Ideal := StrReplace(NPC_Ideal, "{NOUN}", NOUN)
					}
				}
				If (InStr(NPC_Goal, "{NOUNAbstractRemoved}")) || If (InStr(NPC_Flaw, "{NOUNAbstractRemoved}")) || If (InStr(NPC_Bond, "{NOUNAbstractRemoved}")) || If (InStr(NPC_Ideal, "{NOUNAbstractRemoved}")) || If (InStr(NPC_Quirk, "{NOUNAbstractRemoved}"))
				{
					NounsAbstractRemovedFile = %LootDir%\Nouns\NounsAbstractRemoved.txt
					Loop, Read, %NounsAbstractRemovedFile%
						NOUNAbstractRemoved_Lines = %A_Index%
					Random, NOUNAbstractRemovedsRndLine, 1, %NOUNAbstractRemoved_Lines%
					FileReadLine, NOUNAbstractRemoved, %NounsAbstractRemovedFile%, NOUNAbstractRemovedsRndLine
					;NPC_NOUNAbstractRemovedReplacements:
					{
						NPC_Goal := StrReplace(NPC_Goal, "{NOUNAbstractRemoved}", NOUNAbstractRemoved)
						NPC_Flaw := StrReplace(NPC_Flaw, "{NOUNAbstractRemoved}", NOUNAbstractRemoved)
						NPC_Bond := StrReplace(NPC_Bond, "{NOUNAbstractRemoved}", NOUNAbstractRemoved)
						NPC_Quirk := StrReplace(NPC_Quirk, "{NOUNAbstractRemoved}", NOUNAbstractRemoved)
						NPC_Ideal := StrReplace(NPC_Ideal, "{NOUNAbstractRemoved}", NOUNAbstractRemoved)
					}
				}
				If (InStr(NPC_Goal, "{Anatomy}")) || If (InStr(NPC_Flaw, "{Anatomy}")) || If (InStr(NPC_Bond, "{Anatomy}")) || If (InStr(NPC_Ideal, "{Anatomy}")) || If (InStr(NPC_Quirk, "{Anatomy}"))
				{
					Loop, Read, %LootDir%\Misc\Anatomy.ini
						Anatomy_Lines = %A_Index%
					Random, AnatomysRndLine, 1, %Anatomy_Lines%
					FileReadLine, Anatomy, %LootDir%\Misc\Anatomy.ini, AnatomysRndLine
					;NPC_AnatomyReplacements:
					{
						NPC_Goal := StrReplace(NPC_Goal, "{Anatomy}", Anatomy)
						NPC_Flaw := StrReplace(NPC_Flaw, "{Anatomy}", Anatomy)
						NPC_Bond := StrReplace(NPC_Bond, "{Anatomy}", Anatomy)
						NPC_Quirk := StrReplace(NPC_Quirk, "{Anatomy}", Anatomy)
						NPC_Ideal := StrReplace(NPC_Ideal, "{Anatomy}", Anatomy)
					}
				}
				If (InStr(NPC_Goal, "{COLOR}")) || If (InStr(NPC_Flaw, "{COLOR}")) || If (InStr(NPC_Bond, "{COLOR}")) || If (InStr(NPC_Ideal, "{COLOR}")) || If (InStr(NPC_Quirk, "{COLOR}"))
				{
					Loop, Read, %A_ScriptDir%\Loot\Banks\.Colors.ini
						COLOR_Lines = %A_Index%
					Random, COLORsRndLine, 1, %COLOR_Lines%
					FileReadLine, COLOR, %A_ScriptDir%\Loot\Banks\.Colors.ini, COLORsRndLine

					;NPC_COLORReplacements:
					{
						NPC_Goal := StrReplace(NPC_Goal, "{COLOR}", COLOR)
						NPC_Flaw := StrReplace(NPC_Flaw, "{COLOR}", COLOR)
						NPC_Bond := StrReplace(NPC_Bond, "{COLOR}", COLOR)
						NPC_Quirk := StrReplace(NPC_Quirk, "{COLOR}", COLOR)
						NPC_Ideal := StrReplace(NPC_Ideal, "{COLOR}", COLOR)
					}
				}
				If (InStr(Loot, "{Table-"))
				{
					Table0 := StrSplit(Loot, "{Table-")
					Table := Table0.2
					Table := StrReplace(Table, "}")
					;Msgbox %Table%
					TableDir = %Dir%\Banks\Tables\%Table%.txt
					Array := []
					ArrayCount := 0

					Loop, Read, %TableDir%
					{
						ArrayCount += 1
						Array.Push(A_LoopReadLine)
					}
					;StartRange:
					{
						StartLine = % Array[1]
						StartLine := StrSplit(StartLine, A_Tab)
						Start := StartLine.1

						Start := StrSplit(Start, "-")
						StartRange := Start.1
					}

					;EndRange:
					{
						EndLine = % Array[ArrayCount]
						EndLine := StrSplit(EndLine, A_Tab)
						End := EndLine.1

						If (InStr(End, "-"))
						{
							End := StrSplit(End, "-")
							EndRange := End.2
						}
						Else
							EndRange = %End%

						If(EndRange = "00")
							EndRange = 100
						;Msgbox %StartRange% goes to %EndRange%
					}

					Random, TableRoll, %StartRange%, %EndRange%
					for index, element in Array
					{
						EndLine = % Array[index]
						EndLine := StrSplit(EndLine, A_Tab)
						End := EndLine.1

						End := StrSplit(End, "-")
						StartRange := End.1
						EndRange := End.2

						If(EndRange = "00")
							EndRange = 100

						;MsgBox % "Element number " . index . " is " . element
						;Msgbox %StartRange%
						;Msgbox %TableRoll%

						If (TableRoll <= StartRange)
						{
							;Line = %element%
							element := RegExReplace(element, "[0-9]")
							element := Trim(element, "`t-")
							;Goto, EscapeArray
						}
					}
					;EscapeArray:
					Loot := RegexReplace(Loot, "{Table.+}", element)
				}
			}

			;Replaced_NPCGen:
			{
				Quirks = ~They have a recognizable %NPC_Quirk%
			}

			;Output:
			{
				;If FileExist(LastFile_0)	;not sure if needed
				;{
				Random, LastA, 1, 2
				;Msgbox %LastA%
				if (LastA = "1")
				{
					NameArray := []
					NameArray%A_Index% = %First% %Last_1%%Last_2b%
				}
				if (LastA = "2")
				{
					;Loop, Read, %LastFile_0%
					NameArray%A_Index% = %First% %Last_0%
				}
			}
		}
		return
	}

UpdateIni()
{
	global
	RunCount++
	IniWrite, %RunCount%, %Ini%, Names, RunCount
return
}

; ============================================================================ #
;# FoundryImport
FoundryImport()
{
	global
	SleepDur = 50
	;ImgPath = %random_file%
	;Msgbox %ImgPath%

	NPC_Body = <h1>- %NPC_Family%<br><br>- %Traits%<br><br>- %NPC_Goal%<br><br>- Has a %NPC_Quirk%
	FoundryImage = moulinette/tiles/custom/TOHP/Tokens/NPC/Sapient/%Race%/%FullGender%/%FoundryName%.webp
	SaveToClip:="K:\Documents\Foundry\Data\" StrReplace(StrReplace(FoundryImage, "/", "\"), """")
	Clipboard:=SaveToClip
	Run, %ImgPath%
	Run, "%ExportDir%\.NewBorder.pdn"
	Msgbox Copied to clipboard:`n%Clipboard%`n`nClick OK when ready to import into Foundry.

	Macro=		;FoundryMacro
	(
		const folder = game.folders.getName("Imported");
		if (folder === undefined) {
		Folder.create({name: "Imported", type: "Actor"})
		const folder = game.folders.getName("Imported");
		}
		
		const img = "%FoundryImage%"; 
		const actor = await Actor.create({ 
		  name: "%FoundryName%", 
		  type: "npc", 
		  img: img, 
		 folder: folder, 
		"system.abilities.str.value": %STR%, 
		"system.abilities.dex.value": %DEX%, 
		"system.abilities.con.value": %CON%, 
		"system.abilities.int.value": %INT%, 
		"system.abilities.wis.value": %WIS%, 
		"system.abilities.cha.value": %CHA%,
		"system.details.biography.value": "%NPC_Body%",
		  prototypeToken: { 
		    texture: { 
		      src: img, 
		      scaleX: 1.2, 
		      scaleY: 1.2 
		    }, 
		    width: 1.2, 
		    height: 1.2 
		  } 
		});
		
		const comRaces=game.packs.get("world.races")
		const Race=comRaces.getName("%Race%")
		await actor.createEmbeddedDocuments('Item', [Race.toObject()])
	)
	Clipboard = %Macro%
	Msgbox Paste Clipboard into Foundry macro to generate "%FoundryName%". Click OK to move original image out of main repo.
	Sleep 1000
	FileMove, %ImgPath%, %ExportDir%\.Saved\BaseImg\%Race%\%FullGender%\%FoundryName%.*
	return
}

ChangeAvatar()
{
	global
	ImageGUI()
	GuiControl,, Avatar, *h-1 *w685 %random_file%
	return
}

ChangeRace()
{
	global
	GuiControl, Text, Race
	Sleep 100, Race := "All"	
	SettingModifiers()
	GuiControl, Text, Race, %FullGender% %Race%
	ChangeAvatar()
	return
}

ChangeRole()
{
	global
	GuiControl, Text, Role
	Sleep 100, Role := ""
	NPC()
	GuiControl, Text, Role, %NPC_Role%
	return
}

ChangeClass()
{
	global
	GuiControl, Text, Class
	Sleep 100, Class := ""
	ChangeStats()
	GuiControl, Text, Class, Level %NPC_Level% // %NPC_Class%
	return
}

ChangeStats()
{
	global
	NPC()
	;Saving Throws
	GuiControl, Text, STR_s, %STR_mod%%STR_s%
	GuiControl, Text, DEX_s, %DEX_mod%%DEX_s%
	GuiControl, Text, CON_s, %CON_mod%%CON_s%
	GuiControl, Text, INT_s, %INT_mod%%INT_s%
	GuiControl, Text, WIS_s, %WIS_mod%%WIS_s%
	GuiControl, Text, CHA_s, %CHA_mod%%CHA_s%
	;AbilityScores
	GuiControl, Text, STR, STR`n%STR%
	GuiControl, Text, DEX, DEX`n%DEX%
	GuiControl, Text, CON, CON`n%CON%
	GuiControl, Text, INT, INT`n%INT%
	GuiControl, Text, WIS, WIS`n%WIS%
	GuiControl, Text, CHA, CHA`n%CHA%
return
}

ChangeFamily()
{
	global
	GuiControl, Text, Family
	Sleep 100, Family := ""
	NPC()
	Generate()
	GuiControl, Text, Family, %NPC_Family%
	return
}
ChangeTrait()
{
	global
	GuiControl, Text, Trait
	Sleep 100, Trait := ""
	NPC()
	Generate()
	GuiControl, Text, Trait, %Traits%
	return
}
ChangeGoal()
{
	global
	GuiControl, Text, Goal
	Sleep 100, Goal := ""
	NPC()
	Generate()
	GuiControl, Text, Goal, %NPC_Goal%
	return
}
ChangeQuirk()
{
	global
	GuiControl, Text, Quirk
	Sleep 100, Quirk := ""
	NPC()
	Generate()
	GuiControl, Text, Quirk, Has a %NPC_Quirk%
	return
}
ChangeEquipment()
{
	global
	GuiControl, Text, Equipment
	Sleep 100, Equipment := ""
	NPC()
	Generate()
	GuiControl, Text, Equipment, Equipped w/ %NPC_Weapons%, %NPC_Armor%
	return
}
ChangeBody()
{
	ChangeFamily()
	ChangeTrait()
	ChangeGoal()
	ChangeQuirk()
	ChangeEquipment()
	return
}
ChangeNames()
{
	global
	GuiControl, Text, Name1
	GuiControl, Text, Name2
	GuiControl, Text, Name3
	Sleep 100, Name1 := ""
	Generate()
	GuiControl, Text, Name1, %NameArray1%
	GuiControl, Text, Name2, %NameArray2%
	GuiControl, Text, Name3, %NameArray3%
	return
}

FoundryName1()
{
	global
	FoundryName = %NameArray1%
	FoundryImport()
}

FoundryName2()
{
	global
	FoundryName = %NameArray2%
	FoundryImport()
}

FoundryName3()
{
	global
	FoundryName = %NameArray3%
	FoundryImport()
}

SettingsRead()
{
	global
	IniRead, PlayerCount, %Ini%, Settings, PlayerCount
	IniRead, PlayerLevel, %Ini%, Settings, PlayerLevel
	IniRead, CRLevel, %Ini%, Settings, CRLevel
	IniRead, Environment, %Ini%, Settings, Environment
	IniRead, Gender, %Ini%, Settings, Gender
	IniRead, Race, %Ini%, Settings, Race
	IniRead, Taxonomy, %Ini%, Settings, Taxonomy
	IniRead, Class, %Ini%, Settings, Class
	
}

SettingsPage()
{
	global
	SettingsRead()
	;Gui, GenGUI:Hide
	Gui, Settings:New
	Gui, Settings:Color, 050505
	Gui +LastFound
	Gui, Settings:-Caption

	IniRead, PlayerCount, %Ini%, Settings, PlayerCount
	IniRead, PlayerLevel, %Ini%, Settings, PlayerLevel

	;Icons
	Gui, Settings:Add, Picture, x520 y40 w36 h-1 BackgroundTrans gButtonSave, %Bin%\Icons\Save.png
	Gui, Settings:Add, Picture, x490 y480 w96 h-1 BackgroundTrans gButtonDonate, %Bin%\Icons\supportmepls.png

	;Headers
	Gui, Settings:Add, Picture, x180 y0 w228 h-1 BackgroundTrans, %Bin%\Icons\SettingsHeader.png
	HeaderMar:=30
	Gui, Settings:Font, s16 Centaur bold
	Gui, Settings:Add, Text, cWhite BackgroundTrans x%HeaderMar% y100 center, [ Game Settings ]
	Gui, Settings:Add, Text, cWhite BackgroundTrans x%HeaderMar% y270 center, [ Generator Settings ]

	;Settings
	Gui, Settings:Font, s12 Centaur
	Gui, Add, Edit, x150 y135 w40, %PlayerCount%
	Gui, Add, Edit, x150 y165 w40, %PlayerLevel%
	Gui, Add, DropdownList, x120 y195 w80 vCRLevel, CR||Level
	Gui, Add, DropdownList, x150 y225 w120 vEnvironment, All||Aquatic|Desert|Flight|Foreign|Forest|Futuristic|Mountains|Space|Temperate|Tropical|Tundra|Underdark
	Gui, Add, DropdownList, x110 y305 w80 vGender, %Gender%||Any|M|F
	Gui, Add, DropdownList, x90 y335 w140 vRace, %Race%||All|Aarakocra|Aasimar|Arboren|Autognome|Beastiary|Bugbear|Centaur|Cervan|Changeling|Construct|Deity|Dhampir|Djinn|Dragonborn|Drow|Duergar|Dwarf|Eladrin|Elemental|Elf|Fairy|Fiend|Finrin|Firbolg|Floran|Gallus|Genasi|Giant|Giff|Githyanki|Githzerai|Gnoll|Gnome|Goblin|Goliath|Gorgon|Grung|Hadozee|Half-Dwarf|Half-Elf|Half-Giant|Half-Orc|Halfling|Harengon|Hedge|Hexblood|Hobgoblin|Human|Illithid|Kalashtar|Kender|Kenku|Khenra|Kobold|Kor|Leonin|Locathah|Loxodon|Luma|Lupin|Mapach|Merfolk|Minotaur|Misc|Myconid|Necromancer|Nycter|Ogre|Orc|Owlin|Plasmoid|Porcein|Rhox|Satyr|Scurrian|Shadar-Kai|Shifter|Simic|Siren|Skaven|Squaloan|Supernatural|Tabaxi|Thri-Kreen|Tiefling|Tortle|Troll|Undead|Ursine|Vedalken|Verdan|Warforged|Warlock|Whalekin|Wizard|Yuan-Ti
	Gui, Add, DropdownList, x130 y365 w110 vTaxonomy, All||Alien |Elemental|Fish|Flora|Homebrew|Human|Insect|Mammal|Reptile|Supernatural
	Gui, Add, DropdownList, x110 y395 w110 vNPC_Class, All||Artificer|Barbarian|Bard|Cleric|Druid|Fighter|Monk|Mystic|Paladin|Ranger|Rogue|Sorcerer|Warlock|Wizard|
	Gui, Settings:Add, Text, cWhite BackgroundTrans x%HeaderMar% y140 center, Player Count =
	Gui, Settings:Add, Text, cWhite BackgroundTrans x%HeaderMar% y170 center, Player Level =
	Gui, Settings:Add, Text, cWhite BackgroundTrans x%HeaderMar% y200 center, CR/Level =
	Gui, Settings:Add, Text, cWhite BackgroundTrans x%HeaderMar% y230 center, Environment =
	Gui, Settings:Add, Text, cWhite BackgroundTrans x%HeaderMar% y310 center, Gender =
	Gui, Settings:Add, Text, cWhite BackgroundTrans x%HeaderMar% y340 center, Race =
	Gui, Settings:Add, Text, cWhite BackgroundTrans x%HeaderMar% y370 center, Taxonomy =
	Gui, Settings:Add, Text, cWhite BackgroundTrans x%HeaderMar% y400 center, Class =

	;Support
	Gui, Settings:Add, Text, cWhite BackgroundTrans x390 y520 w96 center gButtonDonate, Support me on Patreon!
	return
	
	ButtonSave:
	Gui, Settings:Submit
	IniWrite, %PlayerCount%, %Ini%, Settings, PlayerCount
	IniWrite, %PlayerLevel%, %Ini%, Settings, PlayerLevel
	IniWrite, %CRLevel%, %Ini%, Settings, CRLevel
	IniWrite, %Environment%, %Ini%, Settings, Environment
	IniWrite, %Gender%, %Ini%, Settings, Gender
	IniWrite, %Race%, %Ini%, Settings, Race
	IniWrite, %Taxonomy%, %Ini%, Settings, Taxonomy
	IniWrite, %Class%, %Ini%, Settings, Class
	;Run, %INI%	;Debugging
	Reload
	return

	ButtonDonate:
	Run, https://patreon.com/
	return
}

; ============================================================================ #
;# Hotkeys

;Hotkeys:
{
	Escape::
	{
		Start()
	return
	}
	+Escape::ExitApp
}