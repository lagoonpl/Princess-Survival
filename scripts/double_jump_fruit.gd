extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer



func _on_body_entered(body: Node2D) -> void:
	animation_player.play("new_animation")
	if body.has_method("enable_double_jump"):
		body.enable_double_jump()
	
		
