extends Node2D

@onready var scene_path = scene_file_path

func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	hide_collected_items()
	
func hide_collected_items() -> void:
	#Hide coins
	for coin in get_tree().get_nodes_in_group("coins"):
		if SaveManager.world_data.is_coin_collected(scene_path, coin.name):
			coin.queue_free()
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if SaveManager.world_data.is_enemy_killed(scene_path, enemy.enemy_id):
			enemy.queue_free()
