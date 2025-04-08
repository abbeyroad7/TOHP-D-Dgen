#Requires AutoHotkey v1.1+
#SingleInstance Force

Race_Cha:
{
	If (Race = "Merfolk" || "Dragonborn" || "Kalashtar" || "Djinn" || "Halfling")
		CHA := CHA + 1
	If (Race = "Aasimar" || "Luma" || "Siren" || "Changeling" || "Half-Elf" || "Verdan" || "Tiefling" || "Hedge")
		CHA := CHA + 2
}

Race_Con:
{
	If (Race = "Human" || "Verdan" || "Goliath" || "Squaloan" || "Half-Orc" || "Minotaur" || "Orc" || "Mapach" || "Giant" || "Ogre" || "Siren" || "Troll")
		CON := CON + 1
	If (Race = "Cervan" || "Dwarf" || "Genasi" || "Simic" || "Warforged" || "Hobgoblin" || "Whalekin" || "Naga" || "Leonin" || "Lizardfolk" || "Loxodon" || "Duergar" || "Autognome" || "Arboren" || "Construct" || "Fiend" || "Half-Dwarf" || "Myconid" || "Finrin" || "Plasmoid" || "Porcein")
		CON := CON + 2
}

Race_Dex:
{
	If (Race = "Finrin")
		DEX := DEX - 1
	If (Race = "Human" || "Bugbear" || "Locathah" || "Cervan" || "Hedge" || "Luma" || "Skaven" || "Ursine")
		DEX := DEX + 1
	If (Race = "Elf" || "Drow" || "Halfling" || "Kobold" || "Goblin" || "Grung" || "Khenra" || "Aarakocra" || "Kenku" || "Kor" || "Tabaxi" || "Harengon" || "Amphibimen" || "Gnoll" || "Lupin" || "Thri-Kreen")
		DEX := DEX + 2
}

Race_Int:
{
	If (Race = "Human" || "Tiefling" || "Hobgoblin" || "Naga" || "Githyanki" || "Githzerai" || "Drow" || "Half-Elf" || "Loxodon" || "Porcein")
		INT := INT + 1
	If (Race = "Gnome" || "Vedalken" || "Djinn" || "Skaven")
		INT := INT + 2
}

Race_Str:
{
	If (Race = "Human" || "Leonin" || "Khenra" || "Whalekin" || "Firbolg" || "Autognome" || "Aarakocra" || "Construct" || "Dwarf" || "Gnoll" || "Kobold" || "Warforged")
		STR := STR + 1
	If (Race = "Dragonborn" || "Goliath" || "Half-Orc" || "Minotaur" || "Orc" || "Bugbear" || "Squaloan" || "Locathah" || "Githyanki" || "Centaur" || "Giff" || "Finrin" || "Fiend" || "Giant" || "Half-Giant" || "Ogre" || "Troll" || "Ursine")
		STR := STR + 2
}

Race_Wis:
{
	If (Race = "Human" || "Centaur" || "Vedalken" || "Arboren" || "Elf" || "Kor" || "Myconid")
		WIS := WIS + 1
	If (Race = "Gallus" || "Kalashtar" || "Mapach" || "Githzerai" || "Firbolg"  || "Tortle")
		WIS := WIS + 2
}

Race_Any:
{
	AbilityScoreProficiency_Rnd1:
	{
		Random, AnyRnd, 1, 6
		If AnyRnd = 1
			Any = CHA
		If AnyRnd = 2
			Any = CON
		If AnyRnd = 3
			Any = DEX
		If AnyRnd = 4
			Any = INT
		If AnyRnd = 5
			Any = STR
		If AnyRnd = 6
			Any = INT
	}
	If (Race = "Yuan-Ti" || "Triton" || "Tortle" || "Thri-Kreen" || "Tabaxi" || "Shifter" || "Shadar-Kai" || "Satyr" || "Plasmoid" || "Owlin" || "Kenku" || "Kender" || "Hexblood" || "Harengon" || "Hadozee" || "Goblin" || "Giff" || "Fairy" || "Eladrin" || "Duergar" || "Dhampir" || "Changeling" || "Aasimar" || "Gnome" || "Amphibimen" || "Floran" || "Gallus" || "Genasi" || "Grung" || "Half-Giant" || "Half-Dwarf" || "Lupin" || "Simic")
		%Any% := %Any% + 1
	;Msgbox %Any%
	AbilityScoreProficiency_Rnd2:
	{
		Random, AnyRnd, 1, 6
		If AnyRnd = 1
			Any = CHA
		If AnyRnd = 2
			Any = CON
		If AnyRnd = 3
			Any = DEX
		If AnyRnd = 4
			Any = INT
		If AnyRnd = 5
			Any = STR
		If AnyRnd = 6
			Any = INT
	}
	If (Race = "Yuan-Ti" || "Triton" || "Shifter" || "Shadar-Kai" || "Satyr" || "Owlin" || "Kender" || "Hexblood" || "Hadozee" || "Fairy" || "Eladrin" || "Dhampir" || "Floran" || "Merfolk")
		%Any% := %Any% + 2
	;Msgbox %Any%
}

Race_Deity:
{
	If (Race = "Deity")
	{
		CHA := 24
		CON := 24
		DEX := 24
		INT := 24
		STR := 24
		WIS := 24
		
		DeityRnd1:
		{
			Random, AnyRnd, 1, 6
			If AnyRnd = 1
				Any = CHA
			If AnyRnd = 2
				Any = CON
			If AnyRnd = 3
				Any = DEX
			If AnyRnd = 4
				Any = INT
			If AnyRnd = 5
				Any = STR
			If AnyRnd = 6
				Any = INT
		}
		%Any% := 30
		DeityRnd2:
		{
			Random, AnyRnd, 1, 6
			If AnyRnd = 1
				Any = CHA
			If AnyRnd = 2
				Any = CON
			If AnyRnd = 3
				Any = DEX
			If AnyRnd = 4
				Any = INT
			If AnyRnd = 5
				Any = STR
			If AnyRnd = 6
				Any = INT
		}
		%Any% := 30
		DeityRnd3:
		{
			Random, AnyRnd, 1, 6
			If AnyRnd = 1
				Any = CHA
			If AnyRnd = 2
				Any = CON
			If AnyRnd = 3
				Any = DEX
			If AnyRnd = 4
				Any = INT
			If AnyRnd = 5
				Any = STR
			If AnyRnd = 6
				Any = INT
		}
		%Any% := 30
	}
}
Race_Beast:
{
	If (Race = "Beast")	;Beasts typically have low INT/CHA, high DEX/STR, using below modifiers
	{
		INT := Round(INT / 2.5)
		CHA := Round(CHA / 2.25)
		DEX := Round(DEX * 1.2)
		STR := Round(STR * 1.3)
	}
}

Race_Check:
{
	If (Race = "Deity" || Race = "Fiend" || Race = "Beast")
		Goto, Cap_StatsEnd
	Else
		Goto, Cap_Stats
}

Cap_Stats:
{
	If (CHA > 20)
		CHA := 20
	If (CON > 20)
		CON := 20
	If (DEX > 20)
		DEX := 20
	If (INT > 20)
		INT := 20
	If (STR > 20)
		STR := 20
	If (WIS > 20)
		WIS := 20
	;Msgbox %WIS%
}

Cap_StatsEnd: