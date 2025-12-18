class_name Hitbox3D extends Area3D

signal hit(point: Vector3, normal: Vector3)
signal damage_applied(amount: float)

@export var health_pip_component: HealthPipComponent
@export var health_pool_component: HealthPoolComponent
@export var max_hit_reports_per_frame: int = 0
@export var rigid_body: RigidBody3D
@export var damage_modifier: float = 1

var _hit_reports: int = 0


func _process(_delta: float) -> void:
	if _hit_reports:
		_hit_reports = 0


func apply_damage(amount: float) -> void:
	amount *= damage_modifier
	if health_pip_component:
		health_pip_component.remove(int(amount))
	if health_pool_component:
		health_pool_component.remove(amount)


func apply_heal(amount: float) -> float:
	if health_pip_component:
		return health_pip_component.add(int(amount))
	if health_pool_component:
		return health_pool_component.add(amount)
	return 0


func enable() -> void:
	for child in get_children():
		if child is CollisionShape3D:
			child.disabled = false


func disable() -> void:
	for child in get_children():
		if child is CollisionShape3D:
			child.set_deferred("disabled", true)


func apply_hit(point: Vector3, normal: Vector3 = Vector3.ZERO) -> void:
	if max_hit_reports_per_frame and _hit_reports >= max_hit_reports_per_frame:
		return
	hit.emit(point, normal)
	_hit_reports += 1
	


func apply_impulse(impulse: Vector3, impulse_position: Vector3 = Vector3.ZERO) -> void:
	if rigid_body:
		rigid_body.apply_impulse(impulse, impulse_position)
