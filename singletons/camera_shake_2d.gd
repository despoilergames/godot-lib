extends Node

var current: Camera2D

var max_stress: float = 2
var stress: float = 0:
	set(value):
		stress = clampf(value, 0, max_stress)
var stress_reduction: float = 2
var offset: Vector2
var offset_reset: float = 10
var _offset: Vector2

#func _process(delta: float) -> void:
#	_process_shake(delta)
#	pass


func _physics_process(delta: float) -> void:
	_process_shake(delta)


func _process_shake(delta: float) -> void:
	if current and not current.enabled:
		current = null
	
	if not current:
		current = get_viewport().get_camera_2d()
		return
	
	_offset = _offset.lerp(offset, delta * 10)
	current.offset = _offset
	
	if stress > 0:
		current.offset += Vector2(randf_range(-stress, stress), randf_range(-stress, stress))
	
	stress -= delta * stress_reduction
	offset = offset.lerp(Vector2.ZERO, delta * offset_reset)


func add_stress(amount: float) -> void:
	stress += amount


func set_stress(amount: float) -> void:
	if amount > stress:
		stress = amount


func set_stress_percent(amount: float) -> void:
	set_stress(max_stress * clampf(amount, 0, 1))


func add_offset(vector: Vector2) -> void:
	offset += vector


func set_offset(vector: Vector2) -> void:
	offset = vector
