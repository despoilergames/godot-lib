class_name PipComponent extends Node

signal changed(value)
signal depleted

@export var value: int = 10:
	set = set_value
@export var regen_interval: float = 0
@export var regen_rate: float = 1
@export var regen_delay: float = 2
@export_range(0, 1, 0.01) var max_regen_amount: float = 0.25

@onready var max_value: int = value

var regen_timer: Timer
var regen_delay_timer: Timer


func _ready() -> void:
	if regen_interval:
		regen_timer = Timer.new()
		regen_timer.wait_time = regen_interval
		regen_timer.autostart = false
		regen_timer.one_shot = false
		regen_timer.timeout.connect(regen_tick)
		add_child(regen_timer)
		
		if regen_delay:
			regen_delay_timer = Timer.new()
			regen_delay_timer.wait_time = regen_delay
			regen_delay_timer.autostart = false
			regen_delay_timer.one_shot = true
			regen_delay_timer.timeout.connect(start_regen)
			add_child(regen_delay_timer)


func set_value(amount: int) -> void:
		if amount == value:
			return
		var _value = value
		if max_value:
			value = clampi(amount, 0, max_value)
		else:
			value = amount
		if _value != value:
			changed.emit(value)
		if value <= 0:
			depleted.emit()


func add(amount: int) -> int:
	var _before = value
	value += amount
	return value - _before


func remove(amount: int) -> int:
	var _before = value
	value -= amount
	return value - _before


func start_regen() -> void:
	regen_timer.start()


func interrupt_regen() -> void:
	if not regen_interval:
		return
	
	if regen_delay:
		regen_timer.stop()
		regen_delay_timer.start(0)
	else:
		regen_timer.start(0)


func stop_regen() -> void:
	regen_timer.stop()


func regen_tick() -> void:
	var _max = max_value * max_regen_amount
	
	if value + regen_rate - _max >= 0:
		add(regen_rate)
	else:
		stop_regen()
