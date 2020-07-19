extends Panel

export var attack_button: PackedScene
export var skill_buttons_parent_path: NodePath

onready var skill_buttons_parent: Container = get_node(skill_buttons_parent_path)

var current_hero: RPGCharacter setget _set_hero
var _current_hero: RPGCharacter


func _set_hero(value: RPGCharacter) -> void:
	_current_hero = value
	_on_Attack_toggled(true)


func make_buttons(attack_skills: Dictionary, unlocked_skills: Array, limit := 0):
	for b in skill_buttons_parent.get_children():
		b.queue_free()

	for s in attack_skills:
		if s in unlocked_skills:
			var cost: int = attack_skills[s]
			var b: AttackButton = attack_button.instance()
			b.set_attack(s, cost)
			skill_buttons_parent.add(b)
			b.disabled = limit > 0 and cost > limit


func _on_Attack_toggled(button_pressed):
	if button_pressed:
		make_buttons(_current_hero.attack_skills, _current_hero.unlocked_skills)


func _on_Magic_toggled(button_pressed):
	if button_pressed:
		make_buttons(_current_hero.magic_skills, _current_hero.unlocked_skills, _current_hero.mana)


func _on_Special_toggled(button_pressed):
	if button_pressed:
		make_buttons(_current_hero.special_skills, _current_hero.unlocked_skills)


func _on_Defense_pressed():
	_current_hero.use_skill("defense", "")


func _on_Flee_pressed():
	_current_hero.use_skill("flee", "")
