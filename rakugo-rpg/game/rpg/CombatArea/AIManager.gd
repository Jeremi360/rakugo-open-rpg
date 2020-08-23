extends Node
# script that manages enemies

export var combat_panel_path : NodePath
export var visual_feedback_path : NodePath
export var timer_path : NodePath 
export var end_combat_panel_path : NodePath

onready var combat_panel = get_node(combat_panel_path)
onready var visual_feedback : RakugoTextLabel = get_node(visual_feedback_path)
onready var timer : Timer = get_node(timer_path)
onready var end_combat_panel : Panel = get_node(end_combat_panel_path)

var enemy : RPGCharacter setget _set_enemy, _get_enemy

var _enemy : RPGCharacter

var party := []
var enemies := []
var skills := {}

var active_party := []
var active_enemies := []

var current_enemies_member := 0
var alive_party_size := 0 # number of alive party members
var alive_enemies_size := 0 # number of alive enemies

func set_party_n_enemies(party_arr:Array, enemies_arr:Array) -> void:
	party = party_arr
	active_party = party_arr.duplicate()
	alive_party_size = party_arr.size()

	enemies = enemies_arr
	active_enemies = enemies_arr.duplicate()
	alive_enemies_size = enemies_arr.size()


func _set_enemy(value:RPGCharacter) -> void:
	_enemy = value
	use_random_skill()


func _get_enemy() -> RPGCharacter:
	return _enemy


func get_random_skill_type() -> String:
	randomize()
	var t := randi() % 3
	return ["attack", "magic", "special"][t]


func get_random_skill(type:String) -> String:
	skills = _enemy.attack_skills
	
	if type == "magic":
		skills = _enemy.magic_skills
	
	if type == "special":
		skills = _enemy.special_skills
	
	randomize()
	var s := randi() % skills.size()
	return skills.keys()[s]


func get_random_target(skill:String) -> RPGCharacter:
	var targets := []

	# it must be this way
	if skills[skill].targets == "enemies":
		targets = active_party
	
	if skills[skill].targets == "party":
		targets = active_enemies
	
	randomize()
	var t := randi() % targets.size()
	var target = targets[t]

	if skills[skill].targets == "enemies":
		active_party = party.duplicate()
		active_party.remove(t)
	
	if skills[skill].targets == "party":
		active_enemies = enemies.duplicate()
		active_enemies.remove(t)
	
	return target


func use_random_skill() -> void:
	randomize()
	var skill_type := get_random_skill_type()
	var skill := get_random_skill(skill_type)
	var target := get_random_target(skill)
	_enemy.use_skill(skill, target)
	visual_feedback.set_visual_feedback(_enemy, skill, target)

	alive_party_size = party.size()
	for t in party:
		if t.hp.value == 0:
			alive_party_size -= 1

	timer.start()
	yield(timer, "timeout")

	current_enemies_member += 1
	if alive_enemies_size > current_enemies_member:
		_set_enemy(enemies[current_enemies_member])
		return
	
	if alive_party_size > 0:
		current_enemies_member = 0
		combat_panel._set_hero(party[0])
		combat_panel.show()
		return
	
	player_lose()


func player_lose() -> void:
	combat_panel.hide()
	var gold := [] 
	for p in party:
		gold.append(0)

	var exp_points := [] 
	for p in party:
		exp_points.append(0)
	
	end_combat_panel.set_result(false, party, gold, exp_points)
