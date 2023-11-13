class_name ChaseCamera2D extends Camera2D

@export var targets: Array[Node2D]
@export var weight: float = 0.5
@export var use_mouse_position: bool = false
@export var max_distance: float = 0

var _parent: Node2D

func _ready() -> void:
	_parent = get_parent()


func _physics_process(delta: float) -> void:
	var new_position := Vector2.ZERO
	
	if use_mouse_position:
		new_position += get_local_mouse_position()
	
	for target in targets:
		if not is_instance_valid(target):
			continue
		new_position += to_local(target.global_position)
	
	new_position *= weight
	
	if max_distance and abs(new_position.length()) > max_distance:
		new_position = (Vector2.RIGHT * max_distance).rotated(new_position.angle())
	
	position = new_position
