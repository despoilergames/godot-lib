class_name FirstPersonComponent extends Node

const LOOK_LIMIT: float = deg_to_rad(85)

enum Stance { STAND, JUMP, FALL, CROUCH, PRONE, VAULT }
enum MoveState { RUN, WALK, SPRINT }

signal stance_changed(new_stance, old_stance)
signal move_state_changed(new_move_state, old_move_state)
signal proned
signal crouched
signal stood
signal jumped
signal falling(duration: float)
signal landed(duration: float)
signal walked
signal ran
signal sprinted

@export var character: CharacterBody3D
@export var head: Node3D
@export var velocity_component: Velocity3DComponent
@export var prone_speed_modifier: float = 0.25
@export var crouch_speed_modifier: float = 0.5
@export var walk_speed_modifier: float = 0.5
@export var sprint_speed_modifier: float = 1.5
@export var stance: Stance = Stance.STAND:
	set(value):
		if value == stance:
			return
		stance_changed.emit(value, stance)
		stance = value
@export var move_state: MoveState = MoveState.RUN:
	set(value):
		if value == move_state:
			return
		move_state_changed.emit(value, move_state)
		move_state = value
@export var mouse_look: bool = true
@export var fall_timeout: float = 0.35
@export var look_modifier: float = 1

var previous_stance: Stance
var previous_move_state: MoveState
var _fall_time: float = 0


func _ready() -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"pause"):
		get_tree().quit()
	elif mouse_look and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and event is InputEventMouseMotion:
		look(event.relative * -0.01)


func _physics_process(delta: float) -> void:
	if not character.is_on_floor():
		_fall_time += delta
		if _fall_time >= fall_timeout:
			falling.emit(_fall_time)
	else:
		if _fall_time > fall_timeout:
			landed.emit(_fall_time)
		_fall_time = 0


func stance_up() -> void:
	if is_prone():
		crouch()
	elif is_crouching():
		stand()
	else:
		jump()


func prone() -> void:
	stop_sprint()
	stance = Stance.PRONE
	velocity_component.add_modifier(&"crouch", prone_speed_modifier)
	proned.emit()


func crouch() -> void:
	stop_sprint()
	stance = Stance.CROUCH
	velocity_component.add_modifier(&"crouch", crouch_speed_modifier)
	crouched.emit()


func stand() -> void:
	stance = Stance.STAND
	velocity_component.remove_modifier(&"crouch")
	stood.emit()


func toggle_crouch() -> void:
	if is_standing():
		crouch()
	else:
		stand()


func start_walk() -> void:
	stop_sprint()
	move_state = MoveState.WALK
	velocity_component.add_modifier(&"walk", walk_speed_modifier)
	walked.emit()


func stop_walk() -> void:
	move_state = MoveState.RUN
	velocity_component.remove_modifier(&"walk")
	ran.emit()


func start_sprint() -> void:
	stand()
	previous_move_state = move_state
	move_state = MoveState.SPRINT
	velocity_component.add_modifier(&"sprint", sprint_speed_modifier)
	sprinted.emit()


func stop_sprint() -> void:
	move_state = previous_move_state if previous_move_state else MoveState.RUN
	velocity_component.remove_modifier(&"sprint")


func toggle_sprint() -> void:
	if is_sprinting():
		stop_sprint()
	else:
		start_sprint()


func is_prone() -> bool:
	return stance == Stance.PRONE


func is_crouching() -> bool:
	return stance == Stance.CROUCH


func is_standing() -> bool:
	return stance == Stance.STAND


func is_walking() -> bool:
	return move_state == MoveState.WALK


func is_running() -> bool:
	return move_state == MoveState.RUN


func is_sprinting() -> bool:
	return move_state == MoveState.SPRINT


func jump() -> void:
	if not character.is_on_floor():
		return
	velocity_component.jump()
	jumped.emit()


func look(vector: Vector2) -> void:
	vector *= look_modifier
	character.rotate_y(vector.x)
	head.rotate_x(vector.y)
	apply_look_limit()


func apply_look_limit() -> void:
	head.rotation.x = clampf(head.rotation.x, -LOOK_LIMIT, LOOK_LIMIT)
