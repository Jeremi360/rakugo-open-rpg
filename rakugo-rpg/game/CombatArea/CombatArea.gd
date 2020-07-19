extends RakugoControl

export var max_slots := 3
export var spawn_parent_path : NodePath

func start_combat():
	Rakugo.hide("InGameGUI")
	var party : = spawn_party(Rakugo.get_value("party"))
	var enemies : = spawn_enemies(Rakugo.get_value("enemies"))
	$CombatPanel.current_hero = party[0]


func get_spawn_point(type:String, id:int) -> Node:
	return get_node(str(spawn_parent_path) + "/" + type + str(id))

func spawn(type:String, array:Array) -> Array:
	var arr := []

	for j in range(max_slots):
		var s = get_spawn_point(type, j)
		s.hide()
	
	for i in range(array.size()):
		var p:Node2D = array[i].instance()
		var s = get_spawn_point(type, i)
		s.add_child(p)
		var rpg_ch : RPGCharacter = p.get_node("RPGCharacter")
		s.setup(rpg_ch)
		s.show()
		arr.append(rpg_ch)
	
	return arr


func spawn_party(array:Array) -> Array:
	return spawn("Hero", array)


func spawn_enemies(array:Array) -> Array:
	return spawn("Enemy", array)

