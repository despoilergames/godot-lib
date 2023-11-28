class_name ChaseCamera2D extends Camera2D

@export var parent: Node2D
@export var use_parent_global_position: bool = false
@export var use_global_position: bool = false
@export var targets: Array[Node2D]
@export var weight: float = 0.5
@export var use_mouse_position: bool = false
@export var max_distance: float = 0
@export var calculate_zoom: bool = false
@export var use_first_target_as_parent: bool = false

@onready var base_zoom: Vector2 = zoom

func _ready() -> void:
	if not parent and get_parent() is Node2D:
		parent = get_parent()


func _physics_process(_delta: float) -> void:
	if not parent and targets.is_empty():
		return
	
	var new_position: Vector2 = Vector2.ZERO
	var offset_position: Vector2 = Vector2.ZERO
	var _weight: float = weight
	var _using_first_position: bool = false
	
	if parent:
		if use_parent_global_position:
			new_position = parent.global_position
		else:
			new_position = parent.position
	elif use_first_target_as_parent and targets.size() > 0:
		new_position = targets.front().global_position
		_using_first_position = true
	
	if use_mouse_position:
		offset_position += get_local_mouse_position() * weight
	elif not parent and targets.size() == 1:
		_weight = 1.0
	
	var i: int = 0
	for target in targets:
		if not is_instance_valid(target):
			continue
		if i == 0 and _using_first_position:
			continue
		var _offset: Vector2 = target.global_position if use_global_position else target.position
		if parent:
			_offset *= _weight
		offset_position += _offset
		i += 1
	
#	if not parent:
#		offset_position /= targets.size()
	
	if max_distance and abs(offset_position.length()) > max_distance:
		offset_position = (Vector2.RIGHT * max_distance).rotated(offset_position.angle())
	
#	if use_global_position:
#		global_position = new_position + offset_position
#	else:
#		position = new_position + offset_position
	
	prints(new_position, offset_position)
	position = new_position + offset_position
	
	if calculate_zoom:
		zoom = base_zoom * remap(targets[0].global_position.distance_to(global_position), 0, 300, 1, 0.75)
		zoom = zoom.clamp(base_zoom * 0.75, base_zoom)


func add_target(node: Node2D) -> void:
	targets.append(node)


func clear_targets() -> void:
	targets.clear()
