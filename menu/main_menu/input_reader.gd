extends Node
## PLEASE DON'T LOOK AT THIS THIS IS SHIT CODE
@export var toggle_time: float = 0.1

@export var input_label: Label
@export var output_label: RichTextLabel
@export var line_count: int = 40

var input_text: String = ""
var console_output: Array[String]
var type_toggle: bool = true
var toggle_counter: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if not OS.is_debug_build():
		get_window().content_scale_size = Vector2i(576, 324) * 2
		get_window().size = Vector2i(576, 324) * 2
		get_window().content_scale_factor = 1.0
	
	if randi_range(0, 4096) == 4096:
		print_to_ui("[STATUS]: [color=purple]Congrats you got the [/color][color=yellow]shiny[/color][color=purple] status message[/color]")
	else:
		print_to_ui("[STATUS]: Program run [color=green]SUCCESSFUL[/color]")
	print_to_ui("OS Detected: [color=cyan]" + OS.get_distribution_name() + "[/color]")
	print_to_ui("SpinOS.orus [Version 0.0.2]")
	print_to_ui("Thank you for playing! Type [b][color=pink]\"HELP\"[/color][/b] for a list of commands")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	toggle_counter += delta
	if toggle_counter >= toggle_time:
		toggle_counter = 0
		type_toggle = not type_toggle
	
	if type_toggle:
		input_label.text = input_text + "█"
	else:
		input_label.text = input_text


func submit_command():
	if input_text.begins_with("HI") or input_text.begins_with("HELLO"):
		print_to_ui("[color=yellow]HELLO WORLD![/color]")
	elif input_text.begins_with("SPINOSAURUS"):
		print_to_ui("\u2800\u2800\u2800\u2800\u2800\u28C0\u28C0\u28C0\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u000D")
		print_to_ui("\u2800\u2800\u2800\u28FE\u28FF\u28FF\u28FF\u28FF\u28F7\u28C6\u2800\u2800\u2800\u2800\u2800\u2800\u28E0\u28E4\u28E4\u28E4\u28E4\u28C4\u2840\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u000D")
		print_to_ui("\u2800\u28E0\u28FE\u285F\u28BF\u28FF\u28FF\u28FF\u28FF\u28FF\u2844\u2800\u2800\u2880\u28F4\u28BF\u28FF\u28FF\u28FF\u28FF\u28FF\u28FF\u28FF\u28FF\u28F7\u28F6\u2844\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u000D")
		print_to_ui("\u28FE\u281B\u2803\u2800\u28B8\u28FF\u280B\u28BB\u28FF\u28FF\u28E7\u2800\u2880\u28FE\u28FF\u28BE\u28BB\u284F\u28FF\u28F9\u2847\u287F\u28FF\u28FF\u28FF\u28FF\u28FF\u2844\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u000D")
		print_to_ui("\u2800\u2800\u2800\u2880\u28FD\u2847\u2800\u28B8\u28FF\u28FF\u287F\u28F7\u28FF\u28FF\u28FF\u28FF\u28FF\u28F7\u28FF\u28FE\u28FF\u28FF\u28F8\u287F\u28FD\u28FF\u28FF\u2847\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u000D")
		print_to_ui("\u2800\u2800\u2800\u2808\u281B\u2800\u2800\u2808\u28BF\u28FF\u28DF\u28FF\u28FD\u28FF\u287B\u287F\u287F\u28FF\u28FF\u28FF\u28FF\u28FF\u28FF\u28FF\u28FF\u28CF\u28FF\u2847\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u000D")
		print_to_ui("\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2808\u28BB\u28FF\u28FF\u28FE\u28FF\u2876\u28D0\u2820\u2860\u287E\u2819\u2839\u28BF\u28FF\u28FF\u28FF\u28FF\u28FF\u28F7\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u000D")
		print_to_ui("\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2818\u28BF\u28FF\u28FF\u28FF\u28EF\u28F7\u28C6\u2844\u2861\u28F2\u2870\u28FE\u28FF\u28FD\u28FF\u28FF\u28FF\u28FF\u28F7\u28F6\u28E4\u28E4\u28C4\u28C0\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u000D")
		print_to_ui("\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2808\u28BF\u28FF\u287F\u28BF\u28FF\u28FF\u28FF\u28FF\u28FF\u28FF\u28FF\u28FF\u28FF\u28FF\u28FF\u28FF\u28FF\u28FF\u28FF\u28FF\u28FF\u28FB\u28FF\u28F7\u28E6\u28C4\u2840\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u000D")
		print_to_ui("\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u28B8\u28FF\u28FF\u2844\u2800\u2809\u2809\u281B\u28B9\u28FF\u28FF\u28FF\u28FF\u28FF\u287F\u283F\u283F\u28BF\u28FF\u28FF\u28FF\u28FD\u28F3\u28FF\u28FF\u28FF\u28FF\u28FF\u28F6\u28C4\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u000D")
		print_to_ui("\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u28B8\u28BB\u28FF\u285F\u2800\u2800\u2800\u2800\u2808\u28FF\u287F\u2808\u283B\u28BF\u28FF\u2840\u2800\u2800\u2800\u2808\u2809\u281B\u283F\u28BF\u28FF\u28EF\u28DF\u28FF\u28FF\u28FF\u28FF\u28FF\u28E6\u2840\u2800\u2800\u2800\u000D")
		print_to_ui("\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2818\u2800\u2801\u2800\u2800\u2800\u2800\u2800\u2800\u28B8\u28E7\u2800\u2800\u2800\u2839\u28F7\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2808\u2819\u281B\u283B\u283F\u28BF\u28FF\u28FF\u28FF\u28FF\u28FF\u28E7\u2800\u000D")
		print_to_ui("\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2880\u28E4\u28F4\u28FF\u2803\u2800\u2800\u28E4\u28FE\u287F\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2809\u281B\u283B\u289F\u28F7\u000D")
		print_to_ui("\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u000D")
		print_to_ui("\u000A\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800\u2800")
	elif input_text.begins_with("CLEAR"):
		clear_ui()
	elif input_text.begins_with("HELP"):
		print_to_ui("HELP MENU:")
		print_to_ui("	- HELP	 	-> Prints the help menu (duh I guess lol)")
		print_to_ui("	- CONTROLS	-> Prints the controls for the game")
		print_to_ui("	- CLEAR	 	-> Clears the console")
		print_to_ui("	- PLAY	 	-> Boots the main program (plays the game I'm being fancy)")
		print_to_ui("	- EXIT	 	-> Closes the program")
	elif input_text.begins_with("CONTROLS"):
		print_to_ui("CONTROLS MENU:")
		print_to_ui("	- MOVE UP	-> W or UP ARROW")
		print_to_ui("	- MOVE DOWN	-> S or DOWN ARROW")
		print_to_ui("	- MOVE LEFT	-> A or LEFT ARROW")
		print_to_ui("	- MOVE RIGHT-> D or RIGHT ARROW")
		print_to_ui("	- PAUSE		-> ESC")
	elif input_text.begins_with("EXIT"):
		get_tree().quit()
	elif input_text.begins_with("PLAY"):
		var inputs = input_text.split(" ")
		if len(inputs) <= 1:
			get_tree().change_scene_to_file("res://game/minigame/minigame.tscn")
		else:
			var arg = input_text.split(" ")[1]
			match arg:
				"EVIL":
					get_tree().change_scene_to_file("res://game/alt_games/minigame_evil.tscn")
				"HUGE":
					get_tree().change_scene_to_file("res://game/alt_games/minigame_huge.tscn")
				"MIN":
					get_tree().change_scene_to_file("res://game/alt_games/minigame_min.tscn")
				"MAX":
					get_tree().change_scene_to_file("res://game/alt_games/minigame_max.tscn")
				"ALPHA":
					get_tree().change_scene_to_file("res://game/alt_games/minigame_alpha.tscn")
				_:
					get_tree().change_scene_to_file("res://game/minigame/minigame.tscn")
	else:
		print_to_ui(input_text)
	input_text = ""


func clear_ui():
	console_output.clear()
	output_label.text = ""

func print_to_ui(txt: String):
	if len(console_output) >= line_count:
		console_output.remove_at(0)
	console_output.append(txt)
	
	# Update label
	var out_text = ""
	for out in console_output:
		out_text += out
		out_text += "\n"
		
	output_label.text = out_text


func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ENTER:
			submit_command()
		elif event.keycode == KEY_BACKSPACE:
			if len(input_text) > 0:
				input_text = input_text.left(len(input_text) - 1)
		elif ((event.keycode >= 65 and event.keycode <= 65 + 25) or char(event.key_label) == " "):
			input_text += char(event.key_label)
