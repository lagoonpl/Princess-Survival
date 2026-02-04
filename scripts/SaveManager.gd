extends Node
const SAVE_PATH = "user://savegame.tres"
const WORLD_PATH = "user://world.tres"
var player_data: PlayerData = PlayerData.new()
var world_data: WorldData = WorldData.new()
var is_new_game: bool = false
func new_game() -> void:
	world_data = WorldData.new() #Fresh state
	is_new_game = true
	
	
func save_game(player: Node2D) -> void:
	if not player or not is_instance_valid(player):
		print("Player null can't save")
		return
	player_data.position = player.global_position
	player_data.has_double_jump = player.has_double_jump
	var error = ResourceSaver.save(player_data, SAVE_PATH)
	if error == OK:
		print("Saved at ", player_data.position)
	else:
		print("Save filed: ", error)
	ResourceSaver.save(world_data, WORLD_PATH)
	
func load_game(player: Node2D) -> void:
	if not player or not is_instance_valid(player):
		print("player null, skipping load")
		return
	if is_new_game:
		is_new_game = false
		return
	#Always load world
	if FileAccess.file_exists(WORLD_PATH):
		world_data = ResourceLoader.load(WORLD_PATH) as WorldData
	if not FileAccess.file_exists(SAVE_PATH):
		return
	#Player only if exists
	if not FileAccess.file_exists(SAVE_PATH):
		return
	player_data = ResourceLoader.load(SAVE_PATH) as PlayerData
	world_data = ResourceLoader.load(WORLD_PATH) as WorldData
	player.global_position = player_data.position
	player.has_double_jump = player_data.has_double_jump
	
		
func reset_game() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)
		print("🗑️ Reset save")
	else:
		print("No save to reset")
