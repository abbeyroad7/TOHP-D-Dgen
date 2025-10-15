; Change these to fit your world.
WorldSettings:
{
	Habitat = Temperate	;Your current environmental climate. Options: Global, Coast, Desert, Jungle, Ocean, Temperate, Tundra
	Level = 5	;Player's current level
}
;v4.2.0
;# Restructure
;# Bugs
;If category prompt is entered, it does not exit the mode correctly
;Tables show roll range sometimes, seems to break randomly on ranges with hyphens
;# Todo
;Select all to FoundryImport
;Add Item pictures to lootbanks
;Animal mixer
;edit nouns for loot, queue\nouns1
;Natural language syntax, for words ending in s, a/an, etc.
;GUI to regen certain aspects
;Grab first image off of google
;combining icon+color+material as an overlay in GUI, experiment w/ transparency masks

;Import
{	;collapse import
	#Requires AutoHotkey v1.1+
	#SingleInstance Force
	Debug = 1	;1=off
	
	DebugCheck:
		{
			DebugSize := 0
			FileGetSize, DebugSize, D:\Documents\Notes\DND\DND\Quartz\DM\Scripts\Loot\0_Test.txt
			If (DebugSize > 0)
				Debug = 0
		}
	IconSet:
	{
		I_Icon = C:\Program Files\AutoHotkey\Icons\Loot.ico
		ICON [I_Icon]                        ;Changes a compiled script's icon (.exe)
		if I_Icon <>
		IfExist, %I_Icon%
			Menu, Tray, Icon, %I_Icon%   ;Changes menu tray icon 
	}
	
	Filepaths:
	{
		Dir = %A_ScriptDir%\Loot
		NamesDir = %A_ScriptDir%\Names
	}
	
	If Debug = 0
		{
			Loop, Read, %Dir%\0_Test.txt	;testing purposes
				0_Lines = %A_Index%
		}
	Loop, Read, %Dir%\Banks\Colors.ini
	C_Lines = %A_Index%
	Loop, Read, %Dir%\1_Mundane.txt
	1_Lines = %A_Index%
	Loop, Read, %Dir%\2_Common.txt
	2_Lines = %A_Index%
	Loop, Read, %Dir%\3_Uncommon.txt
	3_Lines = %A_Index%
	Loop, Read, %Dir%\4_Rare.txt
	4_Lines = %A_Index%
	Loop, Read, %Dir%\5_VeryRare.txt
	5_Lines = %A_Index%
	Loop, Read, %Dir%\6_Legendary.txt
	6_Lines = %A_Index%
	Loop, Read, %Dir%\Banks\Nouns\Nouns1.txt
	N1_Lines = %A_Index%
	Loop, Read, %Dir%\Banks\Nouns\Nouns2.txt
	N2_Lines = %A_Index%
	Loop, Read, %Dir%\Banks\Nouns\Nouns3.txt
	N3_Lines = %A_Index%
	Loop, Read, %Dir%\Banks\Nouns\Nouns4.txt
	N4_Lines = %A_Index%
	Loop, Read, %Dir%\Banks\Nouns\Nouns5.txt
	N5_Lines = %A_Index%
	Loop, Read, %Dir%\Banks\Nouns\Nouns6.txt
	N6_Lines = %A_Index%
	Loop, Read, %Dir%\Banks\Adj\Adj1.txt
	Adj1_Lines = %A_Index%
	Loop, Read, %Dir%\Banks\Adj\Adj2.txt
	Adj2_Lines = %A_Index%
	Loop, Read, %Dir%\Banks\Adj\Adj3.txt
	Adj3_Lines = %A_Index%
	Loop, Read, %Dir%\Banks\Adj\Adj4.txt
	Adj4_Lines = %A_Index%
	Loop, Read, %Dir%\Banks\Adj\Adj5.txt
	Adj5_Lines = %A_Index%
	Loop, Read, %Dir%\Banks\Adj\Adj6.txt
	Adj6_Lines = %A_Index%
	Loop, Read, %Dir%\Banks\Adj\Adj7.txt
	Adj7_Lines = %A_Index%
	Loop, Read, %Dir%\Banks\Adj\Adj8.txt
	Adj8_Lines = %A_Index%
	Loop, Read, %Dir%\Banks\Adj\Adj9.txt
	Adj9_Lines = %A_Index%
	Loop, Read, %Dir%\Banks\Adj\Adj10.txt
	Adj10_Lines = %A_Index%
	Loop, Read, %Dir%\Banks\Adj\Adj11.txt
	Adj11_Lines = %A_Index%
	Loop, Read, %Dir%\Banks\Adj\Adj12.txt
	Adj12_Lines = %A_Index%
	Loop, Read, %Dir%\Banks\Races.txt
	Race_Lines = %A_Index%
	Loop, Read, %Dir%\Banks\RaceNames.txt
	RaceNames_Lines = %A_Index%
}
Start:
NC = 0
Inputbox, QtyMax,,,,200,100
	Modes:
	{
		If QtyMax = Coast
			Habitat = Coast
		If QtyMax = Temperate
			Habitat = Temperate
		If QtyMax < 1
			Exit
	}
	;If (InStr(QtyMax, A_Space))
	;{
	;	QtyMaxPrompt := StrSplit(QtyMax, A_Space)
	;	QtyMax := QtyMaxPrompt.1
	;	Prompt := QtyMaxPrompt.2
	;	;Msgbox %Prompt%	;Debug
	;}
	If (InStr(QtyMax, A_Space))
	{
		QtyMaxPrompt := StrSplit(QtyMax, A_Space)
		QtyMax := QtyMaxPrompt.1
		Prompt := QtyMaxPrompt.2
		;Msgbox %Prompt%	;Debug
	}
Loop, %QtyMax%
{
	;Condition
	{	;Collapse
	Random, CondRnd, 1, 34
		If CondRnd = 1
			Condition = Mint
		If CondRnd between 2 and 3
			Condition = Excellent
		If CondRnd between 4 and 6
			Condition = Very Good
		If CondRnd between 7 and 10
			Condition = Good
		If CondRnd between 11 and 14
			Condition = Light Wear
		If CondRnd between 15 and 20
			Condition = Medium Wear
		If CondRnd between 21 and 25
			Condition = Heavy Wear
		If CondRnd between 26 and 27
			Condition = Bloodstained
		If CondRnd between 28 and 31
			Condition = Tattered
		If CondRnd between 32 and 33
			Condition = Destroyed
		If CondRnd = 34
			Condition = Barely Recognizable
		;Msgbox %Condition%
	}
	If (Prompt != "")	;Prompt is not empty
		{
			WildCardPrompter:
			{
				Loot = %Prompt%
				;Msgbox %Loot%
				NC = 1
				
				Prompt_File = %Dir%\Banks\%Prompt%.ini
				Loop, Read, %Prompt_File%
					Prompt_Lines = %A_Index%
				Random, PromptRnd, 1, Prompt_Lines
				FileReadLine, PromptCho, %Prompt_File%, PromptRnd
				;Msgbox %PromptCho%	;Debug
				Loot := StrReplace(Loot, Loot, PromptCho)
			}
			
			If (Instr(Prompt, "gp"))
				{
					Loot = {1d20} gold pieces
				}
			If (Instr(Prompt, "gem"))
				{
					Loot = {GEM}
				}
			If (Instr(Prompt, "sp"))
				{
					Loot = {1d50} silver pieces
				}
			If (Instr(Prompt, "copper"))
				{
					Loot = {1d100} copper pieces
				}
			If (Instr(Prompt, "name"))
				{
					Loot = {NAME}
					NC = 1
				}
			If (Instr(Prompt, "flora"))
				{
					Loot = {FLORA}
					NC = 1
				}
			If (Instr(Prompt, "vegetable"))
				{
					Loot = {vegetable}
					NC = 1
				}
			If (Instr(Prompt, "fruit"))
				{
					Loot = {fruit}
					NC = 1
				}
			If (Instr(Prompt, "spell"))
				{
					Loot = {spell}
					NC = 1
				}
			If (Instr(Prompt, "rare"))
				{
					;Msgbox rarity set to Rare
					Rarity = 4_Rare.txt
					fLines = %4_Lines%
					;Msgbox %4_Lines%
					;NC = 1
				}
			If (Instr(Prompt, "vr"))
				{
					;Msgbox rarity set to Rare
					Rarity = 5_VeryRare.txt
					fLines = %5_Lines%
					;Msgbox %4_Lines%
					;NC = 1
				}
			If (Instr(Prompt, "dungeon"))
				{
					Loot = Dungeon
					NC = 1
				}
			If (Instr(Prompt, "pf"))
				{
					PF0 := StrSplit(Prompt, "pf")
					PF := PF0.2
					
					Loot = {PF-%PF%}
					;Msgbox %Loot%
					NC = 1
				}
			If (Instr(Prompt, "{"))
				{
					PF0 := StrSplit(Prompt, "{")
					PF := PF0.2
					
					Loot = {%PF%
					;Msgbox %Loot%
					NC = 1
				}
			Goto, Randomize	;Skip rarity tables
		}
	;Rarity	
	{	;Collapse
	Random, RarityRnd, 1, 100
		If Debug = 0
		{
			RarityRnd = 150
			Rarity = 0_Test.txt
			fLines = %0_Lines%
		}  
		If RarityRnd between 1 and 20	;Currency/gems
		{
			Random, CurrencyRnd, 1, 100
			{
				If CurrencyRnd between 1 and 60
					Type_Currency = {/r1d50} copper
				If CurrencyRnd between 61 and 80
					Type_Currency = {/r2d15} silver
				If CurrencyRnd between 81 and 90
					Type_Currency = {1d8} {GEM}s
				If CurrencyRnd between 91 and 100
					Type_Currency = {1d20} gold
			}
			Curr = %Type_Currency% pieces
			Loot = %CURR%
		}
		If RarityRnd between 21 and 40
		{
			Rarity = 1_Mundane.txt
			fLines = %1_Lines%
		}
		If RarityRnd between 41 and 80
		{
			Rarity = 2_Common.txt
			fLines = %2_Lines%
		}
		If RarityRnd between 81 and 94
		{
			Rarity = 3_Uncommon.txt
			fLines = %3_Lines%
		}
		If RarityRnd between 95 and 98
		{
			Rarity = 4_Rare.txt
			fLines = %4_Lines%
		}
		If RarityRnd between 99 and 100
		{
			Rarity = 5_VeryRare.txt
			fLines = %5_Lines%
		}
		;If RarityRnd = 100
		;{
		;	Rarity = 6_Legendary.txt
		;	fLines = %6_Lines%
		;}	
	}	
	
	
	Randomize:
	{
		Random, FirstRnd, 1, %fLines%
		Random, ColorRnd, 1, %C_Lines%
		Random, RaceRnd, 1, %Race_Lines%
		Random, RaceNamesRnd, 1, %RaceNames_Lines%
		FileReadLine, Loot, %Dir%\%Rarity%, %FirstRnd%
		FileReadLine, COLOR, %Dir%\Banks\Colors.ini, %ColorRnd%
		FileReadLine, RaceNames, %Dir%\Banks\RaceNames.txt, %RaceNamesRnd%
		COLOR := StrSplit(COLOR, A_Tab)
		Random, 1d100, 1, 100
		Random, 1d50, 1, 50
		Random, 1d20, 1, 20
		Random, 1d12, 1, 12
		Random, 1d8, 1, 8
		Random, 1d6, 1, 6
		Random, 1d4, 1, 4
		Random, 1d2, 1, 2
		FileReadLine, Race, %Dir%\Banks\Races.txt, RaceRnd
		;Msgbox Race:%Race% Noun:%Noun% Adj:%Adj%	;Testing
	}
		IfStatements:
		{	;Collapse
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
			If (InStr(Loot, "{PF-"))
			{	;Collapse
				PF0 := StrSplit(Loot, "{PF-")
				PF := PF0.2
				PF := StrReplace(PF, "}")
				;Msgbox %PF%
				
				PrefabFile = %Dir%\Banks\Prefabs\%PF%.ini
				Loop, Read, %PrefabFile%
					PF_Lines = %A_Index%
				Random, PFRnd, 1, PF_Lines
				FileReadLine, PFLine, %PrefabFile%, PFRnd
				;Msgbox %PFLine%	;Debug
				Loot := StrReplace(Loot, Loot, PFLine)
			}
			If (InStr(Loot, "{SUBJECT}"))
			{
				Random, SubjectRnd, 1, 8
					If SubjectRnd between 1 and 3
						Subject = {NOUN}
					If SubjectRnd between 4 and 5
						Subject = {NAME}
					If SubjectRnd = 6
						Subject = {LOC}
					If SubjectRnd between 7 and 8
						Subject = {BEAST}
				Loot := StrReplace(Loot, "{SUBJECT}", Subject,,1)
			}
			If (InStr(Loot, "{NAME}"))
			{
				GenderRnd:
				{
					Random, MF, 1, 2
					if (MF = "1")
						Gender = m
					if (MF = "2")
						Gender = f
				}
				NameImport:
				{	;Collapse
					NameDir = D:\Documents\Notes\DND\DND\Quartz\DM\Scripts\Names
					RaceNames = Human	;Debug
					FirstFile = %NameDir%\%RaceNames%\%RaceNames%_%Gender%.txt
					LastFile_0 = %NameDir%\%RaceNames%\%RaceNames%_s0.txt
					LastFile_1 = %NameDir%\%RaceNames%\%RaceNames%_s1.txt
					LastFile_2 = %NameDir%\%RaceNames%\%RaceNames%_s2.txt
					;Msgbox %FirstFile% %LastFile_2%	;Debug
				}
				CountNames:
				{	;Collapse
					Loop, Read, %FirstFile%
						firstLines = %A_Index%
					;Msgbox firstLines %firstLines%
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
				}
				GenName:
				{	;Collapse
					Random, FirstRnd, 1, %firstLines%
					Random, LastRnd_0, 1, %s0Lines%
					Random, LastRnd_1, 1, %s1Lines%
					Random, LastRnd_2, 1, %s2Lines%
					
					Read:
					FileReadLine, FirstName, %FirstFile%, %FirstRnd%
						;Msgbox %First%
					If FileExist(LastFile_0)
						FileReadLine, Last_0, %LastFile_0%, %LastRnd_0%
					FileReadLine, Last_1, %LastFile_1%, %LastRnd_1%
					FileReadLine, Last_2, %LastFile_2%, %LastRnd_2%
						StringLower, Last_2b, Last_2
					
					Output:
					If FileExist(LastFile_0)
					{
						Random, LastA, 1, 2
						if (LastA = 1)
							Goto, Combine
						Loop, Read, %LastFile_0%
						s0Lines = %A_Index%
						Name = %FirstName% %Last_0%
						Goto, End
					}
					Combine:
					Name = %FirstName% %Last_1%%Last_2b%
					;Msgbox %Name%
				}
				End:
				Loot := StrReplace(Loot, "{NAME}", Name,, 1)
			}
			If (InStr(Loot, "{PATTERN}"))
			{	;Collapse
				Loop, Read, %Dir%\Banks\Patterns.ini
					Patterns_Lines = %A_Index%
				Random, PatternsRnd, 1, Patterns_Lines
				FileReadLine, Patterns, %Dir%\Banks\Patterns.ini, PatternsRnd
				;Msgbox %Patterns%	;Debug
				Loot := StrReplace(Loot, "{PATTERN}", Patterns)
			}
			If (InStr(Loot, "{NOUN}"))
			{	;Collapse
				Random, 1d6, 1, 6
				Loop, Read, %Dir%\Banks\Nouns\NOUNs%1d6%.txt
					NOUNs_Lines = %A_Index%
				Random, NOUNsRnd, 1, NOUNs_Lines
				FileReadLine, NOUNs, %Dir%\Banks\Nouns\NOUNs%1d6%.txt, NOUNsRnd
				;Msgbox %NOUNs%	;Debug
				Loot := StrReplace(Loot, "{NOUN}", NOUNs,, 1)
			}
			If (InStr(Loot, "{ADJ}"))
			{	;Collapse
				Random, 1d12, 1, 12
				Loop, Read, %Dir%\Banks\ADJ\ADJ%1d12%.txt
					ADJs_Lines = %A_Index%
				Random, ADJsRnd, 1, ADJs_Lines
				FileReadLine, ADJs, %Dir%\Banks\ADJ\ADJ%1d12%.txt, ADJsRnd
				;Msgbox %ADJs%	;Debug
				Loot := StrReplace(Loot, "{ADJ}", ADJs,, 1)
			}
			If (InStr(Loot, "{EMBLEM}"))
			{	;Collapse
				Loop, Read, %Dir%\Banks\Misc\EMBLEMs.ini
					EMBLEM_Lines = %A_Index%
				Random, EMBLEMRnd, 1, EMBLEM_Lines
				FileReadLine, EMBLEM, %Dir%\Banks\Misc\EMBLEMs.ini, EMBLEMRnd
				;Msgbox %Beastiary%	;Debug
				Loot := StrReplace(Loot, "{EMBLEM}", EMBLEM)
			}
			If (InStr(Loot, "{FABRIC}"))
			{	;Collapse
				Loop, Read, %Dir%\Banks\Fabrics.ini
					Fabric_Lines = %A_Index%
				Random, FabricRnd, 1, Fabric_Lines
				FileReadLine, Fabrics, %Dir%\Banks\Fabrics.ini, FabricRnd
				;Msgbox %Patterns%	;Debug
				Loot := StrReplace(Loot, "{FABRIC}", Fabrics)
			}
			If (InStr(Loot, "{LANGUAGE}"))
			{	;Collapse
				Loop, Read, %Dir%\Banks\LANGUAGEs.ini
					LANGUAGE_Lines = %A_Index%
				Random, LANGUAGERnd, 1, LANGUAGE_Lines
				FileReadLine, LANGUAGEs, %Dir%\Banks\LANGUAGEs.ini, LANGUAGERnd
				;Msgbox %Patterns%	;Debug
				Loot := StrReplace(Loot, "{LANGUAGE}", LANGUAGEs)
			}
			If (InStr(Loot, "{BEAST}"))
			{	;Collapse
				Loop, Read, %Dir%\Banks\Beastiary\Global.txt
					Beastiary_Lines = %A_Index%
				Random, BeastiaryRnd, 1, Beastiary_Lines
				FileReadLine, Beastiary, %Dir%\Banks\Beastiary\Global.txt, BeastiaryRnd
				;Msgbox %Beastiary%	;Debug
				Loot := StrReplace(Loot, "{BEAST}", Beastiary)
			}
			If (InStr(Loot, "{Amphibian}"))
			{	;Collapse
				Loop, Read, %Dir%\Banks\Beastiary\Amphibian\%Habitat%.ini
					Amphibian_Lines = %A_Index%
				Random, AmphibianRnd, 1, Amphibian_Lines
				FileReadLine, Amphibian, %Dir%\Banks\Beastiary\Amphibian\%Habitat%.ini, AmphibianRnd
				;Msgbox %Mammals%	;Debug
				Loot := StrReplace(Loot, "{Amphibian}", Amphibian)
			}
			If (InStr(Loot, "{Bird}"))
			{	;Collapse
				Loop, Read, %Dir%\Banks\Beastiary\Birds\%Habitat%.ini
					Bird_Lines = %A_Index%
				Random, BirdRnd, 1, Bird_Lines
				FileReadLine, Bird, %Dir%\Banks\Beastiary\Birds\%Habitat%.ini, BirdRnd
				;Msgbox %Mammals%	;Debug
				Loot := StrReplace(Loot, "{Bird}", Bird)
			}
			If (InStr(Loot, "{Fish}"))
			{	;Collapse
				Loop, Read, %Dir%\Banks\Beastiary\Fish\%Habitat%.ini
					Fish_Lines = %A_Index%
				Random, FishRnd, 1, Fish_Lines
				FileReadLine, Fish, %Dir%\Banks\Beastiary\Fish\%Habitat%.ini, FishRnd
				;Msgbox %Mammals%	;Debug
				Loot := StrReplace(Loot, "{Fish}", Fish)
			}
			If (InStr(Loot, "{Insect}"))
			{	;Collapse
				Loop, Read, %Dir%\Banks\Beastiary\Insects\%Habitat%.ini
					Insect_Lines = %A_Index%
				Random, InsectRnd, 1, Insect_Lines
				FileReadLine, Insect, %Dir%\Banks\Beastiary\Insects\%Habitat%.ini, InsectRnd
				;Msgbox %Mammals%	;Debug
				Loot := StrReplace(Loot, "{Insect}", Insect)
			}
			If (InStr(Loot, "{Flora}"))
			{	;Collapse
				Loop, Read, %Dir%\Banks\Beastiary\Flora\%Habitat%.ini
					Flora_Lines = %A_Index%
				Random, FloraRnd, 1, Flora_Lines
				FileReadLine, Flora, %Dir%\Banks\Beastiary\Flora\%Habitat%.ini, FloraRnd
				;Msgbox %Mammals%	;Debug
				Loot := StrReplace(Loot, "{Flora}", Flora)
			}
			If (InStr(Loot, "{Monstrosity}"))
			{	;Collapse
				Loop, Read, %Dir%\Banks\Beastiary\Monstrosities\%Habitat%.ini
					Monstrosity_Lines = %A_Index%
				Random, MonstrosityRnd, 1, Monstrosity_Lines
				FileReadLine, Monstrosity, %Dir%\Banks\Beastiary\Monstrosities\%Habitat%.ini, MonstrosityRnd
				;Msgbox %Mammals%	;Debug
				Loot := StrReplace(Loot, "{Monstrosity}", Monstrosity)
			}
			If (InStr(Loot, "{REPTILE}"))
			{	;Collapse
				Loop, Read, %Dir%\Banks\Beastiary\Reptiles\%Habitat%.ini
					Reptile_Lines = %A_Index%
				Random, ReptileRnd, 1, Reptile_Lines
				FileReadLine, Reptile, %Dir%\Banks\Beastiary\Reptiles\%Habitat%.ini, ReptileRnd
				;Msgbox %Reptile%	;Debug
				Loot := StrReplace(Loot, "{REPTILE}", Reptile)
			}
			If (InStr(Loot, "{MAMMAL}"))
			{	;Collapse
				Loop, Read, %Dir%\Banks\Beastiary\Mammals\%Habitat%.ini
					Mammal_Lines = %A_Index%
				Random, MammalRnd, 1, Mammal_Lines
				FileReadLine, Mammal, %Dir%\Banks\Beastiary\Mammals\%Habitat%.ini, MammalRnd
				;Msgbox %Mammals%	;Debug
				Loot := StrReplace(Loot, "{MAMMAL}", Mammal)
			}
			If (InStr(Loot, "{RACENAME}"))
			{	;Collapse
				FileReadLine, RaceName, %Dir%\Banks\RaceNames.txt, RaceNamesRnd
				Loot := StrReplace(Loot, "{RACENAME}", RaceName)
			}
			If (InStr(Loot, "{LOC}"))
			{	;Collapse
				Loop, Read, %Dir%\Banks\Locations.ini
					Loc_Lines = %A_Index%
				Random, LocRnd, 1, Loc_Lines
				FileReadLine, Location, %Dir%\Banks\Locations.ini, LocRnd
				;Msgbox %Beastiary%	;Debug
				Loot := StrReplace(Loot, "{LOC}", Location)
			}
			If (InStr(Loot, "{GOD}"))
			{	;Collapse
				Loop, Read, %Dir%\Banks\Gods.ini
					Loc_Lines = %A_Index%
				Random, LocRnd, 1, Loc_Lines
				FileReadLine, God, %Dir%\Banks\Gods.ini, LocRnd
				;Msgbox %Beastiary%	;Debug
				Loot := StrReplace(Loot, "{GOD}", God)
			}
			If (InStr(Loot, "{REGION}"))
			{	;Collapse
				Loop, Read, %Dir%\Banks\Regions.ini
					Region_Lines = %A_Index%
				Random, RegionRnd, 1, Region_Lines
				FileReadLine, Region, %Dir%\Banks\Regions.ini, RegionRnd
				;Msgbox %Beastiary%	;Debug
				Loot := StrReplace(Loot, "{Region}", Region)
			}
			If (InStr(Loot, "{BEVERAGE}"))
			{	;Collapse
				Loop, Read, %Dir%\Banks\Foods\Beverages.ini
					BEVERAGE_Lines = %A_Index%
				Random, BEVERAGERnd, 1, BEVERAGE_Lines
				FileReadLine, BEVERAGE, %Dir%\Banks\Foods\BEVERAGEs.ini, BEVERAGERnd
				;Msgbox %Beastiary%	;Debug
				Loot := StrReplace(Loot, "{BEVERAGE}", BEVERAGE)
			}
			If (InStr(Loot, "{SAUCE}"))
			{	;Collapse
				Loop, Read, %Dir%\Banks\Foods\Sauces.ini
					SAUCE_Lines = %A_Index%
				Random, SAUCERnd, 1, SAUCE_Lines
				FileReadLine, SAUCE, %Dir%\Banks\Foods\SAUCEs.ini, SAUCERnd
				;Msgbox %Beastiary%	;Debug
				Loot := StrReplace(Loot, "{Sauce}", SAUCE)
			}
			If (InStr(Loot, "{WINE}"))
			{	;Collapse
				Loop, Read, %Dir%\Banks\Foods\WINEs.ini
					WINE_Lines = %A_Index%
				Random, WINERnd, 1, WINE_Lines
				FileReadLine, WINE, %Dir%\Banks\Foods\WINEs.ini, WINERnd
				;Msgbox %Beastiary%	;Debug
				Loot := StrReplace(Loot, "{WINE}", WINE)
			}
			If (InStr(Loot, "{WOOD}"))
			{	;Collapse
				Loop, Read, %Dir%\Banks\Misc\WOODs.ini
					WOOD_Lines = %A_Index%
				Random, WOODRnd, 1, WOOD_Lines
				FileReadLine, WOOD, %Dir%\Banks\Misc\WOODs.ini, WOODRnd
				;Msgbox %Beastiary%	;Debug
				Loot := StrReplace(Loot, "{WOOD}", WOOD)
			}
			If (InStr(Loot, "{SHAPE}"))
			{	;Collapse
				Loop, Read, %Dir%\Banks\Misc\SHAPEs.ini
					SHAPE_Lines = %A_Index%
				Random, SHAPERnd, 1, SHAPE_Lines
				FileReadLine, SHAPE, %Dir%\Banks\Misc\SHAPEs.ini, SHAPERnd
				;Msgbox %Beastiary%	;Debug
				Loot := StrReplace(Loot, "{SHAPE}", SHAPE)
			}
			If (InStr(Loot, "{FLAVOR}"))
			{	;Collapse
				Loop, Read, %Dir%\Banks\Flavors.ini
					Flavors_Lines = %A_Index%
				Random, FlavorsRnd, 1, Flavors_Lines
				FileReadLine, Flavors, %Dir%\Banks\Flavors.ini, FlavorsRnd
				;Msgbox %Beastiary%	;Debug
				Loot := StrReplace(Loot, "{FLAVOR}", Flavors)
			}
			If (InStr(Loot, "{GEM}"))
			{	;Collapse
				Loop, Read, %Dir%\Banks\Gems.ini
					Gems_Lines = %A_Index%
				Random, GemsRnd, 1, Gems_Lines
				FileReadLine, Gems, %Dir%\Banks\Gems.ini, GemsRnd
				;Msgbox %Gems%	;Debug
				Loot := StrReplace(Loot, "{GEM}", Gems)
			}
			If (InStr(Loot, "{ROLE}"))
			{	;Collapse
				Loop, Read, %Dir%\Banks\NPC\ROLEs.ini
					ROLEs_Lines = %A_Index%
				Random, ROLEsRnd, 1, ROLEs_Lines
				FileReadLine, ROLEs, %Dir%\Banks\NPC\ROLEs.ini, ROLEsRnd
				;Msgbox %ROLEs%	;Debug
				Loot := StrReplace(Loot, "{ROLE}", ROLEs)
			}
			If (InStr(Loot, "{POISON}"))
			{	;Collapse
				Loop, Read, %Dir%\Banks\WeaponsMundane\Poisons.ini
					POISONs_Lines = %A_Index%
				Random, POISONsRnd, 1, POISONs_Lines
				FileReadLine, POISONs, %Dir%\Banks\WeaponsMundane\Poisons.ini, POISONsRnd
				;Msgbox %POISONs%	;Debug
				Loot := StrReplace(Loot, "{POISON}", POISONs)
			}
			If (InStr(Loot, "{DRUG}"))
			{	;Collapse
				Loop, Read, %Dir%\Banks\Misc\DRUGs.ini
					DRUGs_Lines = %A_Index%
				Random, DRUGsRnd, 1, DRUGs_Lines
				FileReadLine, DRUGs, %Dir%\Banks\Misc\DRUGs.ini, DRUGsRnd
				;Msgbox %DRUGs%	;Debug
				Loot := StrReplace(Loot, "{DRUG}", DRUGs)
			}
			If (InStr(Loot, "{CHEESE}"))
			{	;Collapse
				Loop, Read, %Dir%\Banks\Foods\Cheese.ini
					cheeseLines = %A_Index%
				Random, cheeseRnd, 1, cheeseLines
				FileReadLine, Cheese, %Dir%\Banks\Foods\Cheese.ini, cheeseRnd
				;Msgbox %Cheese%	;Debug
				Loot := StrReplace(Loot, "{cheese}", Cheese)
			}
			If (InStr(Loot, "{SPICE}"))
			{	;Collapse
				Loop, Read, %Dir%\Banks\Foods\spices.ini
					spiceLines = %A_Index%
				Random, spiceRnd, 1, spiceLines
				FileReadLine, spice, %Dir%\Banks\Foods\spices.ini, spiceRnd
				;Msgbox %spice%	;Debug
				Loot := StrReplace(Loot, "{spice}", spice)
			}
			If (InStr(Loot, "{BREAD}"))
			{	;Collapse
				Loop, Read, %Dir%\Banks\Foods\BREADs.ini
					BREADLines = %A_Index%
				Random, BREADRnd, 1, BREADLines
				FileReadLine, BREAD, %Dir%\Banks\Foods\BREADs.ini, BREADRnd
				;Msgbox %BREAD%	;Debug
				Loot := StrReplace(Loot, "{BREAD}", BREAD)
			}
			If (InStr(Loot, "{FRUIT}"))
			{	;Collapse
				Loop, Read, %Dir%\Banks\Foods\FRUITs.ini
					FRUIT_Lines = %A_Index%
				Random, FRUITRnd, 1, FRUIT_Lines
				FileReadLine, FRUIT, %Dir%\Banks\Foods\FRUITs.ini, FRUITRnd
				;Msgbox %Beastiary%	;Debug
				Loot := StrReplace(Loot, "{FRUIT}", FRUIT)
			}
			If (InStr(Loot, "{Vegetable}"))
			{	;Collapse
				Loop, Read, %Dir%\Banks\Foods\Vegetables.ini
					Loc_Lines = %A_Index%
				Random, LocRnd, 1, Loc_Lines
				FileReadLine, Vegetable, %Dir%\Banks\Foods\Vegetables.ini, LocRnd
				;Msgbox %Beastiary%	;Debug
				Loot := StrReplace(Loot, "{Vegetable}", Vegetable)
			}
			If (InStr(Loot, "{Nut}"))
			{	;Collapse
				Loop, Read, %Dir%\Banks\Foods\Nuts.ini
					Loc_Lines = %A_Index%
				Random, LocRnd, 1, Loc_Lines
				FileReadLine, Nut, %Dir%\Banks\Foods\Nuts.ini, LocRnd
				;Msgbox %Beastiary%	;Debug
				Loot := StrReplace(Loot, "{Nut}", Nut)
			}
			If (InStr(Loot, "{BACKGROUND}"))
			{	;Collapse
				Loop, Read, %Dir%\Banks\NPC\BACKGROUNDs.ini
					BACKGROUNDLines = %A_Index%
				Random, BACKGROUNDRnd, 1, BACKGROUNDLines
				FileReadLine, BACKGROUND, %Dir%\Banks\NPC\BACKGROUNDs.ini, BACKGROUNDRnd
				;Msgbox %BACKGROUND%	;Debug
				Loot := StrReplace(Loot, "{BACKGROUND}", BACKGROUND)
			}
			If (InStr(Loot, "{CLASS}"))
			{	;Collapse
				Loop, Read, %Dir%\Banks\NPC\CLASSes.ini
					CLASSLines = %A_Index%
				Random, CLASSRnd, 1, CLASSLines
				FileReadLine, CLASS, %Dir%\Banks\NPC\CLASSes.ini, CLASSRnd
				;Msgbox %CLASS%	;Debug
				Loot := StrReplace(Loot, "{CLASS}", CLASS)
			}
			If (InStr(Loot, "{EXPRESSION}"))
			{	;Collapse
				Loop, Read, %Dir%\Banks\NPC\EXPRESSIONs.ini
					EXPRESSIONLines = %A_Index%
				Random, EXPRESSIONRnd, 1, EXPRESSIONLines
				FileReadLine, EXPRESSION, %Dir%\Banks\NPC\EXPRESSIONs.ini, EXPRESSIONRnd
				;Msgbox %EXPRESSION%	;Debug
				Loot := StrReplace(Loot, "{EXPRESSION}", EXPRESSION)
			}
			If (InStr(Loot, "{FAMILY}"))
			{	;Collapse
				Loop, Read, %Dir%\Banks\NPC\FAMILYs.ini
					FAMILYLines = %A_Index%
				Random, FAMILYRnd, 1, FAMILYLines
				FileReadLine, FAMILY, %Dir%\Banks\NPC\FAMILYs.ini, FAMILYRnd
				;Msgbox %FAMILY%	;Debug
				Loot := StrReplace(Loot, "{FAMILY}", FAMILY)
			}
			If (InStr(Loot, "{TRAIT}"))
			{	;Collapse
				Loop, Read, %Dir%\Banks\NPC\TRAITs.ini
					TRAITLines = %A_Index%
				Random, TRAITRnd, 1, TRAITLines
				FileReadLine, TRAIT, %Dir%\Banks\NPC\TRAITs.ini, TRAITRnd
				;Msgbox %TRAIT%	;Debug
				Loot := StrReplace(Loot, "{TRAIT}", TRAIT)
			}
			If (InStr(Loot, "{ANATOMY}"))
			{	;Collapse
				Loop, Read, %Dir%\Banks\Misc\ANATOMY.ini
					ANATOMYLines = %A_Index%
				Random, ANATOMYRnd, 1, ANATOMYLines
				FileReadLine, ANATOMY, %Dir%\Banks\Misc\ANATOMY.ini, ANATOMYRnd
				;Msgbox %ANATOMY%	;Debug
				Loot := StrReplace(Loot, "{ANATOMY}", ANATOMY)
			}
			If (InStr(Loot, "{FOOD}"))
			{	;Collapse
				Loop, Read, %Dir%\Banks\FOODs.ini
					Loc_Lines = %A_Index%
				Random, LocRnd, 1, Loc_Lines
				FileReadLine, FOOD, %Dir%\Banks\FOODs.ini, LocRnd
				;Msgbox %Beastiary%	;Debug
				Loot := StrReplace(Loot, "{FOOD}", FOOD)
			}
			If (InStr(Loot, "{Material}"))
			{	;Collapse
				Loop, Read, %Dir%\Banks\Materials.ini
					Loc_Lines = %A_Index%
				Random, LocRnd, 1, Loc_Lines
				FileReadLine, Material, %Dir%\Banks\Materials.ini, LocRnd
				;Msgbox %Beastiary%	;Debug
				Loot := StrReplace(Loot, "{Material}", Material)
			}
			If (InStr(Loot, "{SPELL}"))
			{	;Collapse
				Random, SpellRnd, 0, 100
				{	;Collapse
					If SpellRnd between 0 and 50
						SpellTable = 0
					If SpellRnd between 51 and 64
						SpellTable = 1
					If SpellRnd between 65 and 74
						SpellTable = 2
					If SpellRnd between 75 and 81
						SpellTable = 3
					If SpellRnd between 82 and 87
						SpellTable = 4
					If SpellRnd between 88 and 92
						SpellTable = 5
					If SpellRnd between 93 and 96
						SpellTable = 6
					If SpellRnd between 97 and 98
						SpellTable = 7
					If SpellRnd = 99
						SpellTable = 8
					If SpellRnd = 100
						SpellTable = 9
				}
				
				Loop, Read, %Dir%\Banks\Spells\%SpellTable%.ini
					SPELL_Lines = %A_Index%
				Random, SPELLRnd, 1, SPELL_Lines
				FileReadLine, SPELL, %Dir%\Banks\Spells\%SpellTable%.ini, SPELLRnd
				;Msgbox %Beastiary%	;Debug
				Loot := StrReplace(Loot, "{SPELLTABLE}", SpellTable)
				Loot := StrReplace(Loot, "{SPELL}", SPELL)
			}
			If (InStr(Loot, "{EFFECT}"))
			{	;Collapse
				Random, EFFECTRnd, 0, 100
				{	;Collapse
					If EFFECTRnd between 0 and 70
						EFFECTTable = Effect
					If EFFECTRnd between 61 and 94
						EFFECTTable = Condition
					If EFFECTRnd between 95 and 100
						EFFECTTable = Disease
				}
				Loop, Read, %Dir%\Banks\EFFECTs\%EFFECTTable%.ini
					EFFECT_Lines = %A_Index%
				Random, EFFECTRnd, 1, EFFECT_Lines
				FileReadLine, EFFECT, %Dir%\Banks\EFFECTs\%EFFECTTable%.ini, EFFECTRnd
				;Msgbox %Beastiary%	;Debug
				Loot := StrReplace(Loot, "{EFFECT}", EFFECT)
			}
			If (InStr(Loot, "{DURATION}"))
			{	;Collapse
				Loop, Read, %Dir%\Banks\Effects\Duration.ini
					DURATION_Lines = %A_Index%
				Random, DURATIONRnd, 1, DURATION_Lines
				FileReadLine, DURATION, %Dir%\Banks\Effects\Duration.ini, DURATIONRnd
				;Msgbox %Beastiary%	;Debug
				Loot := StrReplace(Loot, "{DURATIONTABLE}", DURATIONTable)
				Loot := StrReplace(Loot, "{DURATION}", DURATION)
			}
			If (InStr(Loot, "{ABILITY}"))
			{	;Collapse
				Loop, Read, %Dir%\Banks\Effects\ABILITY.ini
					ABILITY_Lines = %A_Index%
				Random, ABILITYRnd, 1, ABILITY_Lines
				FileReadLine, ABILITY, %Dir%\Banks\Effects\ABILITY.ini, ABILITYRnd
				;Msgbox %Beastiary%	;Debug
				Loot := StrReplace(Loot, "{ABILITYTABLE}", ABILITYTable)
				Loot := StrReplace(Loot, "{ABILITY}", ABILITY)
			}
			If (InStr(Loot, "{bonusmod}"))
			{	;Collapse
				Loop, Read, %Dir%\Banks\Effects\bonusmod.ini
					bonusmod_Lines = %A_Index%
				Random, bonusmodRnd, 1, bonusmod_Lines
				FileReadLine, bonusmod, %Dir%\Banks\Effects\bonusmod.ini, bonusmodRnd
				;Msgbox %Beastiary%	;Debug
				Loot := StrReplace(Loot, "{bonusmodTABLE}", bonusmodTable)
				Loot := StrReplace(Loot, "{bonusmod}", bonusmod)
			}
			If (InStr(Loot, "{/r"))
			{	;Collapse
				rollX := StrSplit(Loot, "{/r")
				Roll := rollX.2
				Roll := StrReplace(Roll, "}")
				
				Dice := StrSplit(Roll, "d")
				nDice := Dice.1
				Value := Dice.2
				
				DiceSum := 0
				Loop, %nDice%
				{
					Random, DiceRoll, 1, %Value%
					;Msgbox %DiceRoll%
					DiceSum += %DiceRoll%
				}
				Loot := RegexReplace(Loot, "{/r.+}", DiceSum)
			}
			LootReplacements:
			{	;Collapse
				Loot := StrReplace(Loot, "{1d100}", 1d100)
				Loot := StrReplace(Loot, "{1d50}", 1d50)
				Loot := StrReplace(Loot, "{1d20}", 1d20)
				Loot := StrReplace(Loot, "{1d12}", 1d12)
				Loot := StrReplace(Loot, "{1d8}", 1d8)
				Loot := StrReplace(Loot, "{1d6}", 1d6)
				Loot := StrReplace(Loot, "{1d4}", 1d4)
				Loot := StrReplace(Loot, "{1d2}", 1d2)
				Loot := StrReplace(Loot, "{COLOR}", COLOR.1)
				Loot := StrReplace(Loot, "{COLOR}", COLOR.1)
				Loot := StrReplace(Loot, "{RACE}", Race)
				Loot := StrReplace(Loot, A_Tab, "`n`n")
			}
			If (InStr(Loot, "{hp}"))
			{	;Collapse
				Random, hpRnd, 1, %Level%
				hp := Round(hpRnd * 7 / 2.6)
				;Msgbox %hp%
				
				Loot := StrReplace(Loot, "{hp}", hp)
			}
			If (InStr(Loot, "["))	;Gamebooks
			{	;Collapse
				LootSplit := StrSplit(Loot, "[")
				If (InStr(Loot, " ["))
					LootSplit := StrSplit(Loot, " [")
				HB := LootSplit.2
				HB := StrReplace(HB, "]")
				;Msgbox %HB%
				If (InStr(HB, "http"))
					{
						URL%A_Index% = %HB%
						;Msgbox %URL1% %URL2%
						Loot := RegexReplace(Loot, "\[.+\]", "+")
						Goto, GamebooksEnd
					}
				Loot := LootSplit.1
				Item := StrReplace(Loot, " ", "%20")
				Loot = %Loot% +	;+ button
				URL = https://5e.tools/items.html#%Item%_%HB%
				;Msgbox %URL%
				GamebooksEnd:
			}
			If (InStr(Loot, "{CASE}"))	;Mixed case, use for titles
				{
					Loot := StrReplace(Loot, "{CASE}",,, 1)
					StringUpper, Loot, Loot, T
				}
			If (InStr(Loot, "{UP}"))	;Use to uppercase individual tags
				{
					RegExMatch(Loot, "\{UP\}." , LetterPos, 1)	;Match
						;Msgbox %LetterPos%	;debug
					UpString := StrSplit(LetterPos, "{UP}")
						;Msgbox % NextLetter.2	;debug
					NextLetter := UpString.2
					StringUpper, NextLetter, NextLetter, T	;uppercase
					Loot := StrReplace(Loot, LetterPos, NextLetter)
				}
			If (InStr(Loot, "`t"))	;Tab
				{
					Loot := StrReplace(Loot, A_TAB, "`n`n")
				}
			If (InStr(Loot, "{"))	;Final check
				{
					Goto, IfStatements
				}
		}
		If NC = 0
		{
			Generation = {%Condition%} %Loot%
			;Clipboard = %Generation%
		}
		If NC = 1
		{
			Generation = %Loot%
			;Clipboard = %Generation%
		}
		
		GUICode:
		{
			Action := []
			Action%A_Index% = %Generation%
			;Msgbox %Action1%
			GUI, Color, 050505	;GUI bg color
			Gui, Font, s10 cGray, Centaur
			GUI, add, text, gAction, (%CONDITION%) %Rarity%
			
			Gui, Font, s14 cWhite, Centaur bold
			GUI, add, button, gAction w700, %Loot%
		}
}	;End of Qty loop

;Goto, Start

GUIShow:
{
	Gui -Caption
	Gui, Show, AutoSize Center
	Winset, Alwaysontop, , A
	pause
}

Click:
{
Msgbox test
}

Action:
{
	MouseGetPos, , , id, control
	MouseGetPos, , , class, classNN
	Index := StrReplace(classNN, "button")
	Index = % URL%Index%
	;Msgbox %Index%
	GuiControlGet buttonText, , %control%
	Clipboard = ## %buttonText%`n`n
	
	FoundryImport:
		{
		FoundryCheck:
			{
			SetTitleMatchMode, 2
			if WinExist("Foundry Virtual Tabletop")
				Winactivate, Foundry Virtual Tabletop
			else
			{
				;Msgbox,,,Foundry instance not found. Returning...,2
				Goto, ActionEnd
			}
		}
		Send ^v
		ActionEnd:
		If (HB != "")	;Gamebooks
		{
			Run, %Index%
		}
	}
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