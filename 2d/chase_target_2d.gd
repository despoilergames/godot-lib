class_name ChaseTarget2D extends Node

@export var target: Node2D
@export var character: CharacterBody2D
@export var velocity_component: Velocity2DComponent
@export var apply_direction: bool

var direction: Vector2:
	set(value):
		if value == direction:
			return
		direction = value
		if apply_direction:
			velocity_component.set_move_vector_2d(direction)


func _physics_process(delta: float) -> void:
	if target and character:
		direction = character.global_position.direction_to(target.global_position)
