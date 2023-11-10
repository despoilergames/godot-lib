class_name Hitbox3D extends Area3D

@export var health_component: HealthComponent


func apply_damage(amount: float) -> void:
	if not health_component:
		return
	
	health_component.remove(amount)
