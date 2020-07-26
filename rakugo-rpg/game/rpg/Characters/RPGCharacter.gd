extends Character
class_name RPGCharacter, "res://game/rpg/icon.png"

# make scripts that extend form this one fit your heros and enemies

export (String, FILE, "*.png") var icon_path := ""
export (String, "Hero", "Enemy", "NPC") var type := "Hero"

export var level := 1

# in enemy case it is max random gold limit that you get when enemy is defeated
export var gold := 100
# in enemy case it is max random exp limit that you get when enemy is defeated
export var max_exp := 100
export var max_hp := 100
export var max_mana := 100
export var max_special := 100 

# RakugoRangedVar.value is always clamped bettween min and max
var exp_points := RakugoRangedVar.new("exp_points", 0, 0, max_exp) # "exp" is keyword in GDScript
var hp := RakugoRangedVar.new("hp", 100, 0, max_hp)
var mana := RakugoRangedVar.new("mana", 100, 0, max_mana)
var special := RakugoRangedVar.new("special", 100, 0, max_special)
var unlocked_skills := ["sword attack", "special attack", "healing spell"]

# this are just examples
# you can override them in _ready() by extending from this script
var attack_skills := {
	"sword attack": {"cost": 0, "targets": "enemies"}
}
var magic_skills := {
	"healing spell": {"cost": 20, "targets": "party"}
}
var special_skills := {
	"special attack": {"cost": 20, "targets": "enemies"}
}

var def := 0

var hp_bar: ProgressBar
var mana_bar: ProgressBar
var hit_label : Label
var hit_anim : AnimationPlayer


func _ready():
	# this stuff will be saved when player save game
	stats["exp_points"] = exp_points
	stats["hp"] = hp
	stats["mana"] = mana
	stats["special"] = special
	stats["lvl"] = level
	stats["unlocked_skills"] = unlocked_skills


func get_max_exp() -> float:
	exp_points.max_value = level * 100
	return exp_points.max_value


func get_random_gold() -> int:
	randomize()
	return randi() % gold


func use_skill(skill: String, target: RPGCharacter = self) -> void:
	# override this func in script extend form this one fit your heros and enemies
	randomize()
	# random dnd roll dice style
	var s : float = randi() % 20 + level
	s /= 20

	if skill == "sword attack":
		target.recive_attack("hp", -20 * s, "hit")

	if skill == "healing spell":
		mana.value -= magic_skills[skill].cost
		target.recive_attack("hp", 20 * s, "heal")

	if skill == "special attack":
		target.recive_attack("hp", -30 * s, "hit")

	if skill == "defense":
		self.recive_attack("def", 5 * s, "def")


func recive_attack(attack_type: String, value: int, anim:String):
	# minius will subtract from target hp/mana/def
	# plus will add to target hp/mana/def

	hit_label.text = str(value)
		
	if value > 0:
		hit_label.text = "+" + str(value)
	
	if value == 0:
		hit_label.text = ""
	
	else:
		hit_anim.play(anim)
	
	# normal attack
	if attack_type == "hp":
		hp.value += value - def
		hp_bar.value = hp.value
	
	# add/remove mana
	if attack_type == "mana":
		mana.value += value - def
		mana_bar.value = mana.value
	
	# defense
	def = 0

	if attack_type == "def":
		def = value
