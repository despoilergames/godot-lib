class_name InputComponentAction extends Resource

signal pressed
signal tapped
signal double_tapped
signal held
signal released

@export var name: StringName
@export var action_name: StringName
@export var report_tap: bool = false
@export var report_hold: bool = false

@export var vector_negative_x: StringName
@export var vector_positive_x: StringName
@export var vector_negative_y: StringName
@export var vector_positive_y: StringName
@export var vector_deadzone: float = -1.0

var is_pressed: bool = false:
	set = set_is_pressed

var pressed_time: float = 0
var held_time: float = 0


func _init(_name: StringName = &"", _action_name: StringName = &"") -> void:
	if _name:
		name = _name
	if _action_name:
		action_name = _action_name


func get_id() -> StringName:
	return name if name else action_name


func get_is_pressed() -> bool:
	return is_pressed


func get_vector(deadzone: float = -1.0) -> Vector2:
	if vector_negative_x and vector_positive_x and vector_negative_y and vector_positive_y:
		return Input.get_vector(vector_negative_x, vector_positive_x, vector_negative_y, vector_positive_y, deadzone if deadzone else vector_deadzone)
	return Vector2.ZERO


func parse_event(event: InputEvent) -> void:
	if not action_name or not event.is_action(action_name):
		return
	is_pressed = event.is_pressed()


func event_is_action(event: InputEvent) -> bool:
	if not action_name:
		return false
	return event.is_action(action_name)


func process(_delta: float) -> void:
	pass


func set_is_pressed(value: bool) -> void:
	if value == is_pressed:
		return
	
	is_pressed = value
	if is_pressed:
		pressed.emit()
	else:
		released.emit()
