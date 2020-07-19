extends Character
class_name RPGCharacter, "res://icon.png"

# make scripts that extend form this one fit your heros and enemies

export (String, "Hero", "Enemy", "NPC") var type := "Hero"

export var level := 1
# RakugoRangedVar.value is always clamped bettween min and max 
var hp = RakugoRangedVar.new("hp", 100, 0, 100)
var mana = RakugoRangedVar.new("mana", 100, 0, 100)
var special = RakugoRangedVar.new("special", 100, 0, 100)
var unlocked_skills := ["sword attack", "special attack", "healing spell"]

# this are just examples
# {"attack name":attack_cost}
# you can override them in _ready() by extending from this script
var attack_skills := {"sword attack": 0}
var special_skills := {"special attack": 10}
var magic_skills := {"healing spell": 20}
var current_attack := {"type": "hp", "value": 0, "target": "character_id"}


func _ready():
	# this stuff will be saved when player save game
	stats["hp"] = hp
	stats["mana"] = mana
	stats["special"] = special
	stats["lvl"] = level
	stats["unlocked_skills"] = unlocked_skills


func use_skill(skill: String, target: String) -> void:
	# override in script extend form this one fit your heros and enemies
	if skill == "sword attack":
		current_attack = {"type": "hp", "value": -20, "target": target}

	if skill == "healing spell":
		# heal is just attack on character itself
		current_attack = {"type": "hp", "value": 20, "target": character_id}

	if skill == "defense":
		# defense is just attack on character itself
		current_attack = {"type": "hp", "value": 10, "target": character_id}

	if skill == "flee":
		# simple go back to prev dialog.
		current_attack = {"type": "hp", "value": 0, "target": character_id}
		Rakugo.hide("CombatArea")
		var prev = Rakugo.get_value("prev_dialog")
		Rakugo.jump(prev[0], prev[1], prev[2])


func recive_attack(attack_type: String, value: int):
	if attack_type == "hp":
		hp.value += value

	if attack_type == "mana":
		mana.value += value
