extends Node2D


@onready var PressStartAnimationPlayer = $PressStart/AnimationPlayer 

# Called when the node enters the scene tree for the first time.
func _ready():
	PressStartAnimationPlayer.play("press_start_idle")

func _process(_delta):
	if Input.is_action_just_pressed(Controls.START):
		EngineUtils.load_scene(self,Constants.LEVEL_1)
