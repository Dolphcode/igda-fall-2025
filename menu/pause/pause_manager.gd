extends CanvasLayer

@onready var game: GameManager = get_tree().root.get_node("Game")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause") and not game.lose:
		get_tree().paused = true
		visible = true

func resume():
	get_tree().paused = false
	visible = false


func restart():
	get_tree().paused = false
	game.restart_game()


func exit():
	get_tree().paused = false
	game.return_to_main()
