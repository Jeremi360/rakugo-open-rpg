extends Character
class_name RPGCharacter, "res://icon.png"

var level := 1
var max_hp := 100
var hp := 100  
var skills := {
	"defense" : true,
	"flee" : true
}

func _ready():
	stats["max_hp"] = max_hp
	stats["hp"] = hp
	stats["lvl"] = level
	stats["skills"] = skills


func use_skill(skill:String) -> void:
	if skill == "defense":
		pass
	
	if skill == "flee":
		var prev = Rakugo.get_value("prev_dialog")
		Rakugo.jump(prev[0], prev[1], prev[2])
