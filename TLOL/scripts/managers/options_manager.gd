extends Node2D

const OPTIONS_FILENAME = "user://tlol.options.json";

var current_options :  Dictionary;

func _ready():
	
	SignalDatabase.vibration_changed.connect(toggle_vibration)
	SignalDatabase.volume_changed.connect(set_volume)
	

func load_options() -> Dictionary:
	
	if not FileAccess.file_exists(OPTIONS_FILENAME):
		current_options = default_options();
		save_options()
		return current_options;

	var save_game_file = FileAccess.open(OPTIONS_FILENAME, FileAccess.READ).get_as_text()

	var json : JSON = JSON.new()
	var result = json.parse(save_game_file)
	
	if result == OK:
		var data_received = json.data
		if typeof(data_received) == TYPE_DICTIONARY:
			current_options = data_received
			return data_received
		
	else:
		## Load error scene
		print("JSON Parse Error: ", json.get_error_message(), " in ", save_game_file, " at line ", json.get_error_line())
		EngineUtils.load_scene(self,Constants.ERROR)
	
	return current_options;


func save_options() -> void :
	var save_game_file = FileAccess.open(OPTIONS_FILENAME, FileAccess.WRITE)
	
	save_game_file.store_line(JSON.stringify(current_options))
	save_game_file.close()


func default_options() -> Dictionary :
	return {
		"general": {
			"vibration" : "true"
		},
		"graphics":{
			"camera_effect" : CameraEffects.GRAYSCALE
		},
		"audio" : {
			"volume" : "100",
			"music" : "true",
			"effects" : "true"
		}	
	}

func is_vibration_enabled() -> bool:
	return true if current_options.get("general").get("vibration") == "true" else false


func toggle_vibration():
	current_options.get("general")["vibration"] = str(not is_vibration_enabled());


func get_camera_filter() ->String :
	return current_options.get("graphics")["camera_effect"];


func set_camera_filter(filter : String):
	current_options.get("graphics")["camera_effect"] = filter;


func set_volume(level : int):
	print("Vol: " + str(level))
	
	current_options["audio"]["volume"] = str(level)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -35 + 45 * level/100)
	save_options()
