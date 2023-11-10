class_name Hitbox2D extends Area2D

@export var health_component: HealthComponent


func apply_damage(amount: float) -> void:
	if not health_component:
		return
	
	health_component.remove(amount)
