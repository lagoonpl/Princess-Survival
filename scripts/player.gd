extends CharacterBody2D



var is_attacking = false

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var JumpCount: int = 0
var max_jumps_base = 1 #Ground jump
var max_jumps_powered = 2 #double jump
var has_double_jump = false #Set to true on powerup pickup
var attack_timer: float = 0.0 #manual timer backup

@onready var collision_shape_2d: CollisionShape2D = $"Attackhitbox/CollisionShape2D"
@onready var damage_hitbox: CollisionShape2D = $Area2D/DamageHitbox
@onready var attackhitbox: Area2D = $Attackhitbox

const DIRECTION_TO_FRAME: = {
	Vector2.DOWN: 0,
	Vector2.DOWN + Vector2.RIGHT: 1,
	Vector2.RIGHT: 2,
	Vector2.UP + Vector2.RIGHT: 3,
	Vector2.UP: 4
}




func _ready():
	animated_sprite_2d.play("idle")
	attackhitbox.add_to_group("sword")
	add_to_group("player")
	call_deferred("load_player_data")
	
func load_player_data():
		SaveManager.load_game(self)
	
func _physics_process(delta: float) -> void:
	
	#Attack override
	if is_attacking:
		attack_timer -= delta #countdown
		if attack_timer <=0:
			is_attacking = false
			animated_sprite_2d.play("idle")
		return #Skip movement/animation until attack done
	
	if is_on_floor():
		JumpCount = 0
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	#Double jump.
	
	if Input.is_action_just_pressed("jump") and JumpCount < (max_jumps_powered if has_double_jump else max_jumps_base):
		velocity.y = JUMP_VELOCITY
		JumpCount += 1
	

	# Get the input direction an= trued handle the movement/deceleration.
	# As good practice, you should= true replace UI actions with custom gameplay actions.
	# Get the input direction: -1, 0, 1
	var direction := Input.get_axis("move_left", "move_right")
	
	#Flip the sprite
	if direction >0:
		animated_sprite_2d.flip_h = false
	elif direction <0:
		animated_sprite_2d.flip_h = true
		
	# Play animations
	if not is_attacking:
		if is_on_floor():
			if direction == 0:
				animated_sprite_2d.play("idle")
			else:
				animated_sprite_2d.play("run")
		else:
			animated_sprite_2d.play("jump")
		
		
	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	#Attack
	if Input.is_action_just_pressed("attack") and not is_attacking:
		is_attacking = true
		attack_timer = 0.4
		animated_sprite_2d.play("attack")
		$"Attackhitbox/CollisionShape2D".disabled = false
		 # ENABLE HITBOX immediately
		await get_tree().create_timer(1).timeout
		$"Attackhitbox/CollisionShape2D".disabled = true
		
		
	
	move_and_slide()
 

func enable_double_jump():
	has_double_jump = true
	


func _on_animated_sprite_2d_animation_finished():
	if animated_sprite_2d.animation == "attack":
		$"Attackhitbox/CollisionShape2D".disabled = true
		is_attacking = false


func _on_attackhitbox_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
