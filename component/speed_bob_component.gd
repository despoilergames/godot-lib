class_name SpeedBobComponent extends Node

@export var disabled: bool
@export var velocity_component: VelocityComponent
@export var speed: float = 1
@export var position_multiplier: float = 1
@export var position_amplitude: Vector3 = Vector3.ZERO
@export var position_speed: Vector3 = Vector3.ONE
@export var position_curve: Curve
@export var rotation_multiplier: float = 1
@export var rotation_amplitude: Vector3 = Vector3.ZERO
@export var rotation_speed: Vector3 = Vector3.ONE
@export var rotation_curve: Curve
@export var curve: Curve

var position: Vector3
var rotation: Vector3

var _time: float = 0


func _process(delta: float) -> void:
	if not velocity_component:
		set_physics_process(false)
		return
	
	if disabled:
		return
	
	_time += delta * speed
	
	if curve and velocity_component.get_speed_percentage() > 0 and velocity_component.get_speed_percentage() != INF:
		var _amount = curve.sample(velocity_component.get_speed_percentage())
		
		var position_sin = Vector3(
			sin(_time * position_speed.x),
			sin(_time * position_speed.y),
			sin(_time * position_speed.z)
		)
		
		if position_curve:
			position_sin.y = position_curve.sample(position_sin.y)
		
		position = position_amplitude * position_sin * _amount * position_multiplier
		
		var rotation_sin = Vector3(
			sin(_time * rotation_speed.x),
			sin(_time * rotation_speed.y),
			sin(_time * rotation_speed.z)
		)
		
		if rotation_curve:
			rotation_sin.y = rotation_curve.sample(rotation_sin.y)
		
		rotation = rotation_amplitude * rotation_sin * _amount * rotation_multiplier
