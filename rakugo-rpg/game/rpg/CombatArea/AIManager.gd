extends Node
# script that manages enemies

export var combat_panel_path : NodePath
export var visual_feedback_path : NodePath
export var timer_path : NodePath 

onready var combat_panel = get_node(combat_panel_path)
onready var visual_feedback : RakugoTextLabel = get_node(visual_feedback_path)
onready var timer : Timer = get_node(timer_path)
var enemy : RPGCharacter setget _set_enemy, _get_enemy

var party := []
var enemies := []
var skills := {}
var _enemy : RPGCharacter
var current_enemies_member := 0 

func _set_enemy(value:RPGCharacter) -> void:
	_enemy = value
	use_random_skill()


func _get_enemy() -> RPGCharacter:
	return _enemy


func get_random_skill_type() -> String:
	var t := randi() % 3
	return ["attack", "magic", "special"][t]


func get_random_skill(type:String) -> String:
	skills = _enemy.attack_skills
	
	if type == "magic":
		skills = _enemy.magic_skills
	
	if type == "special":
		skills = _enemy.special_skills
	
	var s := randi() % skills.size()
	return skills.keys()[s]


func get_random_target(skill:String) -> RPGCharacter:
	var targets := []

	# it must be this way
	if skills[skill].targets == "enemies":
		targets = party
	
	if skills[skill].targets == "party":
		targets = enemies
	
	var t := randi() % skills.size()
	return targets[t]


func use_random_skill() -> void:
	randomize()
	var skill_type := get_random_skill_type()
	var skill := get_random_skill(skill_type)
	var target := get_random_target(skill)
	_enemy.use_skill(skill, target)
	visual_feedback.set_visual_feedback(_enemy, skill, target)

	timer.start()
	yield(timer, "timeout")

	current_enemies_member += 1
	if enemies.size() > current_enemies_member:
		_set_enemy(enemies[current_enemies_member])
	
	else:
		current_enemies_member = 0
		combat_panel._set_hero(party[0])
		combat_panel.show()
