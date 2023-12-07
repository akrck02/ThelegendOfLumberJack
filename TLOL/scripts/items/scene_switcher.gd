extends Node2D

@export var scene : String = "";


func _on_area_2d_body_entered(body):
	
	if EngineUtils.is_player(body): 
		
		if OptionsManager.is_vibration_enabled():
			Input.start_joy_vibration(0,0,0.3,0.01)
		
		SoundManager.play_door()
		SignalDatabase.scene_change_requested.emit(scene)
