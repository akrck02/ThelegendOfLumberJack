extends Node

func load_scene() -> Dictionary:
	var context = self.get_tree().get_current_scene().get_name()
	var path = Constants.DILOGUE_FILE_TEMPLATE.replace("$file",context);
	
	# Check if file exists
	if not FileAccess.file_exists(path):
		
		## Load error scene
		print("ERROR READING DIALOGUE FILE!")
		EngineUtils.load_scene(self,Constants.ERROR)
		return {}
	
	# Read current data
	var file = FileAccess.open(path,FileAccess.READ).get_as_text()
	var json : JSON = JSON.new()
	var result = json.parse(file)
	
	if result == OK:
		var data_received = json.data
		if typeof(data_received) == TYPE_DICTIONARY:
			return data_received
		
	else:
		## Load error scene
		print("JSON Parse Error: ", json.get_error_message(), " in ", file, " at line ", json.get_error_line())
		EngineUtils.load_scene(self,Constants.ERROR)
		
	return {}

## Get the requested dialogue
static func get_dialog(dialogues : Dictionary, objectID : String, dialogueID : String): 
	
	if not objectID in dialogues:
		return "..."
	
	if not dialogueID in dialogues[objectID]:
		return "..."
	
	return dialogues[objectID][dialogueID]

