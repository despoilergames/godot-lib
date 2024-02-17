class_name Velocity3DComponent extends VelocityComponent

signal jumped
signal landed

@export var character: CharacterBody3D
@export var basis_node: Node3D
@export var zero_basis_x_rotation: bool = false
@export var air_control: float = 0
@export var jump_force: float = 10
@export var gravity_scale: float = 1
@export var landed_min_fall_time: float = 0.25

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


var _fall_timer: float = 0:
	set(value):
		if value <= 0 and _fall_timer > landed_min_fall_time:
			landed.emit()
		_fall_timer = value


func _ready() -> void:
	if basis_node == null:
		basis_node = character


func _physics_process(delta: float) -> void:
#	super(delta)
	
	if disabled or not character:
		return
	
	character.velocity.y -= gravity * delta * gravity_scale
	
	if not character.is_on_floor():
		if character.velocity.y < 0:
			_fall_timer += delta
	else:
		_fall_timer = 0
	
	if character.is_on_floor() or not is_zero_approx(air_control):
		var _basis: Basis = basis_node.global_transform.basis
		#if zero_basis_x_rotation:
			#_basis
		var _move_vector: Vector3 = _basis * move_vector
		
		var _momentum: float = (acceleration if move_vector else decceleration) * _acceleration_modifier
		if not character.is_on_floor():
			_momentum *= air_control
		_current_speed = lerp(_current_speed, target_speed(), _momentum)
		
		character.velocity.x = lerp(character.velocity.x, _move_vector.x * _current_speed, _momentum)
		character.velocity.z = lerp(character.velocity.z, _move_vector.z * _current_speed, _momentum)
	
	if apply_move:
		character.move_and_slide()


func get_momentum() -> float:
	var momentum: float = super()
	if not character.is_on_floor():
		momentum *= air_control
	return momentum


func get_speed_percentage() -> float:
	var _vector: Vector3 = Vector3((character.velocity.x), 0, (character.velocity.z))
	var value: float = _vector.length_squared() / (speed * speed)
	return value


func jump() -> void:
	if not character.is_on_floor():
		return
	
	character.velocity.y += jump_force
	jumped.emit()
