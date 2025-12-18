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
var device: int = -1
var vector: Vector2 = Vector2.ZERO

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
	if deadzone < 0:
		deadzone = vector_deadzone
	if vector.length() >= deadzone:
		return vector
	return Vector2.ZERO


func get_x_axis(deadzone: float = -1.0) -> float:
	if deadzone < 0:
		deadzone = vector_deadzone
	if abs(vector.x) >= deadzone:
		return vector.x
	return 0.0


func get_y_axis(deadzone: float = -1.0) -> float:
	if deadzone < 0:
		deadzone = vector_deadzone
	if abs(vector.y) >= deadzone:
		return vector.y
	return 0.0


func parse_event(event: InputEvent) -> void:
	if not event_is_action(event):
		return
	is_pressed = event.is_pressed()
	if vector_negative_x and event.is_action(vector_negative_x, true):
		vector.x = -event.get_action_strength(vector_negative_x)
	elif vector_positive_x and event.is_action(vector_positive_x, true):
		vector.x = event.get_action_strength(vector_positive_x)
	if vector_negative_y and event.is_action(vector_negative_y, true):
		vector.y = -event.get_action_strength(vector_negative_y)
	elif vector_positive_y and event.is_action(vector_positive_y, true):
		vector.y = event.get_action_strength(vector_positive_y)


func event_is_action(event: InputEvent) -> bool:
	if device != -1 and event.device != device:
		return false
	if action_name:
		return event.is_action(action_name)
	else:
		for action in [vector_negative_x, vector_positive_x, vector_negative_y, vector_positive_y]:
			if action and event.is_action(action, true):
				return true
	return false


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
