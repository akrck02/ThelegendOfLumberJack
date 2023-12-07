extends TileMap

var savegame : Dictionary;

@onready var load_game_button = $Buttons/LoadGame
@onready var new_game_button = $Buttons/NewGame
@onready var coins_label = $Buttons/LoadGame/Coins
@onready var time_label = $Buttons/LoadGame/Time

func _ready():
	var _options = OptionsManager.load_options()
	print(_options)
	
	var savestate = SaveManager.load_game()
	print(savestate)
	
	SignalDatabase.volume_changed.emit(int(OptionsManager.current_options["audio"]["volume"]))
	SignalDatabase.ui_camera_filter_changed.emit(OptionsManager.get_camera_filter())
	
	if savestate.get("Player") != null :
		coins_label.text = savestate.get("Player").get("coins") + " €"
		time_label.text = _format_played_time(float(savestate.get("played_time")))
		load_game_button.grab_focus()
	else : 
		load_game_button.hide()
		new_game_button.position.y = 270
		new_game_button.grab_focus()

func _format_played_time(time : float) -> String:
	var hours : float = time / 60 / 60
	var minutes : float = (time - int(hours) * 60 * 60) / 60
	
	return String("%01d:%02dh" % [hours, minutes]);
	

func _on_load_game_pressed():
	SignalDatabase.start_level_requested.emit()


func _on_new_game_pressed():
	SignalDatabase.new_game_created.emit()
	SignalDatabase.start_level_requested.emit()
