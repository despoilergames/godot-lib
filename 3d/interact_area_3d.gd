class_name InteractArea3D extends Area3D

signal focused
signal focus_lost
signal interacted
signal interact_lost
signal completed
signal tapped
signal cancelled
signal reset
signal progress_percent_changed(percentage)

@export var label: StringName
@export var hold_label: StringName
@export var tap_label: StringName
@export var complete_time: float
@export var decay_rate: float
@export var reset_on_unfocused: bool = true
@export var reset_on_interact: bool = false
@export var reset_on_uninteract: bool = false
@export var reset_on_complete: bool = false
@export var tappable: bool = false


var _is_focused: bool = false:
	set(value):
		var _old = _is_focused
		_is_focused = value
		if value != _old:
			if _is_focused:
				focused.emit()
			else:
				focus_lost.emit()
#				_is_interacting = false
				if reset_on_unfocused:
					_is_completed = false
					_is_interacting = false
					_progress_time = 0
var _is_interacting: bool = false:
	set(value):
		var _old = _is_interacting
		_is_interacting = value
		if value != _old:
			if _is_interacting:
				interacted.emit()
			else:
				interact_lost.emit()
				if not _is_completed and tappable and _progress_time <= 0.15:
					tapped.emit()
				if reset_on_uninteract:
					_is_completed = false
					_progress_time = 0
var _is_completed: bool = false:
	set(value):
		var _old = _is_completed
		_is_completed = value
		if value != _old:
			if _is_completed:
				completed.emit()
				if reset_on_complete:
					_progress_time = 0
					_is_interacting = false
					_is_completed = false
			else:
				cancelled.emit()
var _progress_time: float = 0:
	set(value):
		var _old = _progress_time
		_progress_time = clamp(value, 0, complete_time)
		if _progress_time != _old:
			progress_percent_changed.emit(percent_complete)
			if _progress_time == 0:
				reset.emit()
var percent_complete: float = 0:
	get:
		if complete_time:
			return _progress_time / complete_time
		return 0.0
var focused_by


func _physics_process(delta: float) -> void:
	if _is_interacting and complete_time and not _is_completed:
		_progress_time += delta
		if _progress_time >= complete_time:
			_is_completed = true
	elif not _is_interacting and decay_rate and not _is_completed:
		_progress_time -= delta * complete_time * decay_rate


#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_released("interact"):
#		if _is_focused and tappable and complete_time and _progress_time < 0.15 and not _is_completed:
#			tapped.emit()
		#_is_interacting = false
		#_is_completed = false


func focus(_focused_by = null) -> void:
	_is_focused = true
	focused_by = _focused_by


func remove_focus() -> void:
	_is_focused = false
	focused_by = null


func interact() -> void:
	if not _is_interacting and reset_on_interact:
		_progress_time = 0
	_is_interacting = true
	if not complete_time:
		_is_completed = true


func remove_interact() -> void:
	_is_interacting = false
