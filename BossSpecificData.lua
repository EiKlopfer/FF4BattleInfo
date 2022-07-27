local BossTipsText = {}

function dummy()
	monsterData.id = monsterId
	--monsterData.name = EnemyIdToName[monsterId+1]
	monsterData.name = monsterName
	monsterData.currentHp = memory.readword(enemyStatsStartLoc)
	monsterData.maxHp = memory.readword(enemyStatsStartLoc+2)
	monsterData.spellPower = memory.readbyte(enemyStatsStartLoc+11)			
	monsterData.agility = memory.readbyte(enemyStatsStartLoc+14)
	monsterData.relAgi = calcAgi(monsterData.agility, anchorAgi)
	monsterData.attackMult = memory.readbyte(enemyStatsStartLoc+20)
	monsterData.hitAccuracy = memory.readbyte(enemyStatsStartLoc+21)
	monsterData.attackPower = memory.readbyte(enemyStatsStartLoc+22)
end


function BossTipsText.Antlion(battleData)
	return {}
end


function BossTipsText.Asura(battleData)
	return {}
end


function BossTipsText.Bahamut(battleData)
	return {}
end


function BossTipsText.Baigan(battleData)
	return {}
end


function BossTipsText.Calbrena(battleData)
	return {}
end


function BossTipsText.CPU(battleData)
	return {}
end


function BossTipsText.DarkElf(battleData)
	return {}
end


function BossTipsText.DarkImps(battleData)
	return {}
end


function BossTipsText.DLunars(battleData)
	return {}
end


function BossTipsText.DMist(battleData)
	local bossTips = {}
	bossTips[1] = "Test tip here!"
	bossTips[2] = string.format("This monster has %d attack power, neat!", battleData[0].attackPower)
	return bossTips
end


function BossTipsText.Elements(battleData)
	return {}
end


function BossTipsText.EvilWall(battleData)
	return {}
end


function BossTipsText.FabulGauntlet(battleData)
	return {}
end


function BossTipsText.Golbez(battleData)
	return {}
end


function BossTipsText.Guard(battleData)
	return {}
end


function BossTipsText.Kainazzo(battleData)
	return {}
end


function BossTipsText.Karate(battleData)
	return {}
end


function BossTipsText.KingQueen(battleData)
	return {}
end


function BossTipsText.Leviatan(battleData)
	return {}
end


function BossTipsText.LugaeBalnab(battleData)
	return {}
end


function BossTipsText.Lugae(battleData)
	return {}
end


function BossTipsText.Magus(battleData)
	return {}
end


function BossTipsText.Milon(battleData)
	return {}
end


function BossTipsText.MilonZ(battleData)
	return {}
end


function BossTipsText.MirrorCecil(battleData)
	return {}
end


function BossTipsText.MomBomb(battleData)
	return {}
end


function BossTipsText.OctoMann(battleData)
	return {}
end


function BossTipsText.Odin(battleData)
	return {}
end


function BossTipsText.Officer(battleData)
	return {}
end


function BossTipsText.Ogopogo(battleData)
	return {}
end


function BossTipsText.PaleDim(battleData)
	return {}
end


function BossTipsText.Plague(battleData)
	return {}
end


function BossTipsText.Rubicant(battleData)
	return {}
end


function BossTipsText.Valvalis(battleData)
	return {}
end


function BossTipsText.WaterHag(battleData)
	return {}
end


function BossTipsText.Wyvern(battleData)
	return {}
end


function BossTipsText.Zeromus(battleData)
	return {}
end


function BossTipsText.Egg(battleData)
	return {}
end


function BossTipsText.Ryus(battleData)
	return {}
end


function BossTipsText.Dmachine(battleData)
	return {}
end


function BossTipsText.MacGiant(battleData)
	return {}
end


function BossTipsText.TrapDoors(battleData)
	return {}
end


function BossTipsText.Misc(battleData)
	return {}
end


function BossTipsText.Package(battleData)
	return {}
end


function BossTipsText.DarkElfCutscene(battleData)
	return {}
end




return BossTipsText