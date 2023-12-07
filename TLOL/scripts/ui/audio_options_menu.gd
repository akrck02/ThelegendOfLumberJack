extends Control

@onready var volume_slider : HSlider = $VolumeSlider 
@onready var percentage_label : Label = $Percent


func show_menu():
	var level = int(OptionsManager.current_options["audio"]["volume"]);
	percentage_label.text = str(level) + "%"
	volume_slider.set_value_no_signal(level)
	self.show()


func hide_menu():
	self.hide() 


func _on_volume_slider_value_changed(value):
	SignalDatabase.volume_changed.emit(value)
	percentage_label.text = str(value) + "%"
