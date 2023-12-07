extends Control

func _ready():
	SignalDatabase.ui_camera_filter_changed.emit(OptionsManager.get_camera_filter())

func show_menu():
	self.show()


func hide_menu():
	self.hide() 


func set_effect(effect : String):
	
	match effect: 
		"scanlines":
			SignalDatabase.ui_camera_filter_changed.emit(CameraEffects.SCANLINES)
			OptionsManager.set_camera_filter(CameraEffects.SCANLINES)
		"grayscale":
			SignalDatabase.ui_camera_filter_changed.emit(CameraEffects.GRAYSCALE)
			OptionsManager.set_camera_filter(CameraEffects.GRAYSCALE)
		"midnight":
			SignalDatabase.ui_camera_filter_changed.emit(CameraEffects.MIDNIGHT)
			OptionsManager.set_camera_filter(CameraEffects.MIDNIGHT)
		"grainy":
			SignalDatabase.ui_camera_filter_changed.emit(CameraEffects.GRAINY)
			OptionsManager.set_camera_filter(CameraEffects.GRAINY)
		"cozy":
			SignalDatabase.ui_camera_filter_changed.emit(CameraEffects.COZY)
			OptionsManager.set_camera_filter(CameraEffects.COZY)
		_:
			SignalDatabase.ui_camera_filter_changed.emit(CameraEffects.NONE)
			OptionsManager.set_camera_filter(CameraEffects.NONE)
	
	OptionsManager.save_options()
