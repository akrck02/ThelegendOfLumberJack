extends CharacterBody2D

@onready var icon : Sprite2D = $InteractIcon
@onready var ui : CanvasLayer = EngineUtils.get_ui(self)
@export var npc_name : String = "Mary"

func _ready():
	SignalDatabase.dialogue_ended.connect(listen_dialog_end)
	icon.hide()

func show_interaction_icon():
	icon.show()
	

func hide_interaction_icon():
	icon.hide()


func interact():
	hide_interaction_icon()
	_talk()


func _talk():
	var dialogues : Dictionary = DialogueManager.load_scene()
	
	if LevelManager.EVENT_FLAGS["crab_defeated"] == "false":
		SignalDatabase.ui_conversation_started.emit(dialogues, npc_name, "start")
	else:
		SignalDatabase.ui_conversation_started.emit(dialogues,npc_name,"end")


func listen_dialog_end(character_id: String):
	
	if character_id != npc_name:
		return
	
	if LevelManager.EVENT_FLAGS["crab_defeated"] == "false":
		return
	
	SignalDatabase.scene_change_requested.emit(Constants.CREDITS)
