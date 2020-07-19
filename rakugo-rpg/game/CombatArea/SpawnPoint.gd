extends Position2D

func setup(character:RPGCharacter):
	$ProgressBar.value = character.hp
	$Label.text = character.character_name
	$Label.modulate = character.color
