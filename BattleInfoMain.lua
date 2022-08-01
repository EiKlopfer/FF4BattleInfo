

TextTable={[0]="?", [66]="A", [67]="B", [68]="C", [69]="D", [70]="E", [71]="F", [72]="G", [73]="H", [74]="I", [75]="J", [76]="K", [77]="L", [78]="M", [79]="N", [80]="O", [81]="P", [82]="Q", [83]="R", [84]="S", [85]="T", [86]="U", [87]="V", [88]="W", [89]="X", [90]="Y", [91]="Z", [92]="a", [93]="b", [94]="c", [95]="d", [96]="e", [97]="f", [98]="g", [99]="h", [100]="i", [101]="j", [102]="k", [103]="l", [104]="m", [105]="n", [106]="o", [107]="p", [108]="q", [109]="r", [110]="s", [111]="t", [112]="u", [113]="v", [114]="w", [115]="x", [116]="y", [117]="z", [128]="0", [129]="1", [130]="2", [131]="3", [132]="4", [133]="5", [134]="6", [135]="7", [136]="8", [137]="9", [192]="'", [193]=".", [194]="-", [195]="…", [196]="!", [197]="?", [198]="%", [199]="/", [200]=":", [201]=",", [255]=""}
BossFormations={[224]=1,[432]=2,[430]=3,[228]=4,[423]=5,[434]=6,[221]=6,[231]=7,[256]=8,[509]=9,[222]=10,[433]=11,[220]=11,[431]=12,[438]=14,[250]=15,[229]=16,[242]=17,[426]=18,[254]=18,[429]=19,[425]=20,[437]=21,[232]=22,[226]=23,[227]=24,[246]=25,[225]=26,[223]=27,[428]=28,[237]=29,[506]=30,[507]=31,[510]=32,[427]=33,[255]=33,[234]=34,[239]=35,[508]=36,[439]=37,[479]=38,[394]=39,[200]=40,[194]=41,[348]=42,[349]=42,[350]=42,[351]=42,[236]=44,[230]=45,[252]=45}
FormationIDToBoss={"Antlion",'Asura','Bahamut','Baigan','Calbrena','CPU','DarkElf','DarkImps','DLunars','DMist','Elements','EvilWall','FabulGauntlet','Golbez','Guard','Kainazzo','Karate','KingQueen','Leviatan','LugaeBalnab','Lugae','Magus','Milon','MilonZ','MirrorCecil','MomBomb','OctoMann','Odin','Officer','Ogopogo','PaleDim','Plague','Rubicant','Valvalis','WaterHag','Wyvern','Zeromus','Egg','Ryus','Dmachine','MacGiant','TrapDoors','Misc','Package','DarkElfCutscene'}
local currentBattleData={}
local partyBattleData={}
local additionalBossTips = {}
local bossName = nil
local recordedBattle = false
local tipDisplayLevel = 2
local tipDisplayChangeCooldown = 0
local started = false

-- load the file containing more detailed boss tips
local bossTipsText = require "BossSpecificData"

local function changeTipDisplayLevel()
	local heldButtons = joypad.getdown(1)
	if (tipDisplayChangeCooldown <= 50 and heldButtons["Y"] and heldButtons["L"]) then
		tipDisplayLevel = (tipDisplayLevel + 1) % 3
		tipDisplayChangeCooldown = 70	
	end
	if (tipDisplayChangeCooldown > 0) then
		tipDisplayChangeCooldown = tipDisplayChangeCooldown - 1
	end
end

local function calcAgi(targetAgility, anchorAgility)
	if anchorAgility == 0 then
		return 1
	end
	return math.max( math.floor( (anchorAgility * 5) / (targetAgility) ), 1)
end


local function beforeEveryFrame()
	local menu = memory.readbyte(0x7E0500)	
	
	changeTipDisplayLevel()
	
	if(started) then
		local battle = memory.readbyte(0x7E0140)
		if (battle == 1 and not recordedBattle) then
			recordedBattle = true
			local formID = memory.readword(0x7e1800)
			bossName = FormationIDToBoss[BossFormations[formID]]
			
			local anchorAgi = -1	
			local partySize = 0			
			for i=0,4 do
				local firstCharByte = memory.readbyte(0x7E2000 +0x80 * i )
				charData = {}
				if firstCharByte ~= 0 then					
					charData.agility = memory.readbyte(0x7E2000 + 0x80 * i + 0x15 )
					if anchorAgi == -1 then
						anchorAgi = charData.agility					
					end
					charData.relAgi = calcAgi(charData.agility, anchorAgi)
					partyBattleData[i] = charData
					partySize = partySize + 1
				end				
			end
			
			for i=0,2 do
				local currentEnemyId = memory.readbyte(0x7E29AD + i)
				-- 255 is for no enemy and 200 is the pre transformed Z, just special case hiding that to avoid confusion with trasnformed Z
				if currentEnemyId ~= 255 and currentEnemyId ~= 200 then					
					local enemyPosition = 0
					local enemyGroupAtCurrentPosition = memory.readbyte(0x7E29BD + enemyPosition)
					while (enemyGroupAtCurrentPosition ~= i) do
						enemyPosition = enemyPosition + 1
						enemyGroupAtCurrentPosition = memory.readbyte(0x7E29BD + enemyPosition)
					end					
					local enemyStatsStartLoc = 0x7E2287 + 0x80 * enemyPosition
					
					
					local monsterData = {}
					local monsterName = ""
					
					if currentEnemyId == 193 then
						monsterName = "Mil/Rubi"
					elseif currentEnemyId == 194 then
						monsterName = "Kain/Val"
					elseif currentEnemyId == 201 then
						-- hide transformed Zeromus name because that is more fun
						monsterName = "Z?"
					else					
						local monsterNameEntryStartingLocation = 0x0E8000 + 0x1800 + 8 * currentEnemyId
						for j=0,7 do
							local nextChar = memory.readbyte(monsterNameEntryStartingLocation  + j)
							monsterName = monsterName .. TextTable[nextChar]
						end
					end
					
					monsterData.id = currentEnemyId					
					monsterData.name = monsterName
					monsterData.currentHp = memory.readword(enemyStatsStartLoc)
					monsterData.maxHp = memory.readword(enemyStatsStartLoc+2)
					monsterData.spellPower = memory.readbyte(enemyStatsStartLoc+11)			
					monsterData.agility = memory.readbyte(enemyStatsStartLoc+14)
					monsterData.relAgi = calcAgi(monsterData.agility, anchorAgi)
					monsterData.attackMult = memory.readbyte(enemyStatsStartLoc+20)
					monsterData.hitAccuracy = memory.readbyte(enemyStatsStartLoc+21)
					monsterData.attackPower = memory.readbyte(enemyStatsStartLoc+22)					
					currentBattleData[i] = monsterData
				end				
			end
			
			if bossTipsText[bossName] ~= nil then
				additionalBossTips = bossTipsText[bossName](currentBattleData, partyBattleData, partySize)
			end			
			
		else
			if (battle ~= 1) then
				-- not in battle, clear last battle info and get ready to record again
				recordedBattle = false
				currentBattleData={}
				partyBattleData={}
				additionalBossTips = {}
				bossName = nil
			end			
		end
	else		
		if not (menu == 170) then
			notInBattle = true
			started=true
		end
	end
end




local charTopToBottomToPriority = {1,3,0,4,2}

local function drawTips()
	if tipDisplayChangeCooldown > 0 then
		gui.text(80,100, string.format("Tip Display Level Changed To %-1d", tipDisplayLevel))
	end
	
	if not started then
		gui.text(40,28, "Battle Info Script Loaded - NOT RACE LEGAL")
		gui.text(40,38, string.format("Tip Display Level Currently %-1d", tipDisplayLevel))
		gui.text(40,48, string.format("Press L + Y at any time to change Tip Display Level", tipDisplayLevel))
	end


	if recordedBattle and tipDisplayLevel > 0 then
	
		local startingCharNamesHeight = 154
		local linesPrinted = 1
		gui.text(0,0, string.format("%-8s  %5s  %3s  %6s  %8s  %7s  %6s  %4s", "Name", "MaxHP", "Agi", "RelAgi" , "SpellPow", "AtkMult", "AtkPow", "Acc%"		))		
		-- party data, printing just rel agi down with names and HP. Some wonkiness to handle non full parties
		-- hiding this for now if in item or spell menu
		local battleCursorState = memory.readbyte(0x7E1823)
		if (battleCursorState ~= 5 and battleCursorState ~= 6 and battleCursorState ~= 11 
				and battleCursorState ~= 12 and battleCursorState ~= 15 and battleCursorState ~= 16) then
			gui.text(145,145,string.format("%-6s", "RelAgi"))
			for index=1,5 do
				local i = charTopToBottomToPriority[index]
				local charData = partyBattleData[i]
				if charData ~= nil then
					gui.text(145, startingCharNamesHeight + 12 * (linesPrinted-1), string.format("%6d", charData.relAgi))
					linesPrinted = linesPrinted + 1
				end
			end
		end
		
		-- enemy data
		linesPrinted = 1
		for i=0,2 do
			local monsterData = currentBattleData[i]
			if monsterData ~= nil then				
				gui.text(0,10*(linesPrinted), string.format("%-8s  %5d  %3d  %6d  %8d  %7d  %6d  %4d", 
					monsterData.name, monsterData.maxHp, monsterData.agility, monsterData.relAgi, 
					monsterData.spellPower, monsterData.attackMult, monsterData.attackPower, 
					monsterData.hitAccuracy))					
				linesPrinted = linesPrinted + 1
			end
		end
		
		-- additional boss tips if display level is high
		if (tipDisplayLevel > 1) then
			for lineEntry, bossTipLine in ipairs(additionalBossTips) do
				gui.text(0,10*(linesPrinted), bossTipLine)
				linesPrinted = linesPrinted + 1
			end
		end
		
	end
end

local function myexit()
	if(Exited) then
		return
	else	
		Exited=true
		emu.registerbefore(nil)
		emu.registerexit(nil)
		gui.register(nil)
		memory.registerexec(0x03F591,1,nil)
		memory.registerwrite(0x7e1520,32,nil)
	end
end

emu.registerbefore(beforeEveryFrame)
gui.register(drawTips)
emu.registerexit(myexit)


