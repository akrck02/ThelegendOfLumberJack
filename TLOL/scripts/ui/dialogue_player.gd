extends Node
class_name  DialoguePlayer

signal finished

var title : String = ""
var text : String = ""

var _conversation : Array
var _current_index : int = 0

func start(dialogue_dict : Dictionary, character_id : String, conversation_id : String) -> void:
	_conversation = dialogue_dict.get(character_id).get(conversation_id)
	_current_index = 0
	title = character_id
	_update()


func next() -> void:
	_current_index += 1
	assert(_current_index <= _conversation.size())
	_update()


func _update() -> void:
	
	text = _conversation[_current_index]
	
	if _current_index >= _conversation.size() -1: 
		finished.emit()
		

