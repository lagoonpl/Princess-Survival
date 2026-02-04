extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	get_tree().paused = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event: InputEvent):
	if Input.is_action_just_pressed("exit"):
		if get_tree().paused:
			visible = false
			get_tree().paused = false
		else:
			visible = true
			get_tree().paused = true
			

func _on_resume_pressed() -> void:
	get_tree().paused = false
	visible = false


func _on_back_to_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")



func _on_save_pressed() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player:
		SaveManager.save_game(get_tree().get_first_node_in_group("player"))
	else:
		print("No player in group!")
