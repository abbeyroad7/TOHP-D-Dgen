;v3.9.2
;;Todo
;Picker GUI // images of each race + random
;Change family dynamics per race, var set for sibling max, etc
;Use ImageSearch for FoundryImport
;Incorporate biography on FoundryImport
;Tagging system for races
;Queue for first/last names only
;When importing to foundry, seperate pics by race
;Merge scripts with use of an import library
Import:
{
	#Requires AutoHotkey v1.1+
	#SingleInstance Force

	IconChange:
	{
		I_Icon = C:\Program Files\AutoHotkey\Icons\Names.ico
		ICON [I_Icon]                        ;Changes a compiled script's icon (.exe)
		if I_Icon <>
		IfExist, %I_Icon%
			Menu, Tray, Icon, %I_Icon%   ;Changes menu tray icon 
	}
	ImportVars:
	{
		PlayerCount = 6
		PlayerLevel = 5
		ProficiencyBonus = 3	;3 at lvl5 https://5e.tools/tables.html#proficiency%20bonus_xphb	For npcs, not PCs
		
		ChallengeRating := Round(PlayerCount / 4 * 1.1 * PlayerLevel, 0)
			;Msgbox %ChallengeRating%
		
		RaceDir = K:\Documents\Foundry\Data\moulinette\tiles\custom\TOHP\Tokens\Homebrew\Sapient
		BeastPhotos = K:\Documents\Foundry\Data\moulinette\tiles\custom\TOHP\Tokens\Homebrew\Beasts
		
		Habitat = Temperate
		BaseDir = %A_ScriptDir%
		Dir = %A_ScriptDir%\Names
		LootDir = %A_ScriptDir%\Loot\Banks
		NPCDir = %A_ScriptDir%\Loot\Banks\NPC
		RaceList = %A_ScriptDir%\Names\.List.txt
	}
	ImportNPC:
	{
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
	}
}

Vars:
{
	SapientDir = K:\Documents\Foundry\Data\moulinette\tiles\custom\TOHP\Tokens\Homebrew\Sapient
}

Prompt:
{
	DebugMode = 0
	BeastMode = 0
	Inputbox, Race,,race M/F,,200,120
		If InStr(Race, " ")
			{
				RaceMF := StrSplit(Race, " ")
				Race := RaceMF.1
				Gender := RaceMF.2
					if (Gender = "m")
						ImgDir = %SapientDir%\%Race%\Male
					if (Gender = "f")
						ImgDir = %SapientDir%\%Race%\Female
				Goto, Start
			}
		If InStr(Race, "db")
			{
				DebugMode = 1
				Race = Squaloan
				Gender = m
				Goto, Start
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
				
				ImgDir = %BeastPhotos%\%BeastAttitude%
				BeastMode = 1
				Race = Beast
				Goto, Image
			}
		If Race =
			{
				Loop, Read, %RaceList%
					Races_Lines = %A_Index%
				Random, RacesRnd, 1, Races_Lines
				FileReadLine, Race, %RaceList%, RacesRnd
				;Msgbox %Race%	;Debug
			}
	;Race = Dragonborn
	Random, MF, 1, 2
	if (MF = "1")
	{
		Gender = m
		ImgDir = %RaceDir%\%Race%\Male
	}
	if (MF = "2")
	{
		Gender = f
		ImgDir = %RaceDir%\%Race%\Female
	}
}

Start:
{
	FirstFile = %Dir%\%Race%\%Race%_%Gender%.txt
	LastFile_0 = %Dir%\%Race%\%Race%_s0.txt
	LastFile_1 = %Dir%\%Race%\%Race%_s1.txt
	LastFile_2 = %Dir%\%Race%\%Race%_s2.txt
	;Msgbox %LastFile_0%
	
	RaceSetDir = K:\Documents\Foundry\Data\moulinette\tiles\custom\TOHP\Tokens\Homebrew\Sapient\%Race%
	if !FileExist(RaceSetDir)
		{
			Msgbox Error 404: %RACE% not found
			Reload
		}
	If (DebugMode = 1)
	{
		;random_file = %RaceDir%\.debug.webp
		random_file = %RaceDir%\.debug.png
		Goto, ImageGUI
	}
}

Image:
{
;Gui, Destroy
array := []  ; initialise array
loop, Files, %ImgDir%\*, FDR  ; match any file
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
		#Include, %A_ScriptDir%\Libraries\DecodeWebP.ahk
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

CountNames:
{
	Loop, Read, %FirstFile%
	fLines = %A_Index%
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

NPC:
{
	Level:
	{
		PlayerLevelMax := PlayerLevel + 2
		Random, NPC_Level, 0, %PlayerLevelMax%
		;Msgbox %LevelRnd%
	}
	Classes:
	{
		Loop, Read, %NPCDir%\Classes.ini
			Classes_Lines = %A_Index%
		Random, ClassesRnd, 1, Classes_Lines
		FileReadLine, NPC_Class, %NPCDir%\Classes.ini, ClassesRnd
	}
	Statblock:	;4d6 drop low method
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
		
		Scores:
		{
			STR = % StatRoll1
			DEX = % StatRoll2
			CON = % StatRoll3
			INT = % StatRoll4
			WIS = % StatRoll5
			CHA = % StatRoll6
		}
	}
	Classes_StatIntegration:
	{
		LoadoutQty:
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
			ArtificerClass_Proficiency:
			{
				Random, Class_cho, 1, 2
				If Class_cho = 1
					SavingThrowINT := INT + ProficiencyBonus
				If Class_cho = 2
					SavingThrowCON := CON + ProficiencyBonus
			}
			
			ArtificerWeapon:
			{
				Random, MeleeRanged, 1, 2
				If MeleeRanged = 1
					MeleeRanged = Melee
				If MeleeRanged = 2
					MeleeRanged = Ranged
					
				SimpleMartial = Simple
			}
			
			ArtificerArmor:
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
					
			BarbarianWeapon:
			{
				Random, SimpleMartial, 1, 100
				If SimpleMartial between 1 and 40
					SimpleMartial = Simple
				If SimpleMartial between 41 and 100
					SimpleMartial = Martial
					
				MeleeRanged = Melee
			}
			
			BarbarianArmor:
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
					
			BardWeapon:
			{
				Random, MeleeRanged, 1, 100
				If MeleeRanged between 1 and 60
					MeleeRanged = Melee
				If MeleeRanged between 61 and 100
					MeleeRanged = Ranged
					
				SimpleMartial = Simple
			}
			
			BardArmor:
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
					
			ClericWeapon:
			{
				Random, MeleeRanged, 1, 100
				If MeleeRanged between 1 and 60
					MeleeRanged = Melee
				If MeleeRanged between 61 and 100
					MeleeRanged = Ranged
					
				SimpleMartial = Simple
			}
			
			ClericArmor:
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
					
			DruidWeapon:
			{
				Random, MeleeRanged, 1, 100
				If MeleeRanged between 1 and 60
					MeleeRanged = Melee
				If MeleeRanged between 61 and 100
					MeleeRanged = Ranged
					
				SimpleMartial = Simple
			}
			
			DruidArmor:
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
					
			FighterWeapon:
			{
				Random, SimpleMartial, 1, 100
				If SimpleMartial between 1 and 20
					SimpleMartial = Simple
				If SimpleMartial between 21 and 100
					SimpleMartial = Martial
					
				MeleeRanged = Melee
			}
			
			FighterArmor:
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
					
			MonkWeapon:
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
			
			MonkArmor:
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
					
			PaladinWeapon:
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
			
			PaladinArmor:
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
			
			RangerWeapon:
			{
				Random, SimpleMartial, 1, 100
				If SimpleMartial between 1 and 20
					SimpleMartial = Simple
				If SimpleMartial between 21 and 100
					SimpleMartial = Martial
					
				MeleeRanged = Ranged
			}
			
			RangerArmor:
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
			
			RogueWeapon:
			{
				Random, SimpleMartial, 1, 100
				If SimpleMartial between 1 and 20
					SimpleMartial = Simple
				If SimpleMartial between 21 and 100
					SimpleMartial = Martial
					
				MeleeRanged = Ranged
			}
			
			RogueArmor:
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
					
			SorcererWeapon:
			{
				Random, MeleeRanged, 1, 100
				If MeleeRanged between 1 and 80
					MeleeRanged = Melee
				If MeleeRanged between 81 and 100
					MeleeRanged = Ranged
					
				SimpleMartial = Simple
			}
			
			SorcererArmor:
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
					
			WarlockWeapon:
			{
				Random, MeleeRanged, 1, 100
				If MeleeRanged between 1 and 80
					MeleeRanged = Melee
				If MeleeRanged between 81 and 100
					MeleeRanged = Ranged
					
				SimpleMartial = Simple
			}
			
			WarlockArmor:
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
					
			WizardWeapon:
			{
				Random, MeleeRanged, 1, 100
				If MeleeRanged between 1 and 80
					MeleeRanged = Melee
				If MeleeRanged between 81 and 100
					MeleeRanged = Ranged
					
				SimpleMartial = Simple
			}
			
			WizardArmor:
			{
				Shield := []
				ArmorType := []
			}
		}
		
		Races_StatIntegration:
		{
			#Include %A_ScriptDir%\Libraries\Races_StatIntegration.ahk
		}
		
		;Msgbox %STR% STR | %DEX% DEX | %CON% CON | %INT% INT | %WIS% WIS | %CHA% CHA
		AbilityScores = %STR% STR | %DEX% DEX | %CON% CON | %INT% INT | %WIS% WIS | %CHA% CHA
	}
	Goals:
	{
		Random, GoalsRnd, 1, Goals_Lines
		FileReadLine, NPC_Goal, %NPCDir%\Goals.ini, GoalsRnd
	}
	Family:
	{
		Random, 1d6, 1, 4
		Random, 1d6x2, 1, 4
		
		Siblings:
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
		Parents:
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
		Relationship:
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
	Role:
	{
		Random, RolesRnd, 1, Roles_Lines
		FileReadLine, NPC_Role, %NPCDir%\Roles.ini, RolesRnd
	}
	Religion:
	{
		Random, GodsRnd, 1, Gods_Lines
		FileReadLine, NPC_Gods, %BaseDir%\Loot\Banks\.Gods.ini, GodsRnd
	}
	Traits:
	{
		Random, TraitRnd1, 1, Traits_Lines
		FileReadLine, NPC_Trait1, %BaseDir%\Loot\Banks\NPC\Traits.ini, TraitRnd1
		Random, TraitRnd2, 1, Traits_Lines
		FileReadLine, NPC_Trait2, %BaseDir%\Loot\Banks\NPC\Traits.ini, TraitRnd2
		
		Traits = ~Others would describe them as %NPC_Trait1%
	}
	Quirks:
	{
		Random, QuirksRnd, 1, Quirks_Lines
		FileReadLine, NPC_Quirk, %BaseDir%\Loot\Banks\NPC\Quirks.ini, QuirksRnd
	}
	Weapons:
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
			Goto, Weapons
		}
		
		Loop, Read, %WeaponFile%
			Weapons_Lines = %A_Index%
		Random, WeaponsRnd, 1, Weapons_Lines
		FileReadLine, NPC_Weapons, %WeaponFile%, WeaponsRnd
	}
	Armors:
	{
		ArmorFile = %LootDir%\Armors\%ArmorType%Armor.ini
		Loop, Read, %ArmorFile%
			Armor_Lines = %A_Index%
		Random, ArmorRnd, 1, Armor_Lines
		FileReadLine, NPC_Armor, %ArmorFile%, ArmorRnd
		
		;Msgbox %ArmorType% Armor %Shield%
		NPC_Armor = %NPC_Armor%%Shield%
	}
}

Generate:
{
	Loop, 3
	{
		GenerateMain:
		{
			Random, FirstRnd, 1, %fLines%
			Random, LastRnd_0, 1, %s0Lines%
			Random, LastRnd_1, 1, %s1Lines%
			Random, LastRnd_2, 1, %s2Lines%
			
			Read:
			FileReadLine, First, %FirstFile%, %FirstRnd%
			If FileExist(LastFile_0)
				FileReadLine, Last_0, %LastFile_0%, %LastRnd_0%
			FileReadLine, Last_1, %LastFile_1%, %LastRnd_1%
			FileReadLine, Last_2, %LastFile_2%, %LastRnd_2%
				StringLower, Last_2b, Last_2
			
			ColorFile = %A_ScriptDir%\Loot\Banks\.Colors.ini
			Loop, Read, %ColorFile%
			C_Lines = %A_Index%
			Random, ColorRnd, 1, %C_Lines%
			FileReadLine, COLOR, %ColorFile%, %ColorRnd%
			COLOR := StrSplit(COLOR, A_Tab)
			Last_0 := StrReplace(Last_0, "{COLOR}", Color.1)
			Last_1 := StrReplace(Last_1, "{COLOR}", Color.1)
			Last_2 := StrReplace(Last_2, "{COLOR}", Color.1)
			MainGenNoun:
				{	;Collapse
					Random, NounsRnd, 1, 6
					Loop, Read, %A_ScriptDir%\Loot\Banks\Nouns\Nouns%NounsRnd%.txt
						Noun_Lines = %A_Index%
					Random, NounsRndLine, 1, %Noun_Lines%					
					FileReadLine, Noun, %A_ScriptDir%\Loot\Banks\Nouns\Nouns%NounsRnd%.txt, NounsRndLine
				}
		}
	
		IfStatements:
		{
			If (InStr(Last_0, "{FLORA}")) || If (InStr(Last_1, "{FLORA}")) || If (InStr(Last_2, "{FLORA}"))
				{	;Collapse
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
				{	;Collapse
					FAMILYFile = %A_ScriptDir%\Loot\Banks\NPC\Family.ini
					Loop, Read, %FAMILYFile%
						FAMILY_Lines = %A_Index%
					Random, FAMILYRnd, 1, FAMILY_Lines
					FileReadLine, FAMILY, %FAMILYFile%, FAMILYRnd
					NPC_FamilyReplacements:
					{
						NPC_Goal := StrReplace(NPC_Goal, "{FAMILY}", FAMILY)
						NPC_Flaw := StrReplace(NPC_Flaw, "{FAMILY}", FAMILY)
						NPC_Bond := StrReplace(NPC_Bond, "{FAMILY}", FAMILY)
						NPC_Quirk := StrReplace(NPC_Quirk, "{FAMILY}", FAMILY)
						NPC_Ideal := StrReplace(NPC_Ideal, "{FAMILY}", FAMILY)
					}
				}
			If (InStr(NPC_Goal, "{BEAST}")) || If (InStr(NPC_Flaw, "{BEAST}")) || If (InStr(NPC_Bond, "{BEAST}")) || If (InStr(NPC_Ideal, "{BEAST}")) || If (InStr(NPC_Quirk, "{BEAST}"))
				{	;Collapse
					BEASTFile = %LootDir%\Beastiary\.Global.txt
					Loop, Read, %BEASTFile%
						BEAST_Lines = %A_Index%
					Random, BEASTRnd, 1, BEAST_Lines
					FileReadLine, BEAST, %BEASTFile%, BEASTRnd
					NPC_BEASTReplacements:
					{
						NPC_Goal := StrReplace(NPC_Goal, "{BEAST}", BEAST)
						NPC_Flaw := StrReplace(NPC_Flaw, "{BEAST}", BEAST)
						NPC_Bond := StrReplace(NPC_Bond, "{BEAST}", BEAST)
						NPC_Quirk := StrReplace(NPC_Quirk, "{BEAST}", BEAST)
						NPC_Ideal := StrReplace(NPC_Ideal, "{BEAST}", BEAST)
					}
				}
			If (InStr(NPC_Goal, "{EMBLEM}")) || If (InStr(NPC_Flaw, "{EMBLEM}")) || If (InStr(NPC_Bond, "{EMBLEM}")) || If (InStr(NPC_Ideal, "{EMBLEM}")) || If (InStr(NPC_Quirk, "{EMBLEM}"))
				{	;Collapse
					EMBLEMFile = %LootDir%\Misc\.Emblems.ini
					Loop, Read, %EMBLEMFile%
						EMBLEM_Lines = %A_Index%
					Random, EMBLEMRnd, 1, EMBLEM_Lines
					FileReadLine, EMBLEM, %EMBLEMFile%, EMBLEMRnd
					NPC_EMBLEMReplacements:
					{
						NPC_Goal := StrReplace(NPC_Goal, "{EMBLEM}", EMBLEM)
						NPC_Flaw := StrReplace(NPC_Flaw, "{EMBLEM}", EMBLEM)
						NPC_Bond := StrReplace(NPC_Bond, "{EMBLEM}", EMBLEM)
						NPC_Quirk := StrReplace(NPC_Quirk, "{EMBLEM}", EMBLEM)
						NPC_Ideal := StrReplace(NPC_Ideal, "{EMBLEM}", EMBLEM)
					}
				}
			If (InStr(NPC_Goal, "{DRUG}")) || If (InStr(NPC_Flaw, "{DRUG}")) || If (InStr(NPC_Bond, "{DRUG}")) || If (InStr(NPC_Ideal, "{DRUG}")) || If (InStr(NPC_Quirk, "{DRUG}"))
				{	;Collapse
					DRUGFile = %A_ScriptDir%\Loot\Banks\Misc\.Drugs.ini
					Loop, Read, %DRUGFile%
						DRUG_Lines = %A_Index%
					Random, DRUGRnd, 1, DRUG_Lines
					FileReadLine, DRUG, %DRUGFile%, DRUGRnd
					NPC_DrugReplacements:
					{
						NPC_Goal := StrReplace(NPC_Goal, "{DRUG}", DRUG)
						NPC_Flaw := StrReplace(NPC_Flaw, "{DRUG}", DRUG)
						NPC_Bond := StrReplace(NPC_Bond, "{DRUG}", DRUG)
						NPC_Quirk := StrReplace(NPC_Quirk, "{DRUG}", DRUG)
						NPC_Ideal := StrReplace(NPC_Ideal, "{DRUG}", DRUG)
					}
				}
			If (InStr(NPC_Goal, "{DISEASE}")) || If (InStr(NPC_Flaw, "{DISEASE}")) || If (InStr(NPC_Bond, "{DISEASE}")) || If (InStr(NPC_Ideal, "{DISEASE}")) || If (InStr(NPC_Quirk, "{DISEASE}"))
				{	;Collapse
					DISEASEFile = %A_ScriptDir%\Loot\Banks\Effects\Disease.ini
					Loop, Read, %DISEASEFile%
						DISEASE_Lines = %A_Index%
					Random, DISEASERnd, 1, DISEASE_Lines
					FileReadLine, DISEASE, %DISEASEFile%, DISEASERnd
					NPC_DISEASEReplacements:
					{
						NPC_Goal := StrReplace(NPC_Goal, "{DISEASE}", DISEASE)
						NPC_Flaw := StrReplace(NPC_Flaw, "{DISEASE}", DISEASE)
						NPC_Bond := StrReplace(NPC_Bond, "{DISEASE}", DISEASE)
						NPC_Quirk := StrReplace(NPC_Quirk, "{DISEASE}", DISEASE)
						NPC_Ideal := StrReplace(NPC_Ideal, "{DISEASE}", DISEASE)
					}
				}
			If (InStr(NPC_Goal, "{ROLE}")) || If (InStr(NPC_Flaw, "{ROLE}")) || If (InStr(NPC_Bond, "{ROLE}")) || If (InStr(NPC_Ideal, "{ROLE}")) || If (InStr(NPC_Quirk, "{ROLE}"))
				{	;Collapse
					ROLEFile = %LootDir%\NPC\Roles.ini
					Loop, Read, %ROLEFile%
						ROLE_Lines = %A_Index%
					Random, ROLERnd, 1, ROLE_Lines
					FileReadLine, ROLE, %ROLEFile%, ROLERnd
					NPC_ROLEReplacements:
					{
						NPC_Goal := StrReplace(NPC_Goal, "{ROLE}", ROLE)
						NPC_Flaw := StrReplace(NPC_Flaw, "{ROLE}", ROLE)
						NPC_Bond := StrReplace(NPC_Bond, "{ROLE}", ROLE)
						NPC_Quirk := StrReplace(NPC_Quirk, "{ROLE}", ROLE)
						NPC_Ideal := StrReplace(NPC_Ideal, "{ROLE}", ROLE)
					}
				}
			If (InStr(NPC_Goal, "{GOD}")) || If (InStr(NPC_Flaw, "{GOD}")) || If (InStr(NPC_Bond, "{GOD}")) || If (InStr(NPC_Ideal, "{GOD}")) || If (InStr(NPC_Quirk, "{GOD}"))
				{	;Collapse
					Random, GODRnd, 1, Gods_Lines
					FileReadLine, GOD, %BaseDir%\Loot\Banks\.Gods.ini, GODRnd
					NPC_GODReplacements:
					{
						NPC_Goal := StrReplace(NPC_Goal, "{GOD}", GOD)
						NPC_Flaw := StrReplace(NPC_Flaw, "{GOD}", GOD)
						NPC_Bond := StrReplace(NPC_Bond, "{GOD}", GOD)
						NPC_Quirk := StrReplace(NPC_Quirk, "{GOD}", GOD)
						NPC_Ideal := StrReplace(NPC_Ideal, "{GOD}", GOD)
					}
				}
			If (InStr(NPC_Goal, "{LANGUAGE}")) || If (InStr(NPC_Flaw, "{LANGUAGE}")) || If (InStr(NPC_Bond, "{LANGUAGE}")) || If (InStr(NPC_Ideal, "{LANGUAGE}")) || If (InStr(NPC_Quirk, "{LANGUAGE}"))
				{	;Collapse
					Loop, Read, %LootDir%\.Languages.ini
						Languages_Lines = %A_Index%
					Random, LANGUAGERnd, 1, LANGUAGEs_Lines
					FileReadLine, LANGUAGE, %LootDir%\.Languages.ini, LANGUAGERnd
					NPC_LANGUAGEReplacements:
					{
						NPC_Goal := StrReplace(NPC_Goal, "{LANGUAGE}", LANGUAGE)
						NPC_Flaw := StrReplace(NPC_Flaw, "{LANGUAGE}", LANGUAGE)
						NPC_Bond := StrReplace(NPC_Bond, "{LANGUAGE}", LANGUAGE)
						NPC_Quirk := StrReplace(NPC_Quirk, "{LANGUAGE}", LANGUAGE)
						NPC_Ideal := StrReplace(NPC_Ideal, "{LANGUAGE}", LANGUAGE)
					}
				}
			If (InStr(NPC_Goal, "{SUBJECT}")) || If (InStr(NPC_Flaw, "{SUBJECT}")) || If (InStr(NPC_Bond, "{SUBJECT}")) || If (InStr(NPC_Ideal, "{SUBJECT}")) || If (InStr(NPC_Quirk, "{SUBJECT}"))
				{	;Collapse
					Subject = {NOUN}
					NPC_SUBJECTReplacements:
					{
						NPC_Goal := StrReplace(NPC_Goal, "{SUBJECT}", SUBJECT)
						NPC_Flaw := StrReplace(NPC_Flaw, "{SUBJECT}", SUBJECT)
						NPC_Bond := StrReplace(NPC_Bond, "{SUBJECT}", SUBJECT)
						NPC_Quirk := StrReplace(NPC_Quirk, "{SUBJECT}", SUBJECT)
						NPC_Ideal := StrReplace(NPC_Ideal, "{SUBJECT}", SUBJECT)
					}
				}
			If (InStr(NPC_Goal, "{ADJ}")) || If (InStr(NPC_Flaw, "{ADJ}")) || If (InStr(NPC_Bond, "{ADJ}")) || If (InStr(NPC_Ideal, "{ADJ}")) || If (InStr(NPC_Quirk, "{ADJ}"))
				{	;Collapse
					Random, ADJsRnd, 1, 12
					Loop, Read, %LootDir%\Adj\Adj%ADJsRnd%.txt
						ADJ_Lines = %A_Index%
					Random, ADJsRndLine, 1, %ADJ_Lines%					
					FileReadLine, ADJ, %LootDir%\Adj\Adj%ADJsRnd%.txt, ADJsRndLine
					NPC_ADJReplacements:
					{
						NPC_Goal := StrReplace(NPC_Goal, "{ADJ}", ADJ)
						NPC_Flaw := StrReplace(NPC_Flaw, "{ADJ}", ADJ)
						NPC_Bond := StrReplace(NPC_Bond, "{ADJ}", ADJ)
						NPC_Quirk := StrReplace(NPC_Quirk, "{ADJ}", ADJ)
						NPC_Ideal := StrReplace(NPC_Ideal, "{ADJ}", ADJ)
					}
				}
			If (InStr(NPC_Goal, "{NOUN}")) || If (InStr(NPC_Flaw, "{NOUN}")) || If (InStr(NPC_Bond, "{NOUN}")) || If (InStr(NPC_Ideal, "{NOUN}")) || If (InStr(NPC_Quirk, "{NOUN}"))
				{	;Collapse
					Random, NounsRnd, 1, 6
					Loop, Read, %A_ScriptDir%\Loot\Banks\Nouns\Nouns%NounsRnd%.txt
						Noun_Lines = %A_Index%
					Random, NounsRndLine, 1, %Noun_Lines%					
					FileReadLine, Noun, %A_ScriptDir%\Loot\Banks\Nouns\Nouns%NounsRnd%.txt, NounsRndLine
					NPC_NOUNReplacements:
					{
						NPC_Goal := StrReplace(NPC_Goal, "{NOUN}", NOUN)
						NPC_Flaw := StrReplace(NPC_Flaw, "{NOUN}", NOUN)
						NPC_Bond := StrReplace(NPC_Bond, "{NOUN}", NOUN)
						NPC_Quirk := StrReplace(NPC_Quirk, "{NOUN}", NOUN)
						NPC_Ideal := StrReplace(NPC_Ideal, "{NOUN}", NOUN)
					}
				}
			If (InStr(NPC_Goal, "{NOUNAbstractRemoved}")) || If (InStr(NPC_Flaw, "{NOUNAbstractRemoved}")) || If (InStr(NPC_Bond, "{NOUNAbstractRemoved}")) || If (InStr(NPC_Ideal, "{NOUNAbstractRemoved}")) || If (InStr(NPC_Quirk, "{NOUNAbstractRemoved}"))
				{	;Collapse
					NounsAbstractRemovedFile = %LootDir%\Nouns\NounsAbstractRemoved.txt
					Loop, Read, %NounsAbstractRemovedFile%
						NOUNAbstractRemoved_Lines = %A_Index%
					Random, NOUNAbstractRemovedsRndLine, 1, %NOUNAbstractRemoved_Lines%					
					FileReadLine, NOUNAbstractRemoved, %NounsAbstractRemovedFile%, NOUNAbstractRemovedsRndLine
					NPC_NOUNAbstractRemovedReplacements:
					{
						NPC_Goal := StrReplace(NPC_Goal, "{NOUNAbstractRemoved}", NOUNAbstractRemoved)
						NPC_Flaw := StrReplace(NPC_Flaw, "{NOUNAbstractRemoved}", NOUNAbstractRemoved)
						NPC_Bond := StrReplace(NPC_Bond, "{NOUNAbstractRemoved}", NOUNAbstractRemoved)
						NPC_Quirk := StrReplace(NPC_Quirk, "{NOUNAbstractRemoved}", NOUNAbstractRemoved)
						NPC_Ideal := StrReplace(NPC_Ideal, "{NOUNAbstractRemoved}", NOUNAbstractRemoved)
					}
				}
			If (InStr(NPC_Goal, "{Anatomy}")) || If (InStr(NPC_Flaw, "{Anatomy}")) || If (InStr(NPC_Bond, "{Anatomy}")) || If (InStr(NPC_Ideal, "{Anatomy}")) || If (InStr(NPC_Quirk, "{Anatomy}"))
				{	;Collapse
					Loop, Read, %LootDir%\Misc\Anatomy.ini
						Anatomy_Lines = %A_Index%
					Random, AnatomysRndLine, 1, %Anatomy_Lines%		
					FileReadLine, Anatomy, %LootDir%\Misc\Anatomy.ini, AnatomysRndLine
					NPC_AnatomyReplacements:
					{
						NPC_Goal := StrReplace(NPC_Goal, "{Anatomy}", Anatomy)
						NPC_Flaw := StrReplace(NPC_Flaw, "{Anatomy}", Anatomy)
						NPC_Bond := StrReplace(NPC_Bond, "{Anatomy}", Anatomy)
						NPC_Quirk := StrReplace(NPC_Quirk, "{Anatomy}", Anatomy)
						NPC_Ideal := StrReplace(NPC_Ideal, "{Anatomy}", Anatomy)
					}
				}
			If (InStr(NPC_Goal, "{COLOR}")) || If (InStr(NPC_Flaw, "{COLOR}")) || If (InStr(NPC_Bond, "{COLOR}")) || If (InStr(NPC_Ideal, "{COLOR}")) || If (InStr(NPC_Quirk, "{COLOR}"))
				{	;Collapse
					Loop, Read, %A_ScriptDir%\Loot\Banks\.Colors.ini
						COLOR_Lines = %A_Index%
					Random, COLORsRndLine, 1, %COLOR_Lines%					
					FileReadLine, COLOR, %A_ScriptDir%\Loot\Banks\.Colors.ini, COLORsRndLine
					
					NPC_COLORReplacements:
					{
						NPC_Goal := StrReplace(NPC_Goal, "{COLOR}", COLOR)
						NPC_Flaw := StrReplace(NPC_Flaw, "{COLOR}", COLOR)
						NPC_Bond := StrReplace(NPC_Bond, "{COLOR}", COLOR)
						NPC_Quirk := StrReplace(NPC_Quirk, "{COLOR}", COLOR)
						NPC_Ideal := StrReplace(NPC_Ideal, "{COLOR}", COLOR)
					}
				}
			If (InStr(Loot, "{Table-"))
			{	;Collapse
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
				StartRange:
				{
					StartLine = % Array[1]
					StartLine := StrSplit(StartLine, A_Tab)
					Start := StartLine.1
					
					Start := StrSplit(Start, "-")
					StartRange := Start.1
				}
				
				EndRange:
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
							Goto, EscapeArray
						}
					}
				EscapeArray:
				Loot := RegexReplace(Loot, "{Table.+}", element)
			}
		}
		
		Replaced_NPCGen:
		{
			Quirks = ~They have a recognizable %NPC_Quirk%
		}
		
		Output:
		{
			If FileExist(LastFile_0)
			{
				Random, LastA, 1, 2
				if (LastA = 1)
					Goto, Combine
				if (LastA = 2)
				{
					Loop, Read, %LastFile_0%
					NameArray%A_Index% = %First% %Last_0%
					;Msgbox %Last_0%
					Goto, End
				}
			}
		}
		Combine:
		{
			NameArray := []
			NameArray%A_Index% = %First% %Last_1%%Last_2b%
			;MsgBox % NameArray%A_Index%
		}
		End:
		
		;BeastCheck:
		;{
		;	If BeastMode = 1
		;	{
		;		GUI, Color, 050505	;GUI bg color
		;		Goto, BeastGUIBody
		;	}
		;	If BeastMode = 0
		;		Goto, GUICode
		;}
		
		;GUICode:
		;{
		;	GUI, Color, 050505	;GUI bg color
		;	Gui, Font, s14 cWhite, Centaur
		;	GUI, add, button, gAction%A_Index% y10, % NameArray%A_Index%
		;}
	}
	
	;If BeastMode = 0
	;	Goto, GuiBody
	;
	;BeastGUIBody:
	;{
	;	Gui, Font, s12 cGray, Centaur
	;	GUI, add, text, gAction3 x15 +wrap w600, BeastGen
	;	
	;	Gui, Font, s14 cWhite, Centaur
	;	GUI, add, text, gAction3 x10 w600 r2, %AbilityScores%
;
	;	Gui, Show, x800 y250
	;}
	
	;GUIBody:
	;{
	;	GUICasing:
	;	{
	;		if Gender = m
	;			FullGender = Male
	;		if Gender = f
	;			FullGender = Female
	;		StringUpper, Race, Race, T
	;	}
	;	Gui, Font, s12 cGray, Centaur
	;	GUI, add, text, gAction3 x15 +wrap w600, %FullGender% %Race% | %NPC_Role% | %NPC_Family% | Lvl_%NPC_Level% %NPC_Class%
	;	
	;	Gui, Font, s14 cWhite, Centaur
	;	GUI, add, text, gAction3 x10 w600 r2, %Traits%
	;	GUI, add, text, gAction3 x10 w600 r2, ~%NPC_Goal%
	;	GUI, add, text, gAction3 x10 w600 r3, %Quirks%
	;	GUI, add, text, gAction3 x10 w600 r4, ~Currently thinking about %NOUN%
	;	GUI, add, text, gAction3 x10 w600 y320, ~Equipped with a %NPC_Weapons%, %NPC_Armor%
	;	GUI, add, text, gAction3 x10 w600 y400, %AbilityScores%
	;	;GUI, add, text, gAction3 x10 w600 y460, Acrobatics | Animal Handling | Arcana | Athletics | Deception | History | Insight | Intimidation | Investigation | Medicine | Nature | Perception | Performance | Persuasion | Religion | Sleight of Hand | Stealth | Survival
	;	
	;	Gui, Show, x800 y250
	;	
	;	NPC_Body = %FullGender% %Race% | %NPC_Role% | %NPC_Family% | Worships %NPC_Gods% | ~Currently thinking about %NOUN% | ~%NPC_Goal%
	;}
	;
	;pause	;press Escape to resume
	;Reload
}

;# ============================================================================ #
;# GUI
MusicDLGUI()
{
	global
	Gui, GenGUI:New	
	Gui, GenGUI:Color, 050505
	Gui +LastFound
	Gui, GenGUI:-Caption
	
	;BGImg := GUI_Backgrounds(BGImg)
	;GUI_CheckAvatarImg()
	;GUI_Icon()

	Gui, GenGUI:Add, Picture, x0 y0 w500 h300 , %BGImg%
	Gui, GenGUI:Add, Picture, y10 x10 w480 h280 BackgroundTrans, %MaskShape%
	
	Gui, GenGUI:Add, Picture, y24 x20 h56 w56 BackgroundTrans, %Icon%
	Gui, GenGUI:Font, s16
	Gui, GenGUI:Add, Text, cWhite BackgroundTrans w325 x86 y28 r1, %CategoryTitle%
	Gui, GenGUI:Add, Text, cWhite BackgroundTrans w325 x86 y58 r2 %Align%, %Line2%
	Gui, GenGUI:Add, Picture, x30 y92 w430 h6 , %Bin%\Divider.png
	;Gui, GenGUI:Add, Text, cGray BackgroundTrans w500 x20 y80 r3, -----------------------------------------------------------------
	Gui, GenGUI:Font, s12
	IniRead, RunCount, %MusicIni%, Count, RunCount
	Gui, GenGUI:Add, Text, cGray w100 x370 y30 BackgroundTrans right, #%RunCount%
	Gui, GenGUI:Add, Text, cGray w100 x370 y50 BackgroundTrans right, v%Version%
	Gui, GenGUI:Add, Text, cGray w100 x370 y70 BackgroundTrans right, %Cho%

	Gui, GenGUI:Add, Text, cGray BackgroundTrans r2 x30 y110, Reroll: 0
	Gui, GenGUI:Add, Text, cGray BackgroundTrans r2 x30 y130, CYO: 1
	Gui, GenGUI:Add, Text, cGray BackgroundTrans r2 x30 y150, Debug: 2
	Gui, GenGUI:Add, Text, cGray BackgroundTrans r2 x30 y170, Reload: 3
	
	If (Debug = 0)
		Gui, GenGUI:Add, Picture, y40 x535 h24 w48, %A_ScriptDir%\Libraries\Icons\DebugOff.png
	If (Debug = 1)
		Gui, GenGUI:Add, Picture, y40 x530 h24 w48, %A_ScriptDir%\Libraries\Icons\DebugOn.png
		
	Gui, GenGUI:Add, Edit, vLauncher x30 w130 y200
	Gui, GenGUI:Add, Button, default gButtonOK x30 y240, OK

	If (CategoryTitle = "CYO")	;CYO GUI
	{
		Row1_X = 175
		Row2_X = 290
		Row3_X = 410

		;Text
		Gui, GenGUI:Font, s11
		Gui, GenGUI:Add, Text, cWhite BackgroundTrans w100 x%Row1_X% y105 gBandcamp, Bandcamp
		Gui, GenGUI:Add, Text, cWhite BackgroundTrans w100 x%Row2_X% y105 gFavorites, Favorites
		Gui, GenGUI:Add, Text, cWhite BackgroundTrans w100 x%Row3_X% y105 gList, List
		Gui, GenGUI:Add, Text, cWhite BackgroundTrans w100 x%Row1_X% y135 gTwoSeven, TwoSeven
		Gui, GenGUI:Add, Text, cWhite BackgroundTrans w100 x%Row2_X% y135 gSmallAlbum, SmallAlbum
		Gui, GenGUI:Add, Text, cWhite BackgroundTrans w100 x%Row3_X% y135 gGenre, Genre
		Gui, GenGUI:Add, Text, cWhite BackgroundTrans w100 x%Row1_X% y165 gMusicMap, MusicMap
		Gui, GenGUI:Add, Text, cWhite BackgroundTrans w100 x%Row2_X% y165 gSpotify, Spotify
		Gui, GenGUI:Add, Text, cWhite BackgroundTrans w100 x%Row3_X% y165 gJPod, JPod
		Gui, GenGUI:Add, Text, cWhite BackgroundTrans w100 x%Row1_X% y195 gWordGen, WordGen
		Gui, GenGUI:Add, Text, cWhite BackgroundTrans w100 x%Row2_X% y195 gRecordLabel, RecordLabel
		Gui, GenGUI:Add, Text, cWhite BackgroundTrans w100 x%Row3_X% y195 gNotes, Notes
		Gui, GenGUI:Add, Text, cWhite BackgroundTrans w100 x%Row1_X% y225 gPrevGenre, PrevGenre
		Gui, GenGUI:Add, Text, cWhite BackgroundTrans w100 x%Row2_X% y225 gYouTube, YouTube
		Gui, GenGUI:Add, Text, cWhite BackgroundTrans w100 x%Row3_X% y225 gQueueFolder, Queue
		Gui, GenGUI:Add, Text, cWhite BackgroundTrans w100 x%Row1_X% y255 gScreenshots, Screenshots
		Gui, GenGUI:Add, Text, cWhite BackgroundTrans w100 x%Row2_X% y255 gRndBandcamp, RndBandcamp
	}

	Gui, GenGUI:Show, w800 h300 x1150, GenGUI	
	;Winset, Alwaysontop, On, GenGUI
	return
	
	GuiClose:
		return
	ButtonOK:
	{
		Gui, GenGUI:Submit
		WinClose, GenGUI

		If (Launcher = "")
		{
			return
		}
		If (Launcher = "r")		;Debug
		{
			Reload
		}
	return
	}
}

Action1:
{
	;MsgBox % NameArray1
	FoundryName = % NameArray1
	Goto, FoundryImport
}
Action2:
{
	FoundryName = % NameArray2
	Goto, FoundryImport
}
Action3:
{
	FoundryName = % NameArray3
	Goto, FoundryImport
}

FoundryImport:
{
	SleepDur = 50
	ImgPath = %random_file%
	;Msgbox %ImgPath%
	Clipboard = %FoundryName%
	Clipwait
	
	;FoundryImage := StrReplace(random_file, "\", "/")
	;FoundryImage := StrSplit(FoundryImage, "Data/")
	;FoundryImage := % FoundryImage.2
	
	FoundryImage = moulinette/tiles/custom/TOHP/Tokens/NPC/%FoundryName%.webp
	
	;SetTitleMatchMode, 2
	;if WinExist("Foundry Virtual Tabletop")
	;	Winactivate, Foundry Virtual Tabletop
	;else
	;{
	;	Msgbox,,,Foundry instance not found. Returning...,2
	;	Return
	;}
	
	;MouseGetPos, PosX, PosY
	;MouseClick, right, 929, 1363	;Right click macro
	;MouseClick, left, 932, 1234	;Edit macro menu
	
	;Clipboard = const img = "%FoundryImage%"; `nconst actor = await Actor.create({ `n  name: "%FoundryName%", `n  type: "npc", `n  img: img, `n"system.details.biography.value": "%NPC_Body%",`n  prototypeToken: { `n    texture: { `n      src: img, `n      scaleX: 1.2, `n      scaleY: 1.2 `n    }, `n    width: 1.2, `n    height: 1.2 `n  } `n});
	;MouseClick, left, 1232, 831	;body
	;Send ^a{Backspace}^v
	;MouseClick, left, 1477, 1018	;Execute
	;Sleep 50
	;Send {Escape 2}
	;Clipboard = %FoundryName%
	;MouseMove, PosX, PosY	;Return to OG pos
	
	Clipboard = const img = "%FoundryImage%"; `nconst actor = await Actor.create({ `n  name: "%FoundryName%", `n  type: "npc", `n  img: img, `n"system.details.biography.value": "%NPC_Body%",`n  prototypeToken: { `n    texture: { `n      src: img, `n      scaleX: 1.2, `n      scaleY: 1.2 `n    }, `n    width: 1.2, `n    height: 1.2 `n  } `n});
	
	Run, %ImgPath%
	Run, "K:\Documents\Foundry\Data\moulinette\tiles\custom\TOHP\Tokens\NPC\.NewBorder.pdn"
	
	Sleep 1000
	FileMove, %ImgPath%, K:\Documents\Foundry\Data\moulinette\tiles\custom\TOHP\Tokens\NPC\.Saved\BaseImg\%FoundryName%.*
	ExitApp
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