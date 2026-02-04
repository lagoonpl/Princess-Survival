extends Resource

class_name WorldData

@export var total_coins: int = 0
@export var enemies_killed: int = 0
@export var scene_states: Dictionary = {} #"res://scenes/level1.tscn":{"coins_collected": [id1, id2], "enemies_killed": [id3]}

#Add coints/enemies by unique ID (Node.name or @export var id)
func collect_coin(scene_path: String, coin_id: String) -> void:
	if not scene_states.has(scene_path):
		scene_states[scene_path] = {"coins": [], "enemies": []}
	if not coin_id in scene_states[scene_path].coins:
		scene_states[scene_path].coins.append(coin_id)
		total_coins +=1
		
func kill_enemy(scene_path: String, enemy_id: String) -> void:
	if not scene_states.has(scene_path):
		scene_states[scene_path] = {"coins": [], "enemies": []}
	if not enemy_id in scene_states[scene_path].coins:
		scene_states[scene_path].enemies.append(enemy_id)
		enemies_killed +=1
		
func is_coin_collected(scene_path: String, coin_id: String) -> bool:
	var scene_dict = scene_states.get(scene_path, {})
	var coins = scene_dict.get("coins", [])
	return coins.has(coin_id)

func is_enemy_killed(scene_path: String, enemy_id: String) -> bool:
	var scene_dict =scene_states.get(scene_path, {})
	var enemies = scene_dict.get("enemies", [])
	return enemies.has(enemy_id)
