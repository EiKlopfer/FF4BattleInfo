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


function calculateMaxAttackDamageRange(attackPower, attackMult)
	-- max attack power just assumes 0 defense and that all attacks hit, so attack Power * mult
	return attackPower * attackMult, attackPower * attackMult * 1.5
end

function standardAttackDamageRangeMessage(attackPower, attackMult)
	minAttack, maxAttack = calculateMaxAttackDamageRange(attackPower, attackMult)
	return string.format("Attack damage range %d - %d (vs no armor)", minAttack, maxAttack )
end

function calculateMaxMagicDamageRange(spellPower, baseSpellPower)
	-- again will assume no defense and all instances hit
	local magicMult = math.floor(spellPower / 4) + 1
	return	magicMult * baseSpellPower, magicMult * baseSpellPower * 1.5
end

function standardMagicDamageRangeMessage(spellPower, spellName, baseSpellPower)
	minAttack, maxAttack = calculateMaxMagicDamageRange(spellPower, baseSpellPower)
	return string.format("%s damage range %d - %d (vs no armor)", spellName, minAttack, maxAttack )
end

function standardMultiMagicDamageRangeMessage(spellPower, spellName, baseSpellPower, partySize)
	minAttack, maxAttack = calculateMaxMagicDamageRange(spellPower, math.floor(baseSpellPower/partySize))
	return string.format("%s range %d - %d (no armor, everyone alive)", spellName, minAttack, maxAttack )
end

function BossTipsText.Antlion(battleData, partyBattleData, partySize)
	local bossTips = {}	
	bossTips[1] = standardAttackDamageRangeMessage(battleData[0].attackPower, battleData[0].attackMult)
	bossTips[2] = string.format("Counter only cares about attack, will deal %d - %d", battleData[0].attackPower * 2, battleData[0].attackPower * 2 * 1.5 )	
	return bossTips
end


function BossTipsText.Asura(battleData, partyBattleData, partySize)
	local bossTips = {}	
	bossTips[1] = standardAttackDamageRangeMessage(battleData[0].attackPower, battleData[0].attackMult)
	bossTips[2] = "Only attacks as counter, also is a mage"
	return bossTips
end


function BossTipsText.Bahamut(battleData, partyBattleData, partySize)
	local bossTips = {}	
	bossTips[1] = standardMagicDamageRangeMessage(battleData[0].spellPower, "MegaNuke", 1020)
	return bossTips
end


function BossTipsText.Baigan(battleData, partyBattleData, partySize)
	local bossTips = {}	
	bossTips[1] = standardAttackDamageRangeMessage(battleData[0].attackPower, battleData[0].attackMult)
	bossTips[2] = "Right arm attack every other action"
	bossTips[3] = "Left arm attacks, entangles, attacks"
	return bossTips
end


function BossTipsText.Calbrena(battleData, partyBattleData, partySize)
	return {}
end


function BossTipsText.CPU(battleData, partyBattleData, partySize)
	return {}
end


function BossTipsText.DarkElf(battleData, partyBattleData, partySize)
	local bossTips = {}	
	bossTips[1] = "First form transforms when under 20k"
	bossTips[2] = "Second form can use Stop or Weak on it"
	return bossTips
end


function BossTipsText.DarkImps(battleData, partyBattleData, partySize)
	local bossTips = {}	
	bossTips[1] = standardAttackDamageRangeMessage(battleData[0].attackPower, battleData[0].attackMult)
	return bossTips
end


function BossTipsText.DLunars(battleData, partyBattleData, partySize)
	local bossTips = {}	
	bossTips[1] = standardMagicDamageRangeMessage(battleData[0].spellPower, "Virus", 128)
	return bossTips
end


function BossTipsText.DMist(battleData, partyBattleData, partySize)
	local bossTips = {}	
	bossTips[1] = standardAttackDamageRangeMessage(battleData[0].attackPower, battleData[0].attackMult)
	return bossTips
end


function BossTipsText.Elements(battleData, partyBattleData, partySize)
	local bossTips = {}	
	bossTips[1] = standardMultiMagicDamageRangeMessage(battleData[0].spellPower, "Fire3(Multi)", 256, partySize )
	bossTips[2] = standardMultiMagicDamageRangeMessage(battleData[0].spellPower, "Glare(Multi)", 360, partySize )
	bossTips[3] = string.format("Transforms to Rubi at %d HP left", math.floor(battleData[0].maxHp * 0.701759618) + 1 )
	bossTips[4] = string.format("Transforms to Kain at %d HP left", math.floor(battleData[0].maxHp * 0.192996614) + 1 )
	bossTips[5] = string.format("Transforms to Val at %d HP left", math.floor(battleData[1].maxHp * 0.574489362) + 1 )
	return bossTips
end


function BossTipsText.EvilWall(battleData, partyBattleData, partySize)
	local bossTips = {}	
	bossTips[1] = standardAttackDamageRangeMessage(battleData[0].attackPower, battleData[0].attackMult)
	return bossTips
end


function BossTipsText.FabulGauntlet(battleData, partyBattleData, partySize)
	return {}
end


function BossTipsText.Golbez(battleData, partyBattleData, partySize)
	local bossTips = {}	
	bossTips[1] = standardMagicDamageRangeMessage(battleData[0].spellPower, "Lit-3", 256)
	bossTips[2] = "Will die at 19k HP left"
	return bossTips
end


function BossTipsText.Guard(battleData, partyBattleData, partySize)
	local bossTips = {}	
	bossTips[1] = standardAttackDamageRangeMessage(battleData[0].attackPower, battleData[0].attackMult)
	bossTips[2] = "Mute can stop counter Piggy/Size"
	bossTips[3] = "No status resistances"
	return bossTips
end


function BossTipsText.Kainazzo(battleData, partyBattleData, partySize)
	local bossTips = {}	
	local hpFraction = math.floor( battleData[0].maxHp / 25 )
	bossTips[1] = string.format("Wave at max HP range %d - %d", hpFraction , hpFraction + math.min(255, hpFraction * 0.5))	
	bossTips[2] = standardAttackDamageRangeMessage(battleData[0].attackPower, battleData[0].attackMult)	
	return bossTips
end


function BossTipsText.Karate(battleData, partyBattleData, partySize)
	local bossTips = {}	
	bossTips[1] = standardAttackDamageRangeMessage(battleData[0].attackPower, battleData[0].attackMult)
	return bossTips
end


function BossTipsText.KingQueen(battleData, partyBattleData, partySize)
	local bossTips = {}	
	bossTips[1] = standardMagicDamageRangeMessage(battleData[0].spellPower, "Fire2", 64)
	return bossTips
end


function BossTipsText.Leviatan(battleData, partyBattleData, partySize)
	local bossTips = {}	
	bossTips[1] = standardMagicDamageRangeMessage(battleData[0].spellPower, "Ice-2", 64)
	return bossTips
end


function BossTipsText.LugaeBalnab(battleData, partyBattleData, partySize)
	local bossTips = {}	
	bossTips[1] = standardAttackDamageRangeMessage(battleData[1].attackPower, battleData[1].attackMult)
	return bossTips
end


function BossTipsText.Lugae(battleData, partyBattleData, partySize)
	local bossTips = {}	
	local hpFraction = math.floor( battleData[0].maxHp / 5 )
	bossTips[1] = string.format("Laser at max HP range %d - %d", hpFraction , hpFraction + math.min(255, hpFraction * 0.5))	
	bossTips[2] = standardMagicDamageRangeMessage(battleData[0].spellPower, "Emission", 20)
	return bossTips
end


function BossTipsText.Magus(battleData, partyBattleData, partySize)
	local bossTips = {}	
	bossTips[1] = standardAttackDamageRangeMessage(battleData[1].attackPower, battleData[1].attackMult)
	bossTips[2] = standardMagicDamageRangeMessage(battleData[2].spellPower, "Fire2", 64)
	bossTips[2] = standardMagicDamageRangeMessage(battleData[2].spellPower, "Virus", 128)
	return bossTips
end


function BossTipsText.Milon(battleData, partyBattleData, partySize)
	local bossTips = {}	
	bossTips[1] = "Ghast if Milon dead " .. standardAttackDamageRangeMessage(battleData[1].attackPower, battleData[1].attackMult)
	bossTips[2] = "Will die at 1k HP left"
	return bossTips
end


function BossTipsText.MilonZ(battleData, partyBattleData, partySize)
	local bossTips = {}	
	bossTips[1] = standardAttackDamageRangeMessage(battleData[0].attackPower, battleData[0].attackMult)
	return bossTips
end


function BossTipsText.MirrorCecil(battleData, partyBattleData, partySize)
	local bossTips = {}
	local minDamage = battleData[0].attackMult * battleData[0].attackPower / 2
	bossTips[1] = string.format("Dark Wave range %d - %d", minDamage , minDamage + battleData[0].attackPower)
	return bossTips
end


function BossTipsText.MomBomb(battleData, partyBattleData, partySize)
	local bossTips = {}
	bossTips[1] = standardMagicDamageRangeMessage(battleData[0].spellPower, "Explode", 32)
	bossTips[2] = battleData[0].name .. " - " .. standardAttackDamageRangeMessage(battleData[0].attackPower, battleData[0].attackMult)
	bossTips[3] = battleData[2].name .. " - " .. standardAttackDamageRangeMessage(battleData[2].attackPower, battleData[2].attackMult)
	bossTips[4] = "MomBomb Transforms when under 10k"
	return bossTips
end


function BossTipsText.OctoMann(battleData, partyBattleData, partySize)
	local bossTips = {}	
	bossTips[1] = standardAttackDamageRangeMessage(battleData[0].attackPower, battleData[0].attackMult)
	return bossTips
end


function BossTipsText.Odin(battleData, partyBattleData, partySize)
	local bossTips = {}
	bossTips[1] = standardMagicDamageRangeMessage(battleData[0].spellPower, "Odin", 160)
	bossTips[2] = standardAttackDamageRangeMessage(battleData[0].attackPower, battleData[0].attackMult)
	return bossTips
end


function BossTipsText.Officer(battleData, partyBattleData, partySize)
	local bossTips = {}	
	bossTips[1] = standardAttackDamageRangeMessage(battleData[1].attackPower, battleData[1].attackMult)
	return bossTips
end


function BossTipsText.Ogopogo(battleData, partyBattleData, partySize)
	local bossTips = {}
	bossTips[1] = standardAttackDamageRangeMessage(battleData[0].attackPower, battleData[0].attackMult)
	bossTips[2] = "Script: Wave x2, Fight x3, Wave x1, Fight x2, Repeat"
	return bossTips
end


function BossTipsText.PaleDim(battleData, partyBattleData, partySize)
	local bossTips = {}
	bossTips[1] = standardAttackDamageRangeMessage(battleData[0].attackPower, battleData[0].attackMult)
	return bossTips
end


function BossTipsText.Plague(battleData, partyBattleData, partySize)
	return {}
end


function BossTipsText.Rubicant(battleData, partyBattleData, partySize)
	local bossTips = {}
	bossTips[1] = standardMagicDamageRangeMessage(battleData[0].spellPower, "Glare", 360)
	bossTips[2] = standardMultiMagicDamageRangeMessage(battleData[0].spellPower, "Fire2(Multi)", 64, partySize )
	bossTips[3] = "Dies at 1k HP left"
	return bossTips
end


function BossTipsText.Valvalis(battleData, partyBattleData, partySize)
	-- TODO: can look up script evade numbers?
	local bossTips = {}
	bossTips[1] = "No Mag Evade at Dark Imps, Golbez, Karate, KQ, Lugae, Milon"
	bossTips[2] = "Nuke at Antlion, Bahamut, Baigan, Gauntlet, Magus, DKC, MomBomb"
	return bossTips
end


function BossTipsText.WaterHag(battleData, partyBattleData, partySize)
	return {}
end


function BossTipsText.Wyvern(battleData, partyBattleData, partySize)
	local bossTips = {}	
	bossTips[1] = standardMagicDamageRangeMessage(battleData[0].spellPower, "MegaNuke", 1020)
	bossTips[2] = standardMagicDamageRangeMessage(math.floor(battleData[0].spellPower * 1.5) + 1, "Nuke", 400)
	return bossTips
end


function BossTipsText.Zeromus(battleData, partyBattleData, partySize)
	return {}
end


function BossTipsText.Egg(battleData, partyBattleData, partySize)
	return {}
end


function BossTipsText.Ryus(battleData, partyBattleData, partySize)
	return {}
end


function BossTipsText.Dmachine(battleData, partyBattleData, partySize)
	return {}
end


function BossTipsText.MacGiant(battleData, partyBattleData, partySize)
	return {}
end


function BossTipsText.TrapDoors(battleData, partyBattleData, partySize)
	return {}
end


function BossTipsText.Misc(battleData, partyBattleData, partySize)
	return {}
end


function BossTipsText.Package(battleData, partyBattleData, partySize)
	return {}
end


function BossTipsText.DarkElfCutscene(battleData, partyBattleData, partySize)
	return {}
end




return BossTipsText