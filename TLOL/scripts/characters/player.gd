class_name Player
extends CharacterBody2D

# Movement stats 
@export var MOVE_SPEED : float = 500.0
@export var MOVEMENT_SMOOTHNESS : float = 0.9
@export var motion : Vector2 = Vector2() 
@export var direction : int = Direction.DOWN

# Player stats
@export var stats : PlayerStats = PlayerStats.new()

# Player hurt 
@onready var hurt_sound : AudioStreamPlayer = $HurtSound
const DAMAGE_COOLDOWN = .5
var last_damage_time = -1

# UI
@onready var Animator : AnimationPlayer = $AnimationPlayer 
@onready var Sprite : Sprite2D = $Sprite2D
const TILESET_WIDTH = 4

# Attack 
@onready var attack_sound : AudioStreamPlayer = $AttackSound
@onready var AttackAreaCollision : CollisionShape2D = $AttackArea/CollisionShape2D
const BASIC_ATTACK_DISTANCE : Vector2 = Vector2(70, 100)
var attackable_enemies = []

# Interaction
var interactable_item : Node2D

# Animations
const PLAYER_ANIMATION_UP = "PlayerUp"
const PLAYER_ANIMATION_DOWN = "PlayerDown"
const PLAYER_ANIMATION_LEFT = "PlayerLeft"
const PLAYER_ANIMATION_RIGHT = "PlayerRight"


func _on_ready():
	SignalDatabase.player_coins_gathered.connect(self.add_coins)

func _physics_process(_delta):
	
	# if scene reset is requested
	if Input.is_action_just_pressed(Controls.RESET_LEVEL):
		EngineUtils.reset_scene(self)
	
	_move()
	_interact()
	_attack()


# Default savestate
static func get_default_savestate() -> Dictionary :
	return {
		"filename" : "res://nodes/Player.tscn",
		"coins" : str(0),
		"life" : str(3),
		"max_life" : str(3)
	}


# Save player data
func save() -> Dictionary :
	
	var save_dic = {
		"filename" : self.get_scene_file_path(),
		"pos_x" : str(self.position.x),
		"pos_y" : str(self.position.y),
		"coins" : str(self.stats._get_coins()),
		"life" : str(self.stats._get_life()),
		"max_life" : str(self.stats._get_max_life())
	}
	
	return save_dic

# Load player data
func load_savestate(data : Dictionary) -> void :
	
	self.stats._coins = data["coins"]
	self.stats._life = data["life"]
	self.stats._max_life = data["max_life"]
	
	if data.has("pos_x") and data["pos_x"] != null and data.has("pos_y") and data["pos_y"] != null:
		self.position.x = float(data["pos_x"])
		self.position.y = float(data["pos_y"])

# Add coins to Player inventory
func add_coins(coins : int = 1):
	self.stats.add_coins(coins)
	
	if self.stats._coins % 6 == 0:
		self.stats._max_life += 1; 
		self.stats._life = self.stats._max_life
		SignalDatabase.ui_health_changed.emit(self.stats._life,self.stats._max_life)
	
	var current_player = save()
	SignalDatabase.save_player_requested.emit(current_player)
	SignalDatabase.ui_coins_gathered.emit(stats._get_coins())


# Apply damage to Player
func take_damage(damage = 0.5):
	
	## If cooldown has not expired 
	if !_damage_cooldown_has_passed(): 
		return
	
	## Damage the player
	stats.damage(damage)
	last_damage_time = EngineUtils.current_time()
	
	hurt_sound.play()
	
	var current_player = save()
	SignalDatabase.save_player_requested.emit(current_player)
	SignalDatabase.ui_health_changed.emit(self.stats._life, self.stats._max_life)
	
	if(stats._get_life() <= 0):
		SignalDatabase.player_death.emit()


## Get if the damage cooldown has passed
func _damage_cooldown_has_passed():
	var time = EngineUtils.current_time()
	return time - last_damage_time > DAMAGE_COOLDOWN

# Check player movement
func _interact() -> void:
	
	if Input.is_action_just_pressed(Controls.START):
		SignalDatabase.ui_show_settings.emit()
	
	
	if Input.is_action_just_pressed(Controls.INTERACT) and interactable_item != null:
		interactable_item.interact();
	


# Check player movement
func _move(): 
	
	motion = Vector2()
	
	# Reset to idle
	var is_movement_just_released = Input.is_action_just_released(Controls.RIGHT) || Input.is_action_just_released(Controls.LEFT) || Input.is_action_just_released(Controls.UP) || Input.is_action_just_released(Controls.DOWN)
	if is_movement_just_released:
		_reset_to_idle()
		Animator.stop()
	
	# Right movement
	if Input.is_action_pressed(Controls.RIGHT):
		motion.x = lerp(motion.x, MOVE_SPEED, MOVEMENT_SMOOTHNESS)
		direction = Direction.RIGHT
		AttackAreaCollision.position = Vector2(BASIC_ATTACK_DISTANCE.x,0)
		Animator.play(PLAYER_ANIMATION_RIGHT)

	# Left movement
	elif Input.is_action_pressed(Controls.LEFT):
		motion.x = -lerp(motion.x, MOVE_SPEED, MOVEMENT_SMOOTHNESS)
		direction = Direction.LEFT
		AttackAreaCollision.position = Vector2(-BASIC_ATTACK_DISTANCE.x,0)
		Animator.play(PLAYER_ANIMATION_LEFT)

	# Up movement
	elif Input.is_action_pressed(Controls.UP):
		motion.y = -lerp(motion.y, MOVE_SPEED, MOVEMENT_SMOOTHNESS)
		direction = Direction.UP
		AttackAreaCollision.position = Vector2(0,-BASIC_ATTACK_DISTANCE.y)
		Animator.play(PLAYER_ANIMATION_UP)

	# Down movement
	elif Input.is_action_pressed(Controls.DOWN):
		motion.y = lerp(motion.y, MOVE_SPEED, MOVEMENT_SMOOTHNESS)
		direction = Direction.DOWN
		AttackAreaCollision.position = Vector2(0,BASIC_ATTACK_DISTANCE.y)
		Animator.play(PLAYER_ANIMATION_DOWN)

	set_velocity(motion)
	set_floor_stop_on_slope_enabled(false)
	set_max_slides(4)
	set_floor_max_angle(PI/4)
	move_and_slide()


# Check player attack
func _attack():
	
	if Input.is_action_just_pressed(Controls.ATTACK):
		match direction:
			Direction.DOWN:
				Sprite.frame = TILESET_WIDTH - 1
			Direction.UP:
				Sprite.frame = TILESET_WIDTH * 2 - 1
			Direction.LEFT:
				Sprite.frame = TILESET_WIDTH * 3 - 1
			Direction.RIGHT:
				Sprite.frame = TILESET_WIDTH * 3 - 1
		
		attack_sound.play()
		
		if OptionsManager.is_vibration_enabled():
			Input.start_joy_vibration(0,.1,0.2,0.25)
		
		for enemy in attackable_enemies:
			enemy.take_damage(stats._get_attack())
		
	if Input.is_action_just_released(Controls.ATTACK):
		_reset_to_idle()

## Reset to Idle frame  
func _reset_to_idle():
	
	match direction:
		Direction.DOWN:
			Sprite.frame = 0
		Direction.UP:
			Sprite.frame = TILESET_WIDTH
		Direction.LEFT:
			Sprite.frame = TILESET_WIDTH * 2
		Direction.RIGHT:
			Sprite.frame = TILESET_WIDTH * 2


func _on_attack_area_body_entered(body):
	
	if EngineUtils.is_enemy(body):
		attackable_enemies.append(body)
		return
	
	if EngineUtils.is_interactable(body):
		interactable_item = body
		body.show_interaction_icon()
		return


func _on_attack_area_body_exited(body):
	
	if EngineUtils.is_enemy(body):
		attackable_enemies.remove_at(attackable_enemies.find(body))
		return

	if EngineUtils.is_interactable(body):
		interactable_item = null
		body.hide_interaction_icon()
		return


