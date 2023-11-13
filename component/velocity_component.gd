class_name VelocityComponent extends Node

@export var disabled: bool = false:
	set = set_disabled
@export var speed: float
@export var acceleration: float
@export var decceleration: float
@export var apply_move: bool = true

var move_vector: Vector3
var _modifiers = {}
var _modifier: float = 1
var _acceleration_modifiers = {}
var _acceleration_modifier: float = 1
var _current_speed: float = 0


func _physics_process(delta: float) -> void:
#	if not character.is_on_floor():
#		_momentum *= air_control
	_current_speed = lerp(_current_speed, target_speed(), minf(1, delta * get_momentum()))


func get_momentum() -> float:
	return (acceleration if move_vector or is_zero_approx(decceleration) else decceleration) * _acceleration_modifier


func set_disabled(value: bool) -> void:
	if value == disabled:
		return
	disabled = value
	set_physics_process(!disabled)


func get_speed_percentage() -> float:
	return 0


func add_modifier(key: StringName, value: float) -> void:
	_modifiers[key] = value
	_apply_modifiers()


func remove_modifier(key: StringName) -> void:
	_modifiers.erase(key)
	_apply_modifiers()


func add_acceleration_modifier(key: StringName, value: float) -> void:
	_acceleration_modifiers[key] = value
	_apply_acceleration_modifiers()


func remove_acceleration_modifier(key: StringName) -> void:
	_acceleration_modifiers.erase(key)
	_apply_acceleration_modifiers()


func target_speed() -> float:
	var _speed = speed * _modifier
	return _speed if move_vector else 0.0


func _apply_modifiers() -> void:
	if not _modifiers.is_empty():
		_modifier = _modifiers.values().min()
	else:
		_modifier = 1


func _apply_acceleration_modifiers() -> void:
	if not _acceleration_modifiers.is_empty():
		var _values = _acceleration_modifiers.values()
		_values.sort()
		_acceleration_modifier = _values.front()
	else:
		_acceleration_modifier = 1


func set_move_vector_3d(vector: Vector3) -> void:
	move_vector = vector


func set_move_vector_2d(vector: Vector2) -> void:
	move_vector = Vector3(vector.x, 0, vector.y)


func clear_move_vector() -> void:
	move_vector = Vector3.ZERO
