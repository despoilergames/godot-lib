class_name Hitbox2D extends Area2D

signal hit(point, normal)
signal damage_applied(amount)

@export var health_pip_component: HealthPipComponent
@export var health_pool_component: HealthPoolComponent
@export var max_hit_reports_per_frame: int = 0

var _hit_reports: int = 0


func _process(delta: float) -> void:
	if _hit_reports:
		prints(_hit_reports)
		_hit_reports = 0


func apply_damage(amount: float) -> void:
	if health_pip_component:
		health_pip_component.remove(int(amount))
	if health_pool_component:
		health_pool_component.remove(amount)


func enable() -> void:
	for child in get_children():
		if child is CollisionShape2D:
			child.disabled = false


func disable() -> void:
	for child in get_children():
		if child is CollisionShape2D:
			child.set_deferred("disabled", true)


func apply_hit(point: Vector2, normal: Vector2 = Vector2.ZERO) -> void:
	if max_hit_reports_per_frame and _hit_reports >= max_hit_reports_per_frame:
		return
	hit.emit(point, normal)
	_hit_reports += 1
