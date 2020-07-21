extends HBoxContainer

func set_labels(hero:String, color:Color, gold:int, exp_points:int) -> void:
	$Label.text = hero
	$Label.modulate = color
	$Label2.text = str(gold)
	$Label3.text = str(exp_points)
