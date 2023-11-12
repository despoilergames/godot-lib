class_name ChaseCamera2D extends Camera2D

@export var targets: Array[Node2D]
@export var weight: float = 0.5
@export var use_mouse_position: bool = false

func _physics_process(delta: float) -> void:
	var new_position := Vector2.ZERO
	
	if use_mouse_position:
		new_position += get_local_mouse_position()
	
	for target in targets:
		if not is_instance_valid(target):
			continue
		new_position += to_local(target.global_position)
	
	position = new_position * weight
