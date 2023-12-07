extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var coin_sound = $CoinSound

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("idle");


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

# Handle body trigger
func _on_area_2d_body_entered(body):
	
	# if player detected
	if EngineUtils.is_player(body):
		queue_free()
		SoundManager.play_coin()
		SignalDatabase.player_coins_gathered.emit(1)
