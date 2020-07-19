extends RakugoControl


func start_combat():
	$YSort.prepare()
	Rakugo.hide("InGameGUI")
	var heroes : Array = Rakugo.get_value("party") 
	$CombatPanel._set_hero(heroes[0])
