extends RakugoButton
class_name RPGButton


func set_rpg_text(label: String, cost := 0, icon_path := "") -> void:
	var cost_txt = str(cost)

	if cost == 0:
		cost_txt = ""

	var t_icon = "{img}" + icon_path + "{/img}"
	if icon_path == "":
		t_icon = ""

	var t_arr := PoolStringArray([t_icon, label.capitalize(), cost_txt])
	$RakugoTextLabel.rakugo_text = "{center}"
	$RakugoTextLabel.rakugo_text += t_arr.join(" ")
	$RakugoTextLabel.rakugo_text += "{/center}"
	$RakugoTextLabel.update_label()
