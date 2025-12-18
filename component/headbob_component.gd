class_name HeadbobComponent extends Node

signal stepped

@export var character: CharacterBody3D
@export var head: Node3D
@export var velocity_component: Velocity3DComponent
@export var first_person_component: FirstPersonComponent
@export var head_height: float = 1.6
@export var crouch_height: float = 0.85
@export var prone_height: float = 0.25
@export var speed: float = 5
@export var x_intensity: float = 0.125
@export var y_intensity: float = 0.0625
@export var modifier: float = 1
@export var apply_position: bool = true
@export var apply_rotation: bool = true

@onready var _head_height: float = head_height

var walk_time: float = 0
var position: Vector3 = Vector3.ZERO
var rotation: Vector3 = Vector3.ZERO
var additional_position: Vector3 = Vector3.ZERO

var tween: Tween

func _ready() -> void:
	if first_person_component:
		first_person_component.jumped.connect(_on_jumped)
		first_person_component.landed.connect(_on_landed)


func _physics_process(delta: float) -> void:
	if not character or not velocity_component:
		return

	if not character.is_on_floor():
		return

	walk_time += delta * speed

	position.x = sin(walk_time) * velocity_component.get_speed_percentage() * x_intensity * modifier
	position.y = _head_height - (sin(walk_time * 2)) * velocity_component.get_speed_percentage() * y_intensity * modifier

	position += additional_position

	_apply_position()
	_apply_rotation()

	_head_height = lerpf(_head_height, get_head_height(), delta * 10)


func _apply_position():
	if not head or not apply_position:
		return
	head.position = position


func _apply_rotation():
	if not head or not apply_rotation:
		return
	head.rotation = rotation


func get_head_height() -> float:
	if not first_person_component:
		return head_height

	match first_person_component.stance:
		FirstPersonComponent.Stance.PRONE: return prone_height
		FirstPersonComponent.Stance.CROUCH: return crouch_height
		_: return head_height


func _on_jumped() -> void:
	prints("jumped")
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "rotation:x", -0.25, 0.1)
	tween.chain().tween_property(self, "rotation:x", 0.0, 0.1)
	tween.tween_property(self, "additional_position:y", -0.35, 0.1)
	tween.chain().tween_property(self, "additional_position:y", 0.0, 0.2)
	tween.play()


func _on_landed(duration: float) -> void:
	prints("landed", duration, -0.35 * duration)
	if tween:
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "rotation:x", -0.025, 0.1)
	tween.chain().tween_property(self, "rotation:x", 0.0, 0.1)
	tween.tween_property(self, "additional_position:y", -1.0 * duration, 0.1)
	tween.chain().tween_property(self, "additional_position:y", 0.0, 0.35)
	tween.play()
