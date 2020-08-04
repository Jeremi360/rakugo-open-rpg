extends Position2D

var rpg_ch: RPGCharacter


func setup(character: RPGCharacter):
	var hp_bar := $VBoxContainer/ProgressBar
	var mana_bar := $VBoxContainer/ProgressBar2
	var label := $VBoxContainer/Label

	rpg_ch = character

	hp_bar.min_value = character.hp.min_value
	hp_bar.max_value = character.hp.max_value
	hp_bar.value = character.hp.value
	character.hp_bar = hp_bar

	mana_bar.min_value = character.mana.min_value
	mana_bar.max_value = character.mana.max_value
	mana_bar.value = character.mana.value
	character.mana_bar = mana_bar

	label.text = character.character_name
	label.modulate = character.color
	character.hit_label = $Label2
	character.hit_anim = $AnimationPlayer
