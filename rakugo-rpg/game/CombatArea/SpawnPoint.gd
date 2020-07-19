extends Position2D

onready var button := $VBoxContainer/Button
var rpg_ch : RPGCharacter


func setup(character: RPGCharacter):
	var hp_bar := $VBoxContainer/ProgressBar
	var mana_bar := $VBoxContainer/ProgressBar2
	var label := $VBoxContainer/Label

	hp_bar.min_value = character.hp.min_value
	hp_bar.max_value = character.hp.max_value
	hp_bar.value = character.hp.value

	mana_bar.min_value = character.mana.min_value
	mana_bar.max_value = character.mana.max_value
	mana_bar.value = character.mana.value

	label.text = character.character_name
	label.modulate = character.color


func _on_Button_pressed():
	Rakugo.define("target", rpg_ch)
