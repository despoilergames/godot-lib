class_name ProjectileRayCast3D extends RayCast3D

signal collided(collider: Object, point: Vector3, normal: Vector3)

@export var speed: float = 1
@export_range(0, 1, 0.01) var speed_variation: float = 0
@export var min_speed: float = 0
@export var weight: float = 0
@export var drag: float = 0
@export_range(0, 1, 0.01) var drag_variation: float = 0
@export var apply_gravity: bool = false
@export var max_life: float = 10
@export var max_distance: float = 0
@export var custom_gravity: float = 0
@export var remove_on_collide: bool = true
@export var show_after_physics_frames: int = 0

@onready var gravity = custom_gravity or ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var _speed: float = speed - randf_range(0, speed * speed_variation)
@onready var _drag: float = drag - randf_range(0, drag * drag_variation)

var lifetime: float = 0
var travelled: float = 0
var has_collided: bool = false
var physics_frames: int = 0
var previous_position: Vector3 = Vector3.ZERO
var velocity: Vector3 = Vector3.ZERO

func _ready() -> void:
	if show_after_physics_frames:
		hide()

	velocity = -global_transform.basis.z * _speed


func _physics_process(delta: float) -> void:
	if not is_node_ready():
		return

	if _speed <= min_speed:
		queue_free()
		return

	# var next_position = global_position - global_transform.basis.z * _speed * delta
	var next_position = global_position + velocity * delta

	if apply_gravity and weight:
		next_position.y -= gravity * weight * delta

	target_position = to_local(next_position)

	if next_position.is_equal_approx(global_position):
		prints("error")
		queue_free()

	if is_colliding():
		var collider = get_collider()
		var point = get_collision_point()
		var normal = get_collision_normal()
		collided.emit(collider, point, normal)
		if remove_on_collide:
			has_collided = true
			_speed = 0
			queue_free()
		return
	else:
		look_at(next_position, Vector3.UP)
		previous_position = global_position
		global_position = next_position
		lifetime += delta
		travelled += _speed * delta
		if show_after_physics_frames == 0 or physics_frames == show_after_physics_frames:
			show()
		if show_after_physics_frames and physics_frames < show_after_physics_frames:
			physics_frames += 1

	if lifetime > max_life or (max_distance > 0 and travelled > max_distance):
		queue_free()
		return

	if _drag:
		velocity = (global_position - previous_position) / delta
		# _speed -= _drag * delta
