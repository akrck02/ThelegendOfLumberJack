extends Node2D

var EVENT_FLAGS : Dictionary = {}

func _ready():
	SignalDatabase.player_death.connect(load_death_scene)
	SignalDatabase.scene_change_requested.connect(change_scene)
	SignalDatabase.start_level_requested.connect(start_level)
	
	SignalDatabase.world_stopped.connect(stop_world)
	SignalDatabase.world_restarted.connect(restart_world)
	
	SignalDatabase.player_stop.connect(stop_player)
	SignalDatabase.player_restart.connect(restart_player)
	
	SignalDatabase.crab_defeated.connect(set_crab_defeated)


func change_scene(scene : String, clear_player_position : bool = true) -> void : 
	var current_savestate : Dictionary = SaveManager.get_savestate()
	
	if clear_player_position:
		current_savestate["Player"]["pos_x"] = null
		current_savestate["Player"]["pos_y"] = null 
		
	EngineUtils.load_scene(self,scene)


func start_level() -> void : 
	var current_savestate : Dictionary = SaveManager.get_savestate()
	EngineUtils.load_scene(self, current_savestate["level"])


func load_death_scene():
	EngineUtils.load_scene(self,Constants.DEATH)


func stop_world():
	var nodes = get_tree().get_nodes_in_group("World")
	
	for node in nodes:
		node.set_physics_process(false)
		node.set_process(false)
		node.set_process_input(false)
		node.set_process_internal(false)


func restart_world():
	var nodes = get_tree().get_nodes_in_group("World")
	
	for node in nodes:
		node.set_physics_process(true)
		node.set_process(true)
		node.set_process_input(false)
		node.set_process_internal(true)


func stop_player():
	var nodes = get_tree().get_nodes_in_group("Players")
	
	for node in nodes:
		node.set_physics_process(false)
		node.set_process(false)
		node.set_process_input(false)
		node.set_process_internal(false)


func restart_player():
	var nodes = get_tree().get_nodes_in_group("Players")
	
	for node in nodes:
		node.set_physics_process(true)
		node.set_process(true)
		node.set_process_input(false)
		node.set_process_internal(true)


func set_crab_defeated():
	EVENT_FLAGS["crab_defeated"] = "true"
	SignalDatabase.save_game_requested.emit()
	SignalDatabase.scene_change_requested.emit("credits.tscn")


func set_game_defeated():
	EVENT_FLAGS["game_defeated"] = "true"
	SignalDatabase.save_game_requested.emit()
	
