class_name RotateTowards3D extends Node

@export var disabled: bool = false
@export var target: Node3D
@export var speed: float = 1
@export var margin: float = 0
@export var min_distance: float = 0
@export var angle_limit: float = 0.0001
@export var zero_x: bool = false
@export var zero_y: bool = false
@export var zero_z: bool = false

@onready var parent: Node3D = get_parent()


func _physics_process(delta: float) -> void:
	if disabled or not target:
		return

	if margin and target.position.length() < margin:
		return

	if min_distance and parent.global_position.distance_to(target.global_position) < min_distance:
		return

	if is_zero_approx(speed):
		if not parent.global_position.is_equal_approx(target.global_position):
			parent.look_at(target.global_position)
	else:
		var direction_to_target = (target.global_position - parent.global_position).normalized()
		var current_forward = -parent.global_transform.basis.z
		var angle = current_forward.angle_to(direction_to_target)

		if angle > angle_limit:
			var rotation_axis = current_forward.cross(direction_to_target).normalized()
			var step = speed * delta
			var rotation_amount = min(step, angle)
			if not rotation_axis.is_zero_approx():
				parent.rotate(rotation_axis, rotation_amount)

	if zero_x:
		parent.rotation.x = 0
	if zero_y:
		parent.rotation.y = 0
	if zero_z:
		parent.rotation.z = 0
