extends Area2D
class_name Coin
@onready var game_manager: Node = %GameManager
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var coin_id: String #unique per coin

func _ready():
	add_to_group("coins")
	#check if already collected
	coin_id = name
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var scene_path = get_tree().current_scene.scene_file_path
		SaveManager.world_data.collect_coin(get_tree().current_scene.scene_file_path, coin_id)
		SaveManager.save_game(null)
	game_manager.add_point()
	animation_player.play("Pickup_Animation")
