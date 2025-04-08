;# Flux settings
;dark fantasy
;cfg 2.4-4.0
;
;v1.5.0
;# Todo
;Age
;# Not working
;Anthropormorphic creatures have human hair when female - bald tag
;Cervan, female needs tweaking
;Centaur, needs tweaking
;Eladrin, needs tweaking
;Elf, needs tweaking
;Half-Elf, needs tweaking
;Fairy, needs tweaking
;Firbolg
;Githyanki
;Githzerai
;Goliath needs tweaking
;Harengon, females have head hair
;Minotaur needs tweaking, doesn't accept additional variables
;Scurrian, needs more generations
;Tiefling needs testing
;Two-headed trolls, cyclops
;Finrin tusks/elephant seals

Import:
{
	#Requires AutoHotkey v1.1+
	#NoEnv
	#SingleInstance Force
	#Persistent
	DetectHiddenWindows, On
	SetTitleMatchMode, RegEx
	
	Vars:
	{		
		NPCDir = %A_ScriptDir%\Loot\Banks\NPC
		NameDir = %A_ScriptDir%\Names
		Clothes = 1
		PromptGender = 0
		Rand := ""
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
		Random, ClassOrRole, 1, 10
		if ClassOrRole between 1 and 7
			ClassRole = Clothes
		if ClassOrRole between 8 and 10
			ClassRole = Classes
	
		Loop, Read, %NPCDir%\%ClassRole%.ini
			Roles_Lines = %A_Index%
		Loop, Read, %NPCDir%\Classes.ini
			Classes_Lines = %A_Index%
		Loop, Read, %A_ScriptDir%\Loot\Banks\GenerateDensity.txt
			Races_Lines = %A_Index%
	}
}

Prompt:
{
	DebugMode = 0
	;Inputbox, Race,,,,200,100
		If InStr(Race, "db")
			{
				DebugMode = 1
				Race = human
				Gender = m
				Goto, Start
			}
		Random, MF, 1, 100
		if MF between 1 and 45
		{
			Gender = male
			ImgDir = %RaceDir%\%Race%\Male
		}
		if MF between 46 and 100
		{
			Gender = female
			ImgDir = %RaceDir%\%Race%\Female
		}
}

Start:
{
	Randomize:
	{
		If Race != "Beastiary"
		{
			Random, RolesRnd, 1, Roles_Lines
				FileReadLine, Role, %NPCDir%\%ClassRole%.ini, RolesRnd
			Random, RacesRnd, 1, Races_Lines
				FileReadLine, Race, %A_ScriptDir%\Loot\Banks\GenerateDensity.txt, RacesRnd
		}
	}
	
	RaceBuilder:
	{
		Race = Squaloan	;debug
		;Gender = male	;debug
		RaceDir = %NameDir%\%Race%\Generate
		BeastDir = %NameDir%\Beastiary
	}
	
	Replacers:
	{
		If Race = Beastiary
		{
			Loop, Read, %BeastDir%\GenerateDensity.txt
				Races_Lines = %A_Index%
			Random, RacesRnd, 1, Races_Lines
				FileReadLine, Race, %BeastDir%\GenerateDensity.txt, RacesRnd
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
			Loop, Read, %NPCDir%\Backgrounds.ini
				Backgrounds_Lines = %A_Index%
			Random, BackgroundsRnd, 1, Backgrounds_Lines
				FileReadLine, Background, %NPCDir%\Backgrounds.ini, BackgroundsRnd
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
			Outfit = in a ({Role} outfit:1.1)
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
		MainPrompt = {Gender} ({Descriptor}:1.2)%Outfit%, {Background} background
		PromptSuffix = (detailed) (8k) (HDR) (sharp focus), good eyes, photoshoot style, intricate, cinematic lighting, realistic
		
		if PromptGender = 1
			Gender := []
		
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
		}
	}
	
	IniTracker:
	{
		IniFile = %A_ScriptDir%\Libraries\Generate.ini
		IniRead, Iteration, %IniFile%, Filename, Iteration

		If (Iteration = 1) || If (Iteration = 2)
		{
			nIteration := Iteration + 1
			IniWrite, %nIteration%, %IniFile%, Filename, Iteration
		}
		If (Iteration = 3)
		{
			nIteration = 1
			IniWrite, %nIteration%, %IniFile%, Filename, Iteration
		}
		
		Tab = Tab%Iteration%
		Filename = %Race%-%Gender%-%Rand%
		IniWrite, %Filename%, %IniFile%, Filename, %Tab%
	}
	Output = %MainPrompt%
	
	Clipboard = %Output%, %PromptSuffix%
	Msgbox %Race%`n`n%Output%
	Reload
}

EndofFile:
{
	Escape::
	{
		Reload
	}
	+Escape::ExitApp
	!s::
	{
		Rand = % rand(10)
		Filename = %Filename%-%Rand%
		If Race = Beastiary
			Filename = %Rand%
		Send % Filename
	return
	}
	!1::
	{
		IniRead, Filename, %IniFile%, Filename, Tab1
		Rand = % rand(10)
		Filename = %Filename%-%Rand%
		Send % Filename
	return
	}
	!2::
	{
		IniRead, Filename, %IniFile%, Filename, Tab2
		Rand = % rand(10)
		Filename = %Filename%-%Rand%
		Send % Filename
	return
	}
	!3::
	{
		IniRead, Filename, %IniFile%, Filename, Tab3
		Rand = % rand(10)
		Filename = %Filename%-%Rand%
		Send % Filename
	return
	}
}
return

rand(len) {
	Global chars := "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz", clen := StrLen(chars)
	Loop, %len% {
	Random, rnd, 1, %clen%
	string .= SubStr(chars, rnd, 1)
	}
	Return string
}