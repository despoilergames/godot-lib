class_name AvoidArea2D extends Area2D

@export var disabled: bool = false
@export var velocity_component: VelocityComponent

var angle: float = 0

func _physics_process(delta: float) -> void:
	if disabled:
		return
	
	angle = 0
	
	for collider in get_overlapping_areas():
		angle += get_angle_to(collider.global_position)
	
	if angle and velocity_component:
		var vector := Vector2.LEFT.rotated(angle).normalized()
		velocity_component.move_vector += Vector3(vector.x, 0, vector.y)


func enable() -> void:
	disabled = false
	
	for child in get_children():
		if child is CollisionShape2D:
			child.disabled = false


func disable() -> void:
	disabled = true
	
	for child in get_children():
		if child is CollisionShape2D:
			child.disabled = true
