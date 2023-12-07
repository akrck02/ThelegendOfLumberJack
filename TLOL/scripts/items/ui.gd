extends CanvasLayer


@onready var life_bar : Node2D = $LifeBar
@onready var coins_label : Label = $CoinCount/Label
@onready var dialogue_box : DialogueBox = $DialogueBox

# Life stats
const HEARTS_PER_ROW = 30
const LIFE_BAR_START_X = 80
const LIFE_BAR_START_Y = 80
const LIFE_BAR_JUMP = 80
const LIFE_BAR_SPACING = 40

# Called when the node enters the scene tree for the first time.
func _ready():
	
	SignalDatabase.ui_health_changed.connect(set_life)
	SignalDatabase.ui_coins_gathered.connect(set_coins)
	SignalDatabase.ui_conversation_started.connect(show_conversation)
	
	dialogue_box.hide()
	set_coins()
	set_life(3,3)

func set_coins(coins = 0):
	coins_label.text = String("%04d" % coins);


func set_life(hearts = 0, max_hearts = 10):
	
	var heartnodes = [];
	var x = LIFE_BAR_START_X;
	var y = LIFE_BAR_START_Y;
	
	for j in max_hearts:
		
		if(j >= HEARTS_PER_ROW and j % HEARTS_PER_ROW == 0):
			y += LIFE_BAR_JUMP
			x = LIFE_BAR_START_X
			
		var sprite = Sprite2D.new()
		sprite.texture = Constants.HEART_SPRITE
		sprite.position = Vector2(x, y)
		sprite.hframes = 4
		sprite.vframes = 1
		heartnodes.append(sprite)
		life_bar.add_child(sprite)
		x += LIFE_BAR_SPACING
	
	var _offset = 0.5
	var state = 0
	
	for i in heartnodes.size():
		
		state = (hearts + _offset) - (i + 1) 
		
		if state == 0: 
			state = 1
		elif state < 0:
			state = 2
		else :
			state = 0
		
		heartnodes[i].set_frame(state)


func show_dialog_box():
	dialogue_box.show()


func hide_dialog_box():
	dialogue_box.hide()


func show_conversation(dialogues : Dictionary, character_id : String, conversation_id : String):
	show_dialog_box()
	dialogue_box.start(dialogues, character_id, conversation_id);
	

