extends Node

export var combat_area_path: NodePath
export (Array, PackedScene) var party := []
export (Array, PackedScene) var enemies := []

onready var combat_area: Control = get_node(combat_area_path)

func start_combat():
	Rakugo.define("party", party)
	Rakugo.define("enemies", enemies)
	combat_area.show()
	combat_area.start_combat()


func _on_CombatDialog_start_combat():
	start_combat()
