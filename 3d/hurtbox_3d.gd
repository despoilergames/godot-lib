class_name Hurtbox3D extends Area3D

@export var damage: float
@export var interval: float
@export var damage_on_enter: bool = true

var _timer: Timer
var _areas: Array[Hitbox3D] = []

func _ready() -> void:
	if interval:
		_timer = Timer.new()
		_timer.wait_time = interval
		_timer.timeout.connect(_on_timer_timeout)
		_timer.autostart = false
		add_child(_timer)
	
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)


func _on_timer_timeout() -> void:
	for area in _areas:
		area.apply_damage(damage)
	
	if _timer and _areas.is_empty():
		_timer.stop()


func _on_area_entered(area: Area3D) -> void:
	if area is Hitbox3D:
		_areas.append(area)
		
		if damage_on_enter:
			area.apply_damage(damage)
		
		if _timer and _timer.is_stopped():
				_timer.start()


func _on_area_exited(area: Area3D) -> void:
	if area is Hitbox3D:
		_areas.erase(area)
		if _areas.is_empty() and _timer:
			_timer.stop()
