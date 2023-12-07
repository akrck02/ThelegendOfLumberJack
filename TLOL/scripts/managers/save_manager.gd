extends Node

const SAVE_FILENAME = "user://tlol.save.json";
var current_savestate : Dictionary;

func _ready():
	SignalDatabase.new_game_created.connect(new_game)
	SignalDatabase.save_game_requested.connect(save_game)
	SignalDatabase.save_player_requested.connect(save_player)

func new_game() -> Dictionary: 
	var save_game_file = FileAccess.open(SAVE_FILENAME, FileAccess.WRITE)
	
	current_savestate = {
		"played_time" : str(0), 
		"start" : str(EngineUtils.current_time()),
		"last_start" : str(EngineUtils.current_time()),
		"last_end" : str(EngineUtils.current_time()),
		"level" : Constants.LEVEL_1 ,
		"Player" : Player.get_default_savestate(),
		"event_flags" : {
			"crab_defeated" : str(false),
			"game_defeated" : str(false)
		}
	}
	
	save_game_file.store_line(JSON.stringify(current_savestate))
	return current_savestate


func load_game() -> Dictionary:	
	
	if not FileAccess.file_exists(SAVE_FILENAME):
		return {};

	var save_game_file = FileAccess.open(SAVE_FILENAME, FileAccess.READ).get_as_text()

	var json : JSON = JSON.new()
	var result = json.parse(save_game_file)
	
	if result == OK:
		var data_received = json.data
		if typeof(data_received) == TYPE_DICTIONARY:
			current_savestate = data_received
			
			LevelManager.EVENT_FLAGS = current_savestate["event_flags"]
			
			current_savestate["last_start"] = str(EngineUtils.current_time())
			return data_received
		
	else:
		## Load error scene
		print("JSON Parse Error: ", json.get_error_message(), " in ", save_game_file, " at line ", json.get_error_line())
		SignalDatabase.scene_change_requested.emit(Constants.ERROR)
	
	return {}


func get_savestate() -> Dictionary:
	return current_savestate


func save_player(player : Dictionary) -> void:
	current_savestate["Player"] = player


func save_game() -> void:
	
	var save_game_file = FileAccess.open(SAVE_FILENAME, FileAccess.WRITE)
	var save_nodes = self.get_tree().get_nodes_in_group("Persistent")

	current_savestate["played_time"] = EngineUtils.current_time() - float(current_savestate["last_start"])
	
	for persistent_node in save_nodes:
		
		current_savestate["level"] = persistent_node.owner.get_scene_file_path()
	
		# Check the node has a save function.
		if !persistent_node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % persistent_node.name)
			continue

		# Call the node's save function.
		var node_data = persistent_node.call("save")
		current_savestate[persistent_node.name] = node_data;
	
	
	current_savestate["event_flags"] = LevelManager.EVENT_FLAGS
	
	save_game_file.store_line(JSON.stringify(current_savestate))
	save_game_file.close()
