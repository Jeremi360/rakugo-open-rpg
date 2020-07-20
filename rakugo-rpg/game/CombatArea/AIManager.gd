extends Node
# script that manages enemies

export var combat_panel_path : NodePath
onready var  combat_panel = get_node(combat_panel_path)
var enemy : RPGCharacter setget _set_enemy, _get_enemy

var party := []
var enemies := []
var skills := {}
var _enemy : RPGCharacter
var current_enemies_member := 0 

func _set_enemy(value:RPGCharacter) -> void:
    _enemy = value
    current_enemies_member = enemies.find(_enemy)


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
    return skills[s]


func get_random_target(skill:String) -> RPGCharacter:
    var targets := []

    if skills[skill].targets == "enemies":
        targets = enemies
	
    if skills[skill].targets == "party":
        targets = party
    
    var t := randi() % skills.size()
    return targets[t]


func use_random_skill() -> void:
    var skill_type := get_random_skill_type()
    var skill := get_random_skill(skill_type)
    var target := get_random_target(skill)
    _enemy.use_skill(skill, target)

    if enemies.size() > current_enemies_member:
        current_enemies_member += 1
        _set_enemy(enemies[current_enemies_member])
    
    else:
        combat_panel._set_hero(party[0])
        combat_panel.show()
        