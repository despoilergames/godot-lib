class_name ProjectileRayCast3D extends RayCast3D

signal collided(collider: Object, point: Vector3, normal: Vector3)

@export var speed: float = 1
@export var weight: float = 0
@export var drag: float = 0
@export var apply_gravity: bool = false
@export var max_life: float = 10
@export var max_distance: float = 0
@export var custom_gravity: float = 0

@onready var gravity = custom_gravity or ProjectSettings.get_setting("physics/3d/default_gravity")

var lifetime: float = 0
var travelled: float = 0
var has_collided: bool = false

func _ready() -> void:
	hide()


func _physics_process(delta: float) -> void:
	if speed <= 0 or has_collided:
		return

	var next_position = global_position - global_transform.basis.z * speed * delta

	if apply_gravity and weight:
		next_position.y -= gravity * weight * delta

	target_position = to_local(next_position)

	if is_colliding():
		var collider = get_collider()
		var point = get_collision_point()
		var normal = get_collision_normal()
		collided.emit(collider, point, normal)
		has_collided = true
		queue_free()
		return
	else:
		look_at(next_position, Vector3.UP)
		global_position = next_position
		lifetime += delta
		travelled += speed * delta
		show()

	if lifetime > max_life or (max_distance > 0 and travelled > max_distance):
		queue_free()
		return

	if drag:
		speed -= drag * delta
