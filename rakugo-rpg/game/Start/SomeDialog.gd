extends GDScriptDialog

signal start_combat
signal loop

var prev_dialog : RakugoList

func combat_dialog(node_name, dialog_name):
	var cd = check_dialog(node_name, dialog_name, "combat_dialog")

	if not cd:
		return
	
	prev_dialog = define("prev_dialog", ["Start", "CombatDialog", "combat_dialog"])
	
	if next_state():
		say({"what": "Simple Combat System Test."})
	
	if next_state():
		menu({
			"who": "Oppnent", 
			"what":"Do you want to fight?",
			"choices":
				{
					"yes": "start_combat",
					"no" : "loop"
				}
		})


func _on_CombatDialog_loop():
	jump(prev_dialog.value[0], prev_dialog.value[1], prev_dialog.value[2])
	

