extends Panel

export var win_txt := "Win"
export var win_color : Color = Color.gold
export var lose_txt := "Lose"
export var lose_color : Color = Color.red
export var exp_box : PackedScene
export var box_path : NodePath
export var label_path : NodePath

onready var box : Container = get_node(box_path)
onready var label : Label = get_node(label_path)

func set_result(win:bool, party:Array, gold:Array, exp_points) -> void:
	if win:
		label.text = win_txt
		label.modulate = win_color
	
	else:
		label.text = lose_txt
		label.modulate = lose_color
	
	for i in party.size():
		var b := exp_box.instance()
		var g := 0
		
		if i < gold.size():
			g = gold[i]
		
		var e := 0
		if i < exp_points.size():
			e = exp_points[i]
		
		var p : RPGCharacter = party[i]
		p.gold += g
		p.exp_points.value += e
		b.set_labels(p.character_name, p.color, g, e)
		
		box.add_child(b)

	show()
