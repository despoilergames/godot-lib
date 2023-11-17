class_name ChaseCamera2D extends Camera2D

@export var parent: Node2D
@export var use_global_position: bool = false
@export var targets: Array[Node2D]
@export var weight: float = 0.5
@export var use_mouse_position: bool = false
@export var max_distance: float = 0
@export var calculate_zoom: bool = false

@onready var base_zoom: Vector2 = zoom

func _ready() -> void:
	if not parent and get_parent() is Node2D:
		parent = get_parent()


func _physics_process(delta: float) -> void:
	var new_position: Vector2 = parent.global_position if parent and use_global_position else Vector2.ZERO
	var offset_position: Vector2
	
	if use_mouse_position:
		offset_position += get_local_mouse_position() * weight
	
	for target in targets:
		if not is_instance_valid(target):
			continue
		var _offset: Vector2 = target.global_position
		if not use_global_position:
			_offset = to_local(offset)
		if parent:
			_offset *= weight
		offset_position += _offset
	
	if not parent:
		offset_position /= targets.size()
	
	if max_distance and abs(offset_position.length()) > max_distance:
		offset_position = (Vector2.RIGHT * max_distance).rotated(offset_position.angle())
	
	position = new_position + offset_position
	
	if calculate_zoom:
		zoom = base_zoom * remap(targets[0].global_position.distance_to(global_position), 0, 300, 1, 0.75)
		zoom = zoom.clamp(base_zoom * 0.75, base_zoom)
