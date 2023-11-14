class_name Hitbox2D extends Area2D

@export var health_component: HealthComponent


func apply_damage(amount: float) -> void:
	if not health_component:
		return
	
	health_component.remove(amount)


func enable() -> void:
	for child in get_children():
		if child is CollisionShape2D:
			child.disabled = false


func disable() -> void:
	for child in get_children():
		if child is CollisionShape2D:
			child.disabled = true
