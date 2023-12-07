extends Node2D

@onready var player = $Player

func _ready():
	var savestate = SaveManager.get_savestate()
	
	if not savestate.is_empty(): 
		player.load_savestate(savestate["Player"])
		SignalDatabase.ui_coins_gathered.emit(player.stats._coins);
		SignalDatabase.ui_health_changed.emit(player.stats._life,player.stats._get_max_life())
