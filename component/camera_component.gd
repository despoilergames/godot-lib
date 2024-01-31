class_name CameraComponent extends Node

enum ShakeIntensity { EXTRA_SMALL, SMALL, MEDIUM, LARGE, EXTRA_LARGE }

@export var camera_2d: Camera2D
@export var camera_3d: Camera3D
@export var shake_max: float = 1
@export var shake_reduction: float = 0.1

var _stress: float = 0
var _constant: float = 0

func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	if _constant:
		_shake()
		return
	
	if _stress <= 0:
		return
	
	_shake()
	
	_stress -= shake_reduction * delta


func shake(intensity: ShakeIntensity) -> void:
	shake_percentage(get_shake_amount(intensity))


func shake_extra_small() -> void:
	shake_percentage(get_shake_amount(ShakeIntensity.EXTRA_SMALL))


func shake_small() -> void:
	shake_percentage(get_shake_amount(ShakeIntensity.SMALL))


func shake_medium() -> void:
	shake_percentage(get_shake_amount(ShakeIntensity.MEDIUM))


func shake_large() -> void:
	shake_percentage(get_shake_amount(ShakeIntensity.LARGE))


func shake_extra_large() -> void:
	shake_percentage(get_shake_amount(ShakeIntensity.EXTRA_LARGE))


func shake_percentage(amount: float) -> void:
	amount = shake_max * clampf(amount, 0, 1)
	if amount > _stress:
		_stress = amount


func start_shake(intensity: ShakeIntensity) -> void:
	start_shake_percentage(get_shake_amount(intensity))


func start_shake_extra_small() -> void:
	shake_percentage(get_shake_amount(ShakeIntensity.EXTRA_SMALL))


func start_shake_small() -> void:
	start_shake_percentage(get_shake_amount(ShakeIntensity.SMALL))


func start_shake_medium() -> void:
	start_shake_percentage(get_shake_amount(ShakeIntensity.MEDIUM))


func start_shake_large() -> void:
	start_shake_percentage(get_shake_amount(ShakeIntensity.LARGE))


func start_shake_extra_large() -> void:
	start_shake_percentage(get_shake_amount(ShakeIntensity.EXTRA_LARGE))


func start_shake_percentage(amount: float) -> void:
	amount = shake_max * clampf(amount, 0, 1)
	if amount > _stress:
		_stress = amount


func stop_shake() -> void:
	_stress = 0


func _shake() -> void:
	_shake_2d()
	_shake_3d()


func _shake_2d() -> void:
	if not camera_2d:
		return


func _shake_3d() -> void:
	if not camera_3d:
		return
	
	var _amount = _constant if _constant else _stress
	camera_3d.h_offset = randf_range(-_amount, _amount)
	camera_3d.v_offset = randf_range(-_amount, _amount)


func get_shake_amount(intensity: ShakeIntensity) -> float:
	var _spread = 1.0 / 6
	match intensity:
		ShakeIntensity.EXTRA_SMALL: return _spread
		ShakeIntensity.SMALL: return (_spread*2)
		ShakeIntensity.MEDIUM: return (_spread*3)
		ShakeIntensity.LARGE: return (_spread*4)
		ShakeIntensity.EXTRA_LARGE: return (_spread*5)
		_: return 0
