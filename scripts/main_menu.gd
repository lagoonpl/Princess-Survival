extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_game_pressed() -> void:
	SaveManager.new_game()
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_options_pressed() -> void:
	if FileAccess.file_exists(SaveManager.SAVE_PATH):
		get_tree().change_scene_to_file("res://scenes/game.tscn")
	else:
		print("No save - start new game?")
		get_tree().change_scene_to_file("res://scenes/game.tscn")
	


func _on_exit_pressed() -> void:
	get_tree().quit()
