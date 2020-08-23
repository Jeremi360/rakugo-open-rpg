extends Panel

export var attack_button: PackedScene
export var target_button: PackedScene
export var skills_buttons_parent_path: NodePath
export var targets_buttons_parent_path: NodePath
export var ai_manager_path: NodePath
export var visual_feedback_path : NodePath
export var timer_path : NodePath
export var end_combat_panel_path : NodePath

onready var visual_feedback : RakugoTextLabel = get_node(visual_feedback_path)
onready var skills_buttons_parent = get_node(skills_buttons_parent_path)
onready var targets_buttons_parent = get_node(targets_buttons_parent_path)
onready var ai_manager = get_node(ai_manager_path)
onready var timer : Timer = get_node(timer_path)
onready var end_combat_panel : Panel = get_node(end_combat_panel_path)

var current_hero: RPGCharacter setget _set_hero
var _hero: RPGCharacter
var current_skill: String
var skill_type := ""

var party := []
var enemies := []

var current_party_member := 0 
var alive_party_size := 0 # number of alive party members
var alive_enemies_size := 0 # number of alive enemies

func set_party_n_enemies(party_arr:Array, enemies_arr:Array) -> void:
	party = party_arr
	alive_party_size = party_arr.size()

	enemies = enemies_arr
	alive_enemies_size = enemies_arr.size()


func _set_hero(value: RPGCharacter) -> void:
	_hero = value
	_on_Attack_toggled(true)
	skills_buttons_parent.show()


func _get_hero() -> RPGCharacter:
	return _hero


func free_all_children(node: Node) -> void:
	for ch in node.get_children():
		ch.queue_free()


func make_targets_buttons(targets: Array) -> void:
	free_all_children(targets_buttons_parent)

	for t in targets:
		if t.hp.value == 0:
			continue

		var b: RPGButton = target_button.instance()
		b.set_rpg_text(t.character_name, t.hp.value, "")
		targets_buttons_parent.add_child(b)
		b.connect("pressed", self, "_on_target_button_pressed", [t])


func make_skills_buttons(attack_skills: Dictionary, unlocked_skills: Array, limit := 0) -> void:
	free_all_children(skills_buttons_parent)

	for s in attack_skills:
		if s in unlocked_skills:
			var cost: int = attack_skills[s].cost
			var b: RPGButton = attack_button.instance()
			b.set_rpg_text(s, cost)
			skills_buttons_parent.add_child(b)
			b.disabled = limit > 0 and cost > limit
			b.connect("pressed", self, "set_skill", [s])


func _on_Attack_toggled(button_pressed):
	if button_pressed:
		make_skills_buttons(_hero.attack_skills, _hero.unlocked_skills)
		skill_type = "attack"


func _on_Magic_toggled(button_pressed):
	if button_pressed:
		make_skills_buttons(_hero.magic_skills, _hero.unlocked_skills, _hero.mana.value)
		skill_type = "magic"

func _on_Special_toggled(button_pressed):
	if button_pressed:
		make_skills_buttons(_hero.special_skills, _hero.unlocked_skills)
		skill_type = "special"

func _on_Defense_pressed():
	_hero.use_skill("defense")


func _on_Flee_pressed():
	ai_manager.player_lose()


func set_skill(skill: String):
	current_skill = skill
	skills_buttons_parent.hide()

	var arr := _hero.attack_skills

	if skill_type == "magic":
		arr = _hero.magic_skills
	
	if skill_type == "special":
		arr = _hero.special_skills
	
	var targets := []

	if arr[current_skill].targets == "enemies":
		targets = enemies
	
	if arr[current_skill].targets == "party":
		targets = party

	make_targets_buttons(targets)
	targets_buttons_parent.show()


func _on_target_button_pressed(target: RPGCharacter):
	targets_buttons_parent.hide()
	_hero.use_skill(current_skill, target)
	visual_feedback.set_visual_feedback(_hero, current_skill, target)
	
	alive_enemies_size = enemies.size()
	for t in enemies:
		if t.hp.value == 0:
			alive_enemies_size -= 1

	timer.start()
	yield(timer, "timeout")
	
	current_party_member += 1
	if alive_party_size > current_party_member:
		_set_hero(party[current_party_member])
		return
		
	if alive_enemies_size > 0:
		hide()
		current_party_member = 0
		ai_manager.enemy = enemies[0]
		return
	
	players_party_wins()
	
	
func players_party_wins():
		hide()
		var gold_sum := 0
		for e in enemies:
			randomize()
			gold_sum += randi()% e.gold
		
		var gold := [] 
		for p in party:
			gold.append(gold_sum / party.size())
		
		var exp_sum := 0
		for e in enemies:
			randomize()
			exp_sum += randi()% e.max_exp
		
		var exp_points := [] 
		for p in party:
			exp_points.append(exp_sum / party.size())
		

		end_combat_panel.set_result(true, party, gold, exp_points)

