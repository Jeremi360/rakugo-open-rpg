extends RakugoButton
class_name AttackButton

export var renpy_text := "attack" setget _set_rtext, _get_rtext

var _rtext := "attack"


func set_attack(attack: String, cost: int) -> void:
	var cost_txt = str(cost)

	if cost == 0:
		cost_txt = ""

	var t = attack + " " + cost_txt
	_set_rtext(t)


func _set_rtext(value: String) -> void:
	_rtext = value
	$RakugoTextLabel.rakugo_text = "{center}"
	$RakugoTextLabel.rakugo_text += value.capitalize()
	$RakugoTextLabel.rakugo_text += "{/center}"


func _get_rtext() -> String:
	return _rtext
