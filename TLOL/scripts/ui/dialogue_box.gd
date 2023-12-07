extends Control
class_name DialogueBox

signal dialogue_ended()

@onready var dialogue_player = $DialoguePlayer as DialoguePlayer
@onready var NameLabel = $Panel/Columns/Name as Label
@onready var TextLabel = $Panel/Columns/Text as Label
@onready var ButtonNext = $Panel/Columns/ButtonNext as Button
@onready var ButtonFinish = $Panel/Columns/ButtonFinish as Button

var current_character_id : String;

func start(dialogue : Dictionary , character_id : String, conversation_id : String) -> void:
	
	SignalDatabase.player_stop.emit()
	ButtonFinish.hide()
	ButtonNext.show()
	ButtonNext.grab_focus()
	current_character_id = character_id
	dialogue_player.start(dialogue, character_id, conversation_id)
	update_content()
	show()


func _on_button_next_pressed() -> void:
	dialogue_player.next()
	update_content()


func _on_button_finish_pressed() -> void:
	SignalDatabase.dialogue_ended.emit(current_character_id)
	SignalDatabase.player_restart.emit()
	hide()


func update_content() -> void:
	var dialogue_player_name = dialogue_player.title
	NameLabel.text = dialogue_player_name
	TextLabel.text = dialogue_player.text


func _on_dialogue_player_finished() -> void:
	ButtonNext.hide()
	ButtonFinish.grab_focus()
	ButtonFinish.show()
