extends Character
class_name RPGCharacter, "res://icon.png"

# make scripts that extend form this one fit your heros and enemies

export (String, FILE, "*.png") var icon_path := ""
export (String, "Hero", "Enemy", "NPC") var type := "Hero"

export var level := 1
# RakugoRangedVar.value is always clamped bettween min and max 
var hp := RakugoRangedVar.new("hp", 100, 0, 100)
var mana := RakugoRangedVar.new("mana", 100, 0, 100)
var special := RakugoRangedVar.new("special", 100, 0, 100)
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
	stats["hp"] = hp
	stats["mana"] = mana
	stats["special"] = special
	stats["lvl"] = level
	stats["unlocked_skills"] = unlocked_skills


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

	if skill == "flee":
		# simple go back to prev dialog.
		Rakugo.hide("CombatArea")
		var prev = Rakugo.get_value("prev_dialog")
		Rakugo.jump(prev[0], prev[1], prev[2])


func recive_attack(attack_type: String, value: int, anim:String):
	# minius will subtract from target hp/mana/def
	# plus will add to target hp/mana/def

	hit_label.text = str(value)
		
	if value >= 0:
		hit_label.text = "+" + str(value)
	
	hit_anim.play(anim)

	if attack_type == "hp":
		hp.value += value - def
		hp_bar.value = hp.value

	if attack_type == "mana":
		mana.value += value - def
		mana_bar.value = mana.value

	def = 0

	if attack_type == "def":
		def = value