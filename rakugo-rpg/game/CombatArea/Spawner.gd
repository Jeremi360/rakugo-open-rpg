extends YSort

export var max_slots := 3

func prepare():
	spawn_party(Rakugo.get_value("party"))
	spawn_enemy(Rakugo.get_value("enemies"))


func spawn(type:String, array:Array):
	for j in range(max_slots):
		var s = get_node(type + str(j))
		s.hide()
	
	for i in range(array.size()):
		var p:Node2D = array[i].instance()
		var s = get_node(type + str(i))
		s.add_child(p)
		var rpg_ch : RPGCharacter = p.get_node("RPGCharacter")
		s.setup(rpg_ch)
		s.show()


func spawn_party(array:Array):
	spawn("Hero", array)


func spawn_enemy(array:Array):
	spawn("Enemy", array)

