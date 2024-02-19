class_name FollowTargets2D extends Node

@export var disabled: bool = false
@export var parent: Node2D
@export var primary_target: Node2D
@export var secondary_target: Node2D
@export_range(0, 1, 0.01) var follow_distance: float = 0.5
@export var min_distance: float = 0
@export var max_distance: float = 0
@export var apply_position_to_parent: bool = true

var position: Vector2:
	set(value):
		position = value
		if parent and apply_position_to_parent:
			parent.global_position = position

func _ready() -> void:
	if not parent and get_parent() is Node2D:
		parent = get_parent()


func _process(delta: float) -> void:
	_follow(delta)


func _follow(delta: float) -> void:
	if disabled or not parent or not primary_target:
		return
	
	var target: Vector2 = Vector2()
	if secondary_target:
		target = primary_target.to_local(secondary_target.global_position) * follow_distance
	var distance: float = target.length()
	
	if max_distance and distance > max_distance:
		target = target.normalized() * max_distance
	elif min_distance and distance < min_distance:
		target = target.normalized() * min_distance
	
	position = primary_target.to_global(target)
