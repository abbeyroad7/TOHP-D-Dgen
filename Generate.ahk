Version = v3.5.3
;sampling=40 cfg=6

;# Todo
;Suggested alternative name buttons
;Loot piles - script to move images to Session folder for piles
;sfw words

;# Public release
;Default local paths
;Ini setting for first startup, ask user to set paths
;Hover over tooltips for commercial release

;Item diversity
;Two-headed trolls, cyclops
;Ages
;Scenes
;Maps

;# Not working
;Harengon, females have head hair

Import:
{
	#Requires AutoHotkey v1.1+
	#NoEnv
	#SingleInstance Force
	#Persistent
	DetectHiddenWindows, On
	SetTitleMatchMode, RegEx
	
	WinClose, GenGUI
	
	Vars:
	{		
		GameMode = DND	;DND or CIV5
		
		If (GameMode = "DND")
			SaveDir = K:\Documents\Foundry\Data\moulinette\tiles\custom\TOHP\Tokens\Homebrew
		If (GameMode = "CIV5")
			SaveDir = E:\Documents\My Games\Sid Meier's Civilization V\MODS\Mods\RandomLeaders\Art
		
		Clothes = 1
		PromptGender = 0
		Rand:="", Type:="", SkipSaveDir:="false"
		NPCDir = %A_ScriptDir%\Loot\Banks\NPC
		NameDir = %A_ScriptDir%\Names
		GenSettings = %NameDir%\GenSettings.ini
		Sapient_SaveDir = %SaveDir%\Sapient
		Items_SaveDir = %SaveDir%\Items
		Beast_SaveDir = %SaveDir%\Beasts
		Scenes_SaveDir = %SaveDir%\Scenes
		
		A_d = {Alt Down}
		A_u = {Alt Up}
		C_d = {Control Down}
		C_u = {Control Up}
		S_d = {Shift Down}
		S_u = {Shift Up}
		CS_d = %C_d%%S_d%
		CS_u = %C_u%%S_u%
		Copy = %C_d%c%C_u%
		Paste = %C_d%v%C_u%
		Location := MeasureScreen(Location)
		SkipPress = 0
	}
	
	IconChange:
	{
		I_Icon = %A_ScriptDir%\Libraries\Icons\Generate.png
		ICON [I_Icon]                        ;Changes a compiled script's icon (.exe)
		if I_Icon <>
		IfExist, %I_Icon%
			Menu, Tray, Icon, %I_Icon%   ;Changes menu tray icon 
	}
	
	Features:
	{
		Random, ClassOrRole, 1, 7
		if ClassOrRole between 1 and 7
			ClassRole = Clothes
		if ClassOrRole between 8 and 10
			ClassRole = Classes

		If (GameMode = "DnD")
			GenerateDensity = GenerateDensity.txt
		If (GameMode = "CIV5")
			GenerateDensity = CIV5GenerateDensity.txt
	
		Loop, Read, %NPCDir%\%ClassRole%.ini
			Roles_Lines = %A_Index%
		Loop, Read, %NPCDir%\Classes.ini
			Classes_Lines = %A_Index%
		Loop, Read, %A_ScriptDir%\Loot\Banks\%GenerateDensity%
			Races_Lines = %A_Index%
	}
}

Prompt:
{
	IniRead, Gender, %GenSettings%, General, Gender
	if (Gender = "none")
	{
		Random, MF, 1, 100
		if MF between 1 and 50
			Gender = male
		if MF between 51 and 100
			Gender = female
	}
	
	IniRead, Race, %GenSettings%, General, Race
	
}

Start:
{
	Randomize:
	{
		If (Race = "none")
		{
			Random, RolesRnd, 1, Roles_Lines
				FileReadLine, Role, %NPCDir%\%ClassRole%.ini, RolesRnd
			Random, RacesRnd, 1, Races_Lines
				FileReadLine, Race, %A_ScriptDir%\Loot\Banks\%GenerateDensity%, RacesRnd
		}
		
		If (GameMode = "DnD")
		{
			IterationCompare:
			{
				IniRead, Debug, %GenSettings%, General, Debug
				If (%Debug% = 0)
				{
					IniRead, Iteration, %GenSettings%, General, Iteration
					Count := -1
					Loop, 15
					{
						Count += 1
						IniRead, Iteration_Index, %GenSettings%, IterationHistory, %Count%
						;Msgbox %Iteration_Index%

						If (Race = Iteration_Index)
						{
							Msgbox,,, Skipped %Race%,0.5
							Random, RacesRnd, 1, Races_Lines
							FileReadLine, Race, %A_ScriptDir%\Loot\Banks\%GenerateDensity%, RacesRnd
						}
					}
				}
			}
		}
		
		Random, RolesRnd, 1, Roles_Lines
			FileReadLine, Role, %NPCDir%\%ClassRole%.ini, RolesRnd
	}
	
	RaceBuilder:
	{
		RaceDir = %NameDir%\%Race%\Generate
		BeastDir = %NameDir%\Beastiary
		ItemsDir = %NameDir%\Items
		ScenesDir = %NameDir%\Scenes
	}
	
	Replacers:
	{
		Type = Sapient
		If (Race = "Beastiary") || If (Race = "Beast")
		{
			Loop, Read, %BeastDir%\%GenerateDensity%
				Races_Lines = %A_Index%
			Random, RacesRnd, 1, Races_Lines
				FileReadLine, Race, %BeastDir%\%GenerateDensity%, RacesRnd
			RaceDir = %BeastDir%\%Race%
			Type = Beast
		}
		If (Race = "Item") || If (Race = "Items")
		{
			Loop, Read, %ItemsDir%\%GenerateDensity%
				Races_Lines = %A_Index%
			Random, RacesRnd, 1, Races_Lines
				FileReadLine, Race, %ItemsDir%\%GenerateDensity%, RacesRnd
			RaceDir = %ItemsDir%\%Race%
			Type = Items
		}
		If (Race = "Scenes")
		{
			Loop, Read, %ScenesDir%\GenerateDensity.txt
				Races_Lines = %A_Index%
			Random, RacesRnd, 1, Races_Lines
				FileReadLine, Race, %ScenesDir%\GenerateDensity.txt, RacesRnd
			RaceDir = %ScenesDir%\%Race%
			Type = Scenes
		}
		If (Race = "CIV5")
		{
			Loop, Read, %NameDir%\CIV5\GenerateDensity.txt
				Races_Lines = %A_Index%
			Random, RacesRnd, 1, Races_Lines
				FileReadLine, Race, %NameDir%\CIV5\GenerateDensity.txt, RacesRnd
			RaceDir = %NameDir%\CIV5\%Race%
			Type = Scenes
		}
		
		;SubCategory search
		If (InStr(Race, "."))
		{
			Category := StrSplit(Race, ".")
			Race := Category.2	;Set subcategory to 'race' var
			Type := Category.1	;Set category for dir
			StringUpper, Race, Race, T
			
			If (Type = "Item")
				RaceDir = %ItemsDir%\%Race%
				
			If (Type = "Scene")
				RaceDir = %ScenesDir%\%Race%
				
			If (Type = "Beast")
				RaceDir = %BeastDir%\%Race%
		}
		
		RaceSettings:
		{
			IniRead, SkinType, %RaceDir%\RaceSettings.ini, General, SkinType
			IniRead, Descriptor, %RaceDir%\RaceSettings.ini, General, Descriptor
			IniRead, Clothes, %RaceDir%\RaceSettings.ini, General, Clothes, 1
			IniRead, PromptGender, %RaceDir%\RaceSettings.ini, General, PromptGender, 0
		}
		SkinColor:
		{
			Loop, Read, %RaceDir%\SkinColor.txt
				SkinColor_Lines = %A_Index%
			Random, SkinColorRnd, 1, SkinColor_Lines
				FileReadLine, SkinColor, %RaceDir%\SkinColor.txt, SkinColorRnd
		}
		HairColor:
		{
			Loop, Read, %RaceDir%\HairColor.txt
				HairColor_Lines = %A_Index%
			Random, HairColorRnd, 1, HairColor_Lines
				FileReadLine, HairColor, %RaceDir%\HairColor.txt, HairColorRnd
		}
		SubTypes:
		{
			Loop, Read, %RaceDir%\Subtypes.txt
				Subtypes_Lines = %A_Index%
			Random, SubtypesRnd, 1, Subtypes_Lines
				FileReadLine, Subtype, %RaceDir%\Subtypes.txt, SubtypesRnd
		}
		Color:
		{
			Loop, Read, %RaceDir%\Color.txt
				Colors_Lines = %A_Index%
			Random, ColorsRnd, 1, Colors_Lines
				FileReadLine, Color, %RaceDir%\Color.txt, ColorsRnd
		}
		Background:
		{
			IniRead, Background, %RaceDir%\RaceSettings.ini, General, Background
			If (Type = "Item") || If (Type = "Items")
				Background = black gradient background
			If (Background = "ERROR")
			{
				IniRead, BackgroundFile, %RaceDir%\RaceSettings.ini, General, BackgroundFile
				If (BackgroundFile = "ERROR")
				{
					If (Type = "Beast")		;Outdoor BGini
						BGIni = %NPCDir%\OutdoorBackgrounds.ini
					Else
						BGIni = %NPCDir%\Backgrounds.ini
				}
				Else
					BGIni = %NPCDir%\%BackgroundFile%.ini
				
				Loop, Read, %BGIni%
					Backgrounds_Lines = %A_Index%
				Random, BackgroundsRnd, 1, Backgrounds_Lines
					FileReadLine, Background, %BGIni%, BackgroundsRnd
			}
			If (Background = "0")	;Use per line backgrounds
				Background := ""
		}
		EyeColor:
		{
			Loop, Read, %RaceDir%\EyeColor.txt
				EyeColor_Lines = %A_Index%
			Random, EyeColorRnd, 1, EyeColor_Lines
				FileReadLine, EyeColor, %RaceDir%\EyeColor.txt, EyeColorRnd
		}
		Expression:
		{
			Loop, Read, %NPCDir%\Expressions.ini
				Expressions_Lines = %A_Index%
			Random, ExpressionsRnd, 1, Expressions_Lines
				FileReadLine, Expression, %NPCDir%\Expressions.ini, ExpressionsRnd
		}
		Clothes:
		{
			Outfit =  in a ({Role} outfit:1.1)
			if Clothes = 0
				Outfit := []
		}
		Gender:
		{
			if Race = deity
				Gender := []
			
			Loop, Read, %RaceDir%\Gender.txt
				Gender_Lines = %A_Index%
			Random, GenderRnd, 1, Gender_Lines
				FileReadLine, PromptGender, %RaceDir%\Gender.txt, GenderRnd
		}
		Noun:
		{
			Random, NounsRnd, 1, 6
			Loop, Read, %A_ScriptDir%\Loot\Banks\Nouns\Nouns%NounsRnd%.txt
				Noun_Lines = %A_Index%
			Random, NounsRndLine, 1, %Noun_Lines%					
			FileReadLine, Noun, %A_ScriptDir%\Loot\Banks\Nouns\Nouns%NounsRnd%.txt, NounsRndLine
		}
		NounAbstractRemoved:
		{
			Loop, Read, %A_ScriptDir%\Loot\Banks\Nouns\NounsAbstractRemoved.txt
				NounAR_Lines = %A_Index%
			Random, NounsARRndLine, 1, %NounAR_Lines%					
			FileReadLine, NounAR, %A_ScriptDir%\Loot\Banks\Nouns\NounsAbstractRemoved.txt, NounsARRndLine
		}
		
		If (GameMode = "DnD")
		{
			MainPrompt = {Gender} ({Descriptor}:1.2) %Outfit%, {Background} background
			PromptSuffix = (detailed) (8k) (HDR) (sharp focus), good eyes, symmetric face, photoshoot style, intricate, cinematic lighting, realistic	;Sana
			;PromptSuffix = (detailed) (8k) (HDR) (sharp focus), good eyes, symmetric face, photoshoot style, intricate, cinematic lighting, realistic	;SDXL
		}
		If (GameMode = "CIV5")
		{
			MainPrompt = A realistic oil painting of a {CIV5Eras} {Gender} {CIV5Leader} ({Descriptor}:1.2), standing in a {CIV5Backgrounds} background
			PromptSuffix = (detailed) (8k) (HDR) (sharp focus), good eyes, good hands, good legs, symmetric face, intricate, cinematic lighting, realistic
		}
		
		If (Type = "Items") || If (Type = "Item")		;Overwrite MainPrompt if var
		{
			MainPrompt = {Descriptor}
			PromptSuffix = %Background%, (detailed) (8k) (HDR) (sharp focus), photoshoot style, intricate, cinematic lighting, realistic
		}
		If (Type = "Beast")
		{
			MainPrompt = {Descriptor}, {Background} background
			PromptSuffix = (detailed) (8k) (HDR) (sharp focus), good eyes, intricate, nature photography, cinematic lighting, realistic
		}
		If (Type = "Scenes")
		{
			MainPrompt = {Descriptor}
			PromptSuffix = (detailed) (8k) (HDR) (sharp focus), photoshoot style, intricate, cinematic lighting, realistic
		}
		
		if PromptGender = 1
			Gender := []
		
		SubType_SaveDir:
		{
			If (InStr(SubType, "`t"))
			{
				SubtypeArray := StrSplit(Subtype, "`t")
				SubType := SubTypeArray.2
				SuffixDir := SubTypeArray.1
				;Msgbox %SuffixDir%
			}
			Else
				SuffixDir := ""
		}
		
		Replacements:
		{
			MainPrompt := StrReplace(MainPrompt, "{Gender}", Gender)
			MainPrompt := StrReplace(MainPrompt, "{Descriptor}", Descriptor)
			MainPrompt := StrReplace(MainPrompt, "{Subtype}", Subtype)
			MainPrompt := StrReplace(MainPrompt, "{SkinType}", SkinType)
			MainPrompt := StrReplace(MainPrompt, "{SkinColor}", SkinColor)
			MainPrompt := StrReplace(MainPrompt, "{HairColor}", HairColor)
			MainPrompt := StrReplace(MainPrompt, "{Color}", Color)
			MainPrompt := StrReplace(MainPrompt, "{Role}", Role)
			MainPrompt := StrReplace(MainPrompt, "{Background}", Background)
			MainPrompt := StrReplace(MainPrompt, "{EyeColor}", EyeColor)
			MainPrompt := StrReplace(MainPrompt, "{Expression}", Expression)
			MainPrompt := StrReplace(MainPrompt, "{Noun}", Noun)
			MainPrompt := StrReplace(MainPrompt, "{NounAR}", NounAR)
		}

		Loop 		;CheckForFurtherReplacements
		{
			If (InStr(MainPrompt, "{") || InStr(MainPrompt, "}"))
			{
				RegexMatch(MainPrompt, "\{(.*?)\}", TagMatch)
				Loop, Read, %A_ScriptDir%\Loot\Banks\%TagMatch1%.ini
				Lines = %A_Index%
				Random, RndLine, 1, %Lines%					
				FileReadLine, Tag, %A_ScriptDir%\Loot\Banks\%TagMatch1%.ini, RndLine

				MainPrompt := RegexReplace(MainPrompt, "\{" TagMatch1 "\}", Tag)
				;Msgbox %MainPrompt%
			}
			Else
				Break
		}
	}
	
	Filename = %Race%-%Gender%
	Output = %MainPrompt%
	
	Clipboard = %Output%, %PromptSuffix%
	
	TabCounter:
	{
		IniRead, CurrentTab, %GenSettings%, Tabs, CurrentTab
		CurrentTab += 1
		If (CurrentTab > 3)
			CurrentTab := 1
		BackTab := CurrentTab - 1
		If (BackTab = 0)
			BackTab := 3
		TabNext := CurrentTab + 1
		If (TabNext > 3)
			TabNext := 1

		IniWrite, %CurrentTab%, %GenSettings%, Tabs, CurrentTab
		IniWrite, %Race%, %GenSettings%, Tabs, Tab%CurrentTab%_Race
		IniWrite, %Gender%, %GenSettings%, Tabs, Tab%CurrentTab%_Gender
		IniWrite, %Color%, %GenSettings%, Tabs, Tab%CurrentTab%_Color
		IniWrite, %SubType%, %GenSettings%, Tabs, Tab%CurrentTab%_Sub
		IniWrite, %SkinColor%, %GenSettings%, Tabs, Tab%CurrentTab%_Skin
		IniWrite, %Type%, %GenSettings%, Tabs, Tab%CurrentTab%_Type
		IniWrite, %SuffixDir%, %GenSettings%, Tabs, Tab%CurrentTab%_Suffix

		IniRead, TabCurrent_Race, %GenSettings%, Tabs, Tab%CurrentTab%_Race
		IniRead, TabBack_Race, %GenSettings%, Tabs, Tab%BackTab%_Race
		IniRead, TabNext_Race, %GenSettings%, Tabs, Tab%TabNext%_Race
	}
	
	Sana_UI:
	{
		WinActivate, Sana
		WinWait, Sana
		Send {Home}
		
		If (Location = "Home")	;Prompt
			Mouseclick, left, 916, 398
		If (Location = "Away")
			Mouseclick, left, 671, 330
		If (Location = "Tablet")
			Mouseclick, left, 637, 367
			
		Sleep 50
		Send %C_d%a%C_u%
		Sleep 50
		Send %Paste%{Home}
		
		If (Location = "Home")	;Run
			MouseMove, 1575, 395
		If (Location = "Away")
			MouseMove, 1193, 334
		If (Location = "Tablet")
			MouseMove, 1193, 370	
		;Msgbox %Race%`n`n%Output%
	}
	
	GenGUI:
	{	
		RaceColor:
		{
			RaceColor = White	;Default
			
			If (Race = "Necromancer")
				RaceColor = White
			If (Race = "Undead")
				RaceColor = Red
			If (Race = "Ursine") || If (Race = "Arboren") || If (Race = "Halfling") || If (Race = "Owlin")
				RaceColor = 895129	;Brown
			If (Race = "Giant") || If (Race = "Ogre") || If (Race = "Orc") || If (Race = "Troll") || If (Race = "Goblin") || If (Race = "Kobold") || If (Race = "Dragonborn") || If (Race = "Floran")
				RaceColor = Green
			If (Race = "Fairy") || If (Race = "Giff") || If (Race = "Porcein")
				RaceColor = ff66cc
			If (Race = "Hexblood") || If (Race = "Warlock") || If (Race = "Kenku")
				RaceColor = Purple
			If (Race = "Wizard") || If (Race = "Luma") || If (Race = "Vedalken")
				RaceColor = Blue
			If (Race = "Dwarf") || If (Race = "Goliath") || If (Race = "Rhox") || If (Race = "Sword") || If (Race = "Armor") || If (Race = "Shield")
				RaceColor = Silver
			If (Race = "Githyanki") || If (Race = "Githzerai") || If (Race = "Grung") || If (Race = "Leonin") || If (Race = "Jewelry")
				RaceColor = Yellow
		}
		
		Gui, GenGUI:New
		Gui, GenGUI:Color, 050505
		Gui +LastFound
		WinSet, TransColor, 050505
		ImgBin = D:\Music\MusicDL\binaries

		BGImg := GUI_Backgrounds(BGImg)
		Gui, GenGUI:Add, Picture, x0 y0 w600 h400, %BGImg%
		Gui, GenGUI:Add, Picture, y10 x10 w580 h380 BackgroundTrans, %ImgBin%\Maskshape.png

		Gui, GenGUI:-Caption
		Gui, GenGUI:Font, s16 bold
		Gui, GenGUI:Add, Text, c%RaceColor% BackgroundTrans w200 x200 y20, %TabCurrent_Race%

		;Gui, GenGUI:Font, s10 normal
		;Gui, GenGUI:Add, Text, cA9A9A9 BackgroundTrans w100 x30 y27, < %TabBack_Race%
		;Gui, GenGUI:Add, Text, cA9A9A9 BackgroundTrans w100 x400 y27, %TabNext_Race% >
		
		Gui, GenGUI:Font, s14 normal
		Gui, GenGUI:Add, Picture, gcopyCurrentSave BackgroundTrans w500 h5 x20 y100, %ImgBin%\Divider.png
		;Gui, GenGUI:Add, Text, cGray BackgroundTrans w500 x20 y90, --------------------------------------------------------------------------------
		Gui, GenGUI:Add, Text, cGray BackgroundTrans w480 x20 y50 r1 r2, %Output%
		
		CheckFileCountsOnType:
		{
			Avatarcount := 0
			If (Type = "Sapient")
			{
				CheckFolder = %Sapient_SaveDir%\%Race%\%Gender%
				SuffixDir = %Gender%
			}
			If (Type = "Beast")
			{
				CheckFolder = %Beast_SaveDir%\*
			}
			If (Type = "Item") || If (Type = "Items")
			{
				CheckFolder = %Items_SaveDir%\%SuffixDir%
			}
			If (Type = "Scene")
				CheckFolder = %Scenes_SaveDir%\%Type%\%Race%

			;Msgbox % CheckFolder

			Loop, %CheckFolder%\*
			{
				if A_LoopFileAttrib contains H,R,S
					continue
				Avatarcount += 1
			}
		}

		Gui, GenGUI:Font, s12
		Gui, GenGUI:Add, Text, cGray BackgroundTrans w500 x510 y20, #%CurrentTab% %Version%
		Gui, GenGUI:Add, Text, cYellow BackgroundTrans r2 x20 y110, %Avatarcount% saved in \%SuffixDir%\
		Gui, GenGUI:Add, Text, cGray BackgroundTrans r2 x20 y140, Change Race: 1
		Gui, GenGUI:Add, Text, cGray BackgroundTrans r2 x20 y160, Safe Mode: 2
		Gui, GenGUI:Add, Text, cGray BackgroundTrans r2 x20 y180, Edit Race: 3
		Gui, GenGUI:Add, Text, cGray BackgroundTrans r2 x20 y200, Reroll: 4
		Gui, GenGUI:Add, Text, cGray BackgroundTrans r2 x20 y220, Search Tags: 5
		Gui, GenGUI:Add, Text, cGray BackgroundTrans r2 x20 y240, Debug: 6
		
		GUI_CheckAvatarImg()
		Gui, GenGUI:Add, Picture, y110 x250 h256 w256 BackgroundTrans, %Avatar%
		
		If (Debug = 0)
			Gui, GenGUI:Add, Picture, y40 x535 h24 w48 BackgroundTrans, %A_ScriptDir%\Libraries\Icons\DebugOff.png
		If (Debug = 1)
			Gui, GenGUI:Add, Picture, y40 x530 h24 w48 BackgroundTrans, %A_ScriptDir%\Libraries\Icons\DebugOn.png
			
		Gui, GenGUI:Add, CheckBox, y70 x550 h24 w24 vPin gPinGen BackgroundTrans, Pin?
		;If (PinSetting = 0)
		;	Gui, GenGUI:Add, Picture, y70 x550 h24 w24, %A_ScriptDir%\Libraries\Icons\PinOff.png
		;If (PinSetting = 1)
		;	Gui, GenGUI:Add, Picture, y70 x550 h24 w24, %A_ScriptDir%\Libraries\Icons\PinOn.png

		Gui, GenGUI:Add, Edit, vLauncher x20 y270 BackgroundTrans ; Add a v before variable name.
		Gui, GenGUI:Add, Button, default gButtonOK x20 y310 BackgroundTrans, OK  ; The label ButtonOK (if it exists) will be run when the button is pressed.
		
		If (Location = "Home")
		{
			Gui, GenGUI:Show, w600 h400 x1750, GenGUI
			;WinSet, AlwaysOnTop, On, GenGUI
		}
		If (Location = "Away")
			Gui, GenGUI:Show, w600 h400 x1250, GenGUI
		
		If (Location = "Tablet")
			Gui, GenGUI:Show, w600 h400 x1250, GenGUI
		
		IniRead, PinSetting, %GenSettings%, General, Pin
		If (PinSetting = 0)
			Winset, Alwaysontop, Off, GenGUI
		If (PinSetting = 1)
			Winset, Alwaysontop, On, GenGUI
		
		return  ; End of auto-execute section. The script is idle until the user does something.
		
		GuiClose:
		PinGen:
			Winset, Alwaysontop,, GenGUI
			PinSetting := !PinSetting
			IniWrite, %PinSetting%, %GenSettings%, General, Pin
		return
		
		copyCurrentSave:
		{
			SkipPress = 1
			SaveFileName(TabNo := CurrentTab)
			Clipboard = %clipFile%
			Msgbox %clipFile%
		}
		return

		copyCurrentPrompt:
		{
			Clipboard = %Output%, %PromptSuffix%
			Msgbox %Output%, %PromptSuffix%
		}
		return

		ButtonOK:
		Gui, Submit		; Save the input from the user to each control's associated variable.
		;MsgBox You entered "%Launcher%".	;Remove v from var
			WinClose, GenGUI
			
			If (Launcher = "")
			{
				WinClose, GenGUI
				IniRead, Race, %GenSettings%, General, Race
			}
			If (Launcher = "0")
				ExitApp
			If (Launcher = "1")		;Change Race
			{
				Inputbox, Race, %Race%,,,200,100
				IniWrite, %Race%, %GenSettings%, General, Race
				IniWrite, 1, %GenSettings%, General, Debug
			}
			If (Launcher = "1c")	;Clear Settings
			{
				IniWrite, none, %GenSettings%, General, Race
				IniWrite, none, %GenSettings%, General, Gender
				IniWrite, 0, %GenSettings%, General, Debug
			}
			If (InStr(Launcher, "."))	;Clear Settings
			{
				IniWrite, %Launcher%, %GenSettings%, General, Race
				IniWrite, none, %GenSettings%, General, Gender
			}
			If (Launcher = "item")
			{
				IniWrite, Items, %GenSettings%, General, Race
				IniWrite, none, %GenSettings%, General, Gender
			}
			If (InStr(Launcher, "beast"))	;Clear Settings
			{
				IniWrite, Beast, %GenSettings%, General, Race
				IniWrite, none, %GenSettings%, General, Gender
			}
			If (InStr(Launcher, "scenes"))	;Clear Settings
			{
				IniWrite, Scenes, %GenSettings%, General, Race
				IniWrite, none, %GenSettings%, General, Gender
			}
			If (Launcher = "2")		;SafeMode
			{
				IniWrite, Male, %GenSettings%, General, Gender
			}
			If (Launcher = "3")		;Edit race
			{
				Run, %RaceDir%\RaceSettings.ini
				;Inputbox, Confirm, Open Explorer?,,,200,100
				IniWrite, %Race%, %GenSettings%, General, Race
				IniWrite, 1, %GenSettings%, General, Debug
				;If (Confirm = "y")
				;	Run, Explorer %RaceDir%
				;else
				;	return
			}
			If (Launcher = "3y")		;Edit race
			{
				Run, %RaceDir%\RaceSettings.ini
				;Inputbox, Confirm, Open Explorer?,,,200,100
				IniWrite, %Race%, %GenSettings%, General, Race
				IniWrite, 1, %GenSettings%, General, Debug
				Run, Explorer %RaceDir%
			}
			If (Launcher = "4")		;Reroll
			{
				IniWrite, %Race%, %GenSettings%, General, Race
			}
			If (Launcher = "5")		;Hinter
			{
				tagFile = %SaveDir%\.tags.txt
				InputBox, tagSearch, Enter Tags:, , , 300,100
				Count := 0
				
				Loop, Read, %tagFile%
				{
					Count = %A_Index%
					MyArray := []
					Loop, parse, A_LoopReadLine, `n`r
					{
						;Count -= 1
						If (InStr(A_LoopField, tagSearch))
						{
							FileReadLine, Race, %tagFile%, %Count%
							MyArray.Push(Race)
							
							for i,v in MyArray
							s .= "`n`n" . v
						}
					}
				}
				
				Gui, New
				Gui, Color, 050505
				Gui -Caption
				Gui, Font, s13 bold
				
				MyArrayText := substr(s, 2)
				Gui, Add, Text, cWhite, %MyArrayText%
				Gui, Show, w500
				Sleep 1500
				Gui, Destroy
				
				;Msgbox,,, % substr(s, 2), 1.5
				s := []
			}
			If (Launcher = "6")		;Debug
			{
				Gui, New
				Gui, Color, 050505
				Gui -Caption
				
				Gui, Font, s13 bold
				Gui, Add, Text, cWhite, %Location%
				
				Gui, Show, w500
				Sleep 1500
				Gui, Destroy
				
				;Msgbox,,, % substr(s, 2), 1.5
				s := []
			}
		Reload
		return
	}
	
	Reload
}

Hotkeys:
{
	#IfWinActive, Sana||Enter name of file to save to…
		!s::
		{
			If !WinActive("Enter name of file to save to")
			{
				Send {Home}
				Sleep 50

				If (Location = "Home")	;Prompt
					Mouseclick, left, 1596, 429		;save
				If (Location = "Away")	;Prompt
					Mouseclick, left, 1201, 366		;save
				If (Location = "Tablet")	;Prompt
					Mouseclick, left, 1246, 395		;save


				WinWaitActive, Enter name of file to save to
				Sleep 500
			}
			Rand := ""
			Rand := % rand(5)

			File = %Filename%-%Rand%
			SubType := RegExReplace(SubType, "[0-9.()/\\:*?""<>| ]")
			;Msgbox %Race% - %SubType%

			If (Type = "Beast")
				File = %Race%-%SubType%-%Rand%

			If (Type = "Items")
				File = %Filename%-%SubType%-%SkinColor%-%Rand%

			Clipboard := File
			Send %Paste%
			File := ""
		return
		}
		^+s::		;Alt save
		{
			Rand := ""
			Rand := % rand(5)

			Inputbox, Filename, Enter Alterate:,,,200,100
			File = %Filename%-%Rand%
			SubType := RegExReplace(SubType, "[0-9.()/\\:*?""<>| ]")
			;Msgbox %Race%

			Clipboard := File
			Send %Paste%
			File := ""
		return
		}
		!1::
		{
			TabNo := 1
			SaveFileName(TabNo)
		return
		}
		!2::
		{
			TabNo := 2
			SaveFileName(TabNo)
		return
		}
		!3::
		{
			TabNo := 3
			SaveFileName(TabNo)
		return
		}
	Return
	#IfWinActive

	;#IfWinActive, GenGUI
	Escape::
		{
			IterationCount:
			{
				IniRead, Debug, %GenSettings%, General, Debug

				If (%Debug% = 0)
				{
					IniRead, Iteration, %GenSettings%, General, Iteration

					If (Iteration < 15)
						Iteration += 1
					Else
						Iteration := 0

					IniWrite, %Iteration%, %GenSettings%, General, Iteration
					IniWrite, %Race%, %GenSettings%, IterationHistory, %Iteration%
				}
			}

			Reload
		}
	;Return
	;#IfWinActive

	+Escape::ExitApp
}

GUI_CheckAvatarImg()
{
	global
	;if FileExist(RaceDir "\Avatar.jpg")
	;{
	;	Avatar = %RaceDir%\Avatar.jpg
	;	;Msgbox %Avatar%
	;}
	;Else
	If (Gender = "none")
	{
		Random, rGender, 1, 2
		If (rGender = 1)
			Gender = Male
		If (rGender = 2)
			Gender = Female
	}
	
	;Msgbox %SaveDir%\%Race%\%Gender%

	Avatarcount := 0
	;Msgbox %SaveDir%\%Type%\%Race%\%Gender%
	;Loop, %SaveDir%\%Type%\%Race%\%Gender%\*.jpg
	;Msgbox %CheckFolder%
	Loop, %CheckFolder%\*.jpg
	{
		if A_LoopFileAttrib contains H,R,S
			continue
		Avatarcount += 1
	}
	Random, FileNumber, 1, %Avatarcount%

	Loop, Files, %CheckFolder%\*.jpg, F
	{
		;Msgbox %A_Index% %Count%
		if (A_Index > FileNumber)
		{
			Avatar = %CheckFolder%\%A_LoopFileName%
			break
		}
		;Avatarcount += 1
	}
	;Msgbox %Avatar%
	return
}


rand(len) {
	string := ""
	Global chars := "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz", clen := StrLen(chars)
	Loop, %len% {
	Random, rnd, 1, %clen%
	string .= SubStr(chars, rnd, 1)
	}
	Return string
}

MeasureScreen(Location)
{
	SysGet, Resolution, Monitor
	If (ResolutionRight = "2560") | If (ResolutionBottom = "1440")
		Location = Home
	;If (ResolutionRight = "1920") | If (ResolutionBottom = "1080")
	;	Location = Tablet
	If (ResolutionRight = "1920") | If (ResolutionBottom = "1080")
		Location = Away

	return %Location%
}

FindMatchInList(List, File)
{
	;ListTypes := StrReplace(List, ",", "`n")
	;Msgbox %Filename%
	Loop, parse, List, `,
	{
		;Msgbox %A_LoopField%
		If (InStr(File, A_LoopField))
			return %A_LoopField%
	}
	File := 
	return %File%
}

SaveFileName(TabNo)
{
	global
	Tabname:="", TabColor:="", TabGender:="", TabSubType:="", TabSkin:="", SuffixDir:=""
	
	IniRead, Tabname, %GenSettings%, Tabs, Tab%TabNo%_Race
	IniRead, TabGender, %GenSettings%, Tabs, Tab%TabNo%_Gender
	IniRead, TabColor, %GenSettings%, Tabs, Tab%TabNo%_Color
	IniRead, TabSubType, %GenSettings%, Tabs, Tab%TabNo%_Sub
	IniRead, TabSkin, %GenSettings%, Tabs, Tab%TabNo%_Skin
	IniRead, Type, %GenSettings%, Tabs, Tab%TabNo%_Type
	IniRead, SuffixDir, %GenSettings%, Tabs, Tab%TabNo%_Suffix
	
	If !WinActive("Enter name of file to save to") | If (SkipPress = 0)
		{
			Send {Home}
			Sleep 50
			
			If (Location = "Home")	;Prompt
				Mouseclick, left, 1596, 421		;save
			If (Location = "Away")	;Prompt
				Mouseclick, left, 1201, 366		;save
			If (Location = "Tablet")	;Prompt
				Mouseclick, left, 1246, 395		;save
			
			
			WinWaitActive, Enter name of file to save to
			Sleep 500
		}
		Rand := ""
		Rand := % rand(5)
		
		File = %Tabname%\%TabGender%\%Tabname%-%TabGender%-%Rand%
		FinalSaveDir = %Sapient_SaveDir%
		;FinalSaveDir = E:\Documents\My Games\Sid Meier's Civilization V\MODS\Mods\RandomLeaders\Art\Diplo
		SubType := RegExReplace(SubType, "[0-9.()/\\:*?""<>|]")
		;Msgbox %Race%
		
		If Type = Beastiary
		{
			File = %Rand%
			FinalSaveDir = %Beast_SaveDir%
		}
		
		If Race = .Random
		{
			File0 = Beast-%TabSubType%-Random-%Rand%
			List = Tiny,Small,Large,Giant,Big
			
			Remove := FindMatchInList(List, File0)
			File := StrReplace(File0, Remove " ")
			FinalSaveDir = %Beast_SaveDir%
		}
		
		If (Type = "Items") || If (Type = "Item")
		{
			File = %SuffixDir%\%Tabname%-%TabSubType%-%TabSkin%-%Rand%
			FinalSaveDir = %Items_SaveDir%
		}
		
		If (Type = "Scenes") || If (Race = "Scenes")
		{
			File = %SuffixDir%\%Tabname%-%TabSubType%-%TabSkin%-%Rand%
			FinalSaveDir = %Scenes_SaveDir%
		}

		If (GameMode = "CIV55") | If (Type = "Scenes")
		{
			File = %Tabname%-%TabColor%-%TabSubType%-%Rand%
			FinalSaveDir:="", SkipSaveDir:="true"
			File := RegExReplace(File, "[0-9.:*?""<>| ]")
			clipFile := File, Clipboard := File
		}
		
		If (SkipSaveDir="false")
		{
			File := RegExReplace(File, "[0-9.:*?""<>| ]")	;Remove special chars
			clipFile := FinalSaveDir "\" File	;saves for GUI buttons
			Clipboard := FinalSaveDir "\" File
		}

		Send %Paste%
		File := ""
		SkipPress = 0	;Reset press from GUI buttons
	return
}

GUI_Backgrounds(BGImg)
{
	BackgroundsDir := "K:\Documents\Foundry\Data\moulinette\tiles\custom\TOHP\Tokens\Homebrew\Scenes\.UI\Backgrounds\Rectangle"
	count := 0
	Loop, %BackgroundsDir%\*.jpg
	{
		if A_LoopFileAttrib contains H,R,S
			continue
		count += 1
	}
	Random, FileNumber, 1, %count%

	Loop, Files, %BackgroundsDir%\*.jpg, F
	{
		;Msgbox %A_Index% %Count%
		if (A_Index > FileNumber)
		{
			BGImg = %BackgroundsDir%\%A_LoopFileName%
			break
		}
		;count += 1
	}
	return %BGimg%
}

CompressFileName(name)
{
	Name := SubStr(Name, 1, 3)
	StringUpper, Name, Name
return %Name%
}
