extends Control

@onready var vibration_check_button : CheckButton = $VibrationCheckButton


func show_menu():
	var options : Dictionary = OptionsManager.current_options.get("general");
	var vibration_on : bool = true if options.get("vibration") == "true" else false
	
	vibration_check_button.set_pressed_no_signal(vibration_on)
	
	self.show()


func hide_menu():
	self.hide() 


func toggle_vibration():
	SignalDatabase.vibration_changed.emit()
	OptionsManager.save_options()
