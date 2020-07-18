extends Node

export(Array, PackedScene) var party := []
export(Array, PackedScene) var enemies := []

func start_combat():
	Rakugo.define("party", party)
	Rakugo.define("enemies", enemies)
	Rakugo.load_scene("Combat")


func _on_CombatDialog_start_combat():
	start_combat()
