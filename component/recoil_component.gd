class_name RecoilComponent extends Node

@export var min_duration: float = 0.0
@export var max_duration: float = 0.035
@export var recoil_target_node: Node3D
@export var recoil_x_target_node: Node3D
@export var recoil_y_target_node: Node3D
@export var soft_recoil_target_node: Node3D

var recoil_vector: Vector3:
	set(value):
		var change: Vector3 = value - recoil_vector
		recoil_vector = value
		if value:
			if recoil_target_node:
				recoil_target_node.rotation += change
			if recoil_x_target_node:
				recoil_x_target_node.rotate_x(change.x)
			if recoil_y_target_node:
				recoil_y_target_node.rotate_y(change.y)
var soft_recoil_vector: Vector3:
	set(value):
		soft_recoil_vector = value
		if soft_recoil_target_node:
			soft_recoil_target_node.rotation = soft_recoil_vector

var _recoil_tween: Tween


func add_recoil(vector: Vector3, duration: float = 0.0) -> void:
	duration = clampf(duration, min_duration, max_duration)
	
	recoil_vector = Vector3.ZERO
	
	if is_zero_approx(duration) or is_inf(duration):
		recoil_vector = vector
		recoil_vector = Vector3.ZERO
		return
	
	if _recoil_tween:
		_recoil_tween.kill()
	
	_recoil_tween = create_tween().set_ease(Tween.EASE_OUT).set_process_mode(Tween.TWEEN_PROCESS_PHYSICS).set_parallel(true)
	_recoil_tween.tween_property(self, "recoil_vector", vector, duration)
	_recoil_tween.tween_property(self, "soft_recoil_vector", vector, duration / 2)
	_recoil_tween.tween_property(self, "soft_recoil_vector", Vector3.ZERO, duration / 2).set_delay(duration / 2)
	_recoil_tween.play()
	await _recoil_tween.finished
	recoil_vector = Vector3.ZERO
