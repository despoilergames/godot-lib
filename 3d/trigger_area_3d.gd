class_name TriggerArea3D extends Area3D

signal triggered
signal reset
signal resetting

@export var one_shot: bool = false
@export var reset_on_trigger: bool = true
@export var duration: float = 0
@export var reset_rate: float = 0
@export var reset_delay: float = 0
@export var min_bodies: int = 1

var body_count: int = 0:
	set(value):
		if value == body_count:
			return
		
		body_count = value
		
		if one_shot and has_triggered:
			return
		
		if body_count >= min_bodies:
			if not duration:
				_trigger()
				return
			is_resetting = false
			reset_timer.stop()
		else:
			if reset_rate:
				if reset_delay:
					reset_timer.stop()
					reset_timer.start()
				else:
					is_resetting = true
			else:
				_time = 0

var reset_timer: Timer = Timer.new()
var has_triggered: bool = false
var is_resetting: bool = false
var _time: float = 0:
	set(value):
		if value == _time:
			return
		_time = clampf(value, 0, duration)
		if _time >= duration:
			_trigger()
		elif _time <= 0:
			is_resetting = false

var percent_complete: float:
	get:
		if has_triggered:
			return 1
		return remap(_time, 0, duration, 0, 1)


func _ready() -> void:
	if reset_rate and reset_delay:
		reset_timer.one_shot = true
		reset_timer.autostart = false
		reset_timer.wait_time = reset_delay
		reset_timer.timeout.connect(_on_reset_timer_timeout)
		add_child(reset_timer)
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)


func _process(delta: float) -> void:
	_process_time(delta)


func _process_time(delta: float) -> void:
	if one_shot and has_triggered:
		return
	
	if is_resetting:
		_time -= delta * reset_rate
	elif body_count >= min_bodies:
		_time = minf(_time + delta, duration)


func _trigger() -> void:
	triggered.emit()
	
	if reset_on_trigger:
		_time = 0
	
	if one_shot:
		has_triggered = true


func _on_body_entered(_body: Node3D) -> void:
	body_count += 1


func _on_body_exited(_body: Node3D) -> void:
	body_count -= 1


func _on_area_entered(_area: Area3D) -> void:
	body_count += 1


func _on_area_exited(_area: Area3D) -> void:
	body_count -= 1


func _on_reset_timer_timeout() -> void:
	is_resetting = true
