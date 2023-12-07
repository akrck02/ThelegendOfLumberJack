extends Node2D

@onready var camera_animator : AnimationPlayer = $Camera2D/CameraAnimator;


# Called when the node enters the scene tree for the first time.
func _ready():
	camera_animator.play("credits")
	print("playing")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if Input.is_action_just_pressed(Controls.INTERACT):
		SignalDatabase.game_beated.emit()
		SignalDatabase.scene_change_requested.emit("start_menu.tscn")
