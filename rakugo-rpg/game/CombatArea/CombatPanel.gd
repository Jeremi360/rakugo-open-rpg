extends Panel

export var attack_button: PackedScene
export var target_button: PackedScene
export var skills_buttons_parent_path: NodePath
export var targets_buttons_parent_path: NodePath

onready var skills_buttons_parent = get_node(skills_buttons_parent_path)
onready var targets_buttons_parent = get_node(targets_buttons_parent_path)

var current_hero: RPGCharacter setget _set_hero
var _hero: RPGCharacter
var current_skill: String


func _set_hero(value: RPGCharacter) -> void:
	_hero = value
	_on_Attack_toggled(true)


func _get_hero() -> RPGCharacter:
	return _hero


func free_all_children(node: Node) -> void:
	for ch in node.get_children():
		ch.queue_free()


func make_enemies_buttons(enemies: Array) -> void:
	free_all_children(targets_buttons_parent)

	for e in enemies:
		if e.hp.value == 0:
			continue

		var b: RPGButton = target_button.instance()
		b.set_rpg_text(e.character_name, e.hp.value, e.icon_path)
		targets_buttons_parent.add_child(b)
		b.connect("pressed", self, "_on_target_button_pressed", [e])

	targets_buttons_parent.hide()


func make_skills_buttons(attack_skills: Dictionary, unlocked_skills: Array, limit := 0) -> void:
	free_all_children(skills_buttons_parent)

	for s in attack_skills:
		if s in unlocked_skills:
			var cost: int = attack_skills[s]
			var b: RPGButton = attack_button.instance()
			b.set_rpg_text(s, cost)
			skills_buttons_parent.add_child(b)
			b.disabled = limit > 0 and cost > limit
			b.connect("pressed", self, "set_skill", [s])


func _on_Attack_toggled(button_pressed):
	if button_pressed:
		make_skills_buttons(_hero.attack_skills, _hero.unlocked_skills)


func _on_Magic_toggled(button_pressed):
	if button_pressed:
		make_skills_buttons(_hero.magic_skills, _hero.unlocked_skills, _hero.mana.value)


func _on_Special_toggled(button_pressed):
	if button_pressed:
		make_skills_buttons(_hero.special_skills, _hero.unlocked_skills)


func _on_Defense_pressed():
	_hero.use_skill("defense")


func _on_Flee_pressed():
	_hero.use_skill("flee")


func set_skill(skill: String):
	current_skill = skill
	skills_buttons_parent.hide()
	targets_buttons_parent.show()


func _on_target_button_pressed(target: RPGCharacter):
	targets_buttons_parent.hide()
	_hero.use_skill(current_skill, target)
