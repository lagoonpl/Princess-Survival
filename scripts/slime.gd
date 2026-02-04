extends Node2D
class_name Enemy

const SPEED = 60
var direction =1
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var dead = false
var health = 1

@onready var attackhitbox: Area2D = $Attackhitbox
@onready var timer: Timer = $Timer
@export var enemy_id: String
@onready var killzone: Area2D = $"../Killzone"
@onready var ray_cast_floor: RayCast2D = $RayCastFloor

func _ready() -> void:
	add_to_group("enemies")
	if enemy_id.is_empty():
		enemy_id = name
	var scene_path = get_tree().current_scene.scene_file_path
	if SaveManager.world_data.is_enemy_killed(scene_path, enemy_id):
		queue_free()
		return
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if dead:
		return #stops movement when dead
	
	ray_cast_floor.position.x = 15 * direction
	ray_cast_floor.force_raycast_update()
	
	if ray_cast_right.is_colliding():
			direction = -1
			animated_sprite.flip_h = true
	if ray_cast_left.is_colliding():
			direction = 1
			animated_sprite.flip_h = false
	if !ray_cast_floor.is_colliding():
		direction *= -1
		animated_sprite.flip_h = direction < 0
		return
			 
	position.x += direction * SPEED * delta
	

  
func _on_get_damage_area_entered(area: Area2D) -> void:
	if dead: return
	if area.is_in_group("sword"):
		dead = true
		killzone.monitoring = false # disables killzone detection
		killzone.get_node("CollisionShape2D").set_deferred("disabled", true)
		animated_sprite.play("dead")
		var scene_path = get_tree().current_scene.scene_file_path
		SaveManager.world_data.kill_enemy(scene_path, enemy_id)
		SaveManager.save_game(null)
	if area.is_in_group("enemies"):
		var scene_path = get_tree().current_scene.scene_file_path
		SaveManager.world_data.kill_enemy(scene_path, enemy_id)
		SaveManager.save_game(null)
		
		

	#	queue_free()
func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "dead":
		killzone.monitoring = true
		killzone.get_node("CollisionShape2D").set_deferred("disabled", false)

		queue_free()
	
func _on_killzone_body_entered(body: Node2D) -> void:
	print("you died!")
	Engine.time_scale = 0.5
	body.get_node("CollisionShape2D").queue_free()
	timer.start()
func _on_timer_timeout():
	Engine.time_scale = 1
	get_tree().reload_current_scene()
	
