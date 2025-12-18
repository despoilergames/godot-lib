class_name InputComponent extends Node

enum ActionType {
	PRESSED,
	TAPPED,
	DOUBLE_TAPPED,
	HELD,
	RELEASED
}

signal pressed(action_name: StringName)
signal tapped(action_name: StringName)
signal double_tapped(action_name: StringName)
signal held(action_name: StringName)
signal released(action_name: StringName)
signal action_event(action_name: StringName, type: ActionType)
signal actions_registered

@export var disabled: bool = false
@export var device: int = -1
@export var actions: Array[InputComponentAction] = []
@export var disable_accumulation: bool = true
@export var actions: Array[InputComponentAction]

var _actions: Dictionary = {}
var _action_names: PackedStringArray = []
var _timers: Dictionary = {}

func _ready() -> void:
	if disable_accumulation:
		Input.set_use_accumulated_input(false)
	if device >= 0:
		var _actions: Array[InputComponentAction] = []
		for action: InputComponentAction in actions:
			_actions.append(action.duplicate(true))
		actions = _actions

	for action: InputComponentAction in actions:
		action.device = device
		_actions[action.get_id()] = action
		if action.action_name:
			action.pressed.connect(_on_action_pressed.bind(action.action_name))
			action.tapped.connect(_on_action_tapped.bind(action.action_name))
			action.double_tapped.connect(_on_action_double_tapped.bind(action.action_name))
			action.held.connect(_on_action_held.bind(action.action_name))
			action.released.connect(_on_action_released.bind(action.action_name))
	actions_registered.emit()


func _unhandled_input(event: InputEvent) -> void:
	if disabled:
		return
	
	if device >= 0 and event.device != device:
		return
	
	for action: InputComponentAction in actions:
		if not action.event_is_action(event):
			continue
		action.parse_event(event)
		get_viewport().set_input_as_handled()
		return


func _process(delta: float) -> void:
	if disabled or not is_node_ready():
		return
	for action in actions:
		action.process(delta)


func add_action(action: InputComponentAction) -> void:
	actions.append(action)


func get_action(action_name: StringName) -> InputComponentAction:
	if disabled:
		return null
	for action: InputComponentAction in actions:
		if action.get_id() == action_name:
			return action
	return null


func is_pressed(action_name: StringName) -> bool:
	if disabled:
		return false
	var action: InputComponentAction = get_action(action_name)
	if action:
		return action.is_pressed
	return false


func get_vector(action_name: StringName, deadzone: float = -1.0) -> Vector2:
	if disabled:
		return Vector2.ZERO
	var action: InputComponentAction = get_action(action_name)
	if action:
		return action.get_vector(deadzone)
	return Vector2.ZERO


func get_axis(action_name: StringName) -> float:
	if disabled:
		return 0.0
	var action: InputComponentAction = get_action(action_name)
	if action:
		return action.get_axis()
	return 0.0


func _on_action_pressed(action_name: StringName) -> void:
	pressed.emit(action_name)
	action_event.emit(action_name, ActionType.PRESSED)


func _on_action_tapped(action_name: StringName) -> void:
	tapped.emit(action_name)
	action_event.emit(action_name, ActionType.TAPPED)


func _on_action_double_tapped(action_name: StringName) -> void:
	double_tapped.emit(action_name)
	action_event.emit(action_name, ActionType.DOUBLE_TAPPED)


func _on_action_held(action_name: StringName) -> void:
	held.emit(action_name)
	action_event.emit(action_name, ActionType.HELD)


func _on_action_released(action_name: StringName) -> void:
	released.emit(action_name)
	action_event.emit(action_name, ActionType.RELEASED)
