class_name Hitbox2D extends Area2D

@export var health_pip_component: HealthPipComponent
@export var health_pool_component: HealthPoolComponent


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
