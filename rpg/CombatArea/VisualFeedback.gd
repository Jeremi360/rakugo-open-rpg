extends RakugoTextLabel


func set_visual_feedback(attacker : RPGCharacter, skill:String, target: RPGCharacter) -> void:

	var txt_attacker = "{color=" + attacker.color.to_html()  + "}"
	txt_attacker += attacker.character_name + "{/color}"

	var txt_target = "{color=" + target.color.to_html()  + "}"
	txt_target += target.character_name + "{/color}"

	var t_arr := PoolStringArray([
		txt_attacker, "use",
		skill.capitalize(), "on",
		txt_target
	])
	
	_set_rakugo_text(
		"{center}"
		+ t_arr.join(" ")
		+ "{/center}"
	)
	
	$AnimationPlayer.play("show_n_hide")
