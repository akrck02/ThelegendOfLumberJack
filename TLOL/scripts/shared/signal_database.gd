extends Node

# Engine signals
signal scene_change_requested(scene : String)
signal start_level_requested
signal world_stopped
signal world_restarted
signal game_beated
signal crab_defeated
signal dialogue_ended(character_id: String)

# Manager signals
signal new_game_created
signal save_game_requested
signal save_player_requested(player : Dictionary)
signal volume_changed(volume : int)
signal vibration_changed(vibrate : bool)

# Player signals
signal player_coins_gathered(coins : int)
signal player_death
signal player_stop
signal player_restart

# UI signals
signal ui_health_changed(life : float, max_life : float)
signal ui_coins_gathered(coins : int)
signal ui_conversation_started(dialogues : Dictionary, character_id : String, conversation_id : String)
signal ui_show_settings
signal ui_camera_filter_changed(filter : String)
