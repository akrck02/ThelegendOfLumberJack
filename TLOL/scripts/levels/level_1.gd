extends Node2D

@onready var player = $Player
@onready var crab = $Crab

# Music players
@onready var ost_player = $AudioStreamPlayerOST
@onready var sea_player = $AudioStreamPlayerSea
@onready var forest_player = $AudioStreamPlayerForest

# Called when the node enters the scene tree for the first time.
func _ready():
	var savestate = SaveManager.get_savestate()
	crab.connect("defeated",on_crab_defeated)
	
	if LevelManager.EVENT_FLAGS["crab_defeated"] == "true":
		crab.queue_free()
	
	if not savestate.is_empty(): 
		player.load_savestate(savestate["Player"])
		SignalDatabase.ui_coins_gathered.emit(player.stats._coins);
		SignalDatabase.ui_health_changed.emit(player.stats._life,player.stats._get_max_life())



func on_crab_defeated():
	SignalDatabase.crab_defeated.emit()
