class_name Velocity2DComponent extends VelocityComponent

@export var character: CharacterBody2D

func _physics_process(delta: float) -> void:
	super(delta)
	
	if not character:
		return
	
	var _momentum: float = get_momentum()
#	if _momentum >= 1:
#		character.velocity = Vector2(move_vector.x, move_vector.z) * _current_speed
#	else:
	character.velocity = lerp(character.velocity, Vector2(move_vector.x, move_vector.z) * _current_speed, minf(1, delta * _momentum))
	
	if apply_move:
		character.move_and_slide()


func get_speed_percentage() -> float:
	return character.velocity.length_squared() / (speed * speed)
