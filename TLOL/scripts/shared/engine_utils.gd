class_name EngineUtils

# Change the current scene
static func load_scene(node : Node, scene : String = ""):
	
	if scene.begins_with("res://"):
		node.get_tree().change_scene_to_file(scene)
		return
	
	node.get_tree().change_scene_to_file(Constants.SCENE_PATH + scene)

# Reload current scene
static func reset_scene(node : Node):
	node.get_tree().reload_current_scene()


# Get if current node is player
static func is_player(node : Node) -> bool:
	
	if not node.is_in_group("Players"):
		return false
		
	if not node.has_method("take_damage"):
		return false
	
	return true
	

# Get if current node is enemy
static func is_enemy(node : Node) -> bool:
	
	if not node.is_in_group("Enemies"):
		return false
		
	if not node.has_method("take_damage"):
		return false
	
	return true


# Get if current node is interactable
static func is_interactable(node : Node) -> bool:
	
	if not node.is_in_group("Interactable"): 
		return false

	if not node.has_method("show_interaction_icon"):
		return false

	if not node.has_method("hide_interaction_icon"):
		return false

	if not node.has_method("interact"):
		return false
	
	return true

# Get current time 
static func current_time() -> float:
	return Time.get_unix_time_from_system();

# Get UI
static func get_ui(node : Node) -> CanvasLayer:
	return node.get_tree().get_root().find_child("UI", true, false)
