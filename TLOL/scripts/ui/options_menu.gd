extends CanvasLayer

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var exit_button : Button = $Control/Control/ExitButton
@onready var general_button : Button = $Control/Control/Navbar/GeneralButton
@onready var timer : Timer = $Timer

@onready var general_options = $Control/GeneralOptionsMenu
@onready var graphics_options = $Control/GraphicsOptionsMenu
@onready var audio_options = $Control/AudioOptionsMenu

@onready var saving_game_label = $SavingGameLabel
@onready var saving_game_label_animation_player = $SavingGameLabel/AnimationPlayer

var showing: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalDatabase.ui_show_settings.connect(show_menu)
	show_menu_option("general")
	self.hide()

# Show the menu
func show_menu():
	saving_game_label.hide()
	self.show()
	exit_button.grab_focus()
	animation_player.play("in")
	
	SignalDatabase.world_stopped.emit()


# Hide the menu
func hide_menu():
	exit_button.release_focus()
	animation_player.play("out")
	SignalDatabase.world_restarted.emit()


func show_menu_option(option: String): 
	match option:
		"general": 
			graphics_options.hide_menu()
			audio_options.hide_menu()
			general_options.show_menu()
		"graphics":
			audio_options.hide_menu()
			general_options.hide_menu()
			graphics_options.show_menu()
		"audio":
			graphics_options.hide_menu()
			general_options.hide_menu()
			audio_options.show_menu()


func exit_game():
	get_tree().quit()


func save_game():
	
	saving_game_label.show()
	saving_game_label_animation_player.play("Save")
	SignalDatabase.save_game_requested.emit()
	timer.start()
	await timer.timeout
	saving_game_label_animation_player.play("RESET")
	saving_game_label.hide()
