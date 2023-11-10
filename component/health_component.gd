class_name HealthComponent extends Node

signal changed(value)
signal depleted

@export var value: float = 100:
	set = set_value
@export var health_component: HealthComponent

@onready var max_value = value


func set_value(amount: float) -> void:
		if amount == value:
			return
		var _value = value
		value = clampf(amount, 0, max_value)
		if _value != value:
			changed.emit(value)
		if value <= 0:
			depleted.emit()


func add(amount) -> void:
	value += amount


func remove(amount: float) -> void:
	var _value = value
	value -= amount
	if value <= 0 and health_component:
		health_component.remove(amount - _value)
