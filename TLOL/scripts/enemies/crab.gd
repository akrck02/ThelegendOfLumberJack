extends CharacterBody2D

# Nodes
@onready var Animator = $AnimationPlayer

# Movement constants
const MOVE_SPEED : float = 250
const MOVE_TIME : float = 1
const MOTION_SMOOTHNESS = 0.9

# Motion states
var motion : Vector2 = Vector2()
var moving = true
var step = 0
var last_moving_time = -1

# Movement patterns 
const pattern = [
	Direction.DOWN, 
	Direction.NONE, 
	Direction.RIGHT,
	Direction.NONE, 
	Direction.RIGHT, 
	Direction.NONE, 
	Direction.UP, 
	Direction.NONE, 
	Direction.RIGHT,
	Direction.NONE,  
	Direction.DOWN, 
	Direction.NONE, 
	Direction.LEFT, 
	Direction.NONE, 
	Direction.LEFT, 
	Direction.NONE, 
	Direction.UP,
	Direction.NONE, 
]

# Player hurting values
const CRAB_IDLE_DAMAGE = .5;
var players = []

signal defeated

## On ready
func _ready():
	Animator.play("Move")

## Take damage
func take_damage(_damage):
	queue_free()
	defeated.emit()

func _physics_process(_delta):
	_move()
	_check_damage()

# Crab movement logic
func _move():
	if !moving:
		return
			
	var time = EngineUtils.current_time()
	
	if(is_fist_time_moving()):
		last_moving_time = EngineUtils.current_time()
	
	var current_direction = Direction.NONE;
	var has_become_conscious = false
	
	if(move_time_has_passed(time)):
		
		has_become_conscious = randf_range(0, 100) > 25
		step += 1
		last_moving_time = EngineUtils.current_time()
		
		if(pattern.size() <= step):
			step = 0


	current_direction = Direction.get_random_direction() if has_become_conscious else pattern[step]

	motion = Vector2()
	match current_direction:

		Direction.UP:
			motion.y = -lerp(motion.y,MOVE_SPEED,.9)

		Direction.DOWN:
			motion.y = lerp(motion.y,MOVE_SPEED,.9)

		Direction.LEFT:
			motion.x = -lerp(motion.x,MOVE_SPEED,.9)

		Direction.RIGHT:
			motion.x = lerp(motion.x,MOVE_SPEED,.9)

	set_velocity(motion)
	set_floor_stop_on_slope_enabled(false)
	set_max_slides(4)
	set_floor_max_angle(PI/4)
	move_and_slide()


## Get if it is the first time moving
func is_fist_time_moving() -> bool:
	return last_moving_time == -1


## Get if the moving time has passed
func move_time_has_passed(time) -> bool:
	return time - last_moving_time > MOVE_TIME


func _check_damage():
	
	for player in players:
		
		if OptionsManager.is_vibration_enabled():
			Input.start_joy_vibration(0,0.25,0,0.1)
		
		player.take_damage(CRAB_IDLE_DAMAGE)


func _on_area_2d_body_entered(body):
	
	if EngineUtils.is_player(body):
		players.append(body)


func _on_area_2d_body_exited(body):
	
	if EngineUtils.is_player(body):
		players.remove_at(players.find(body))
