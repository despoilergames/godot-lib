class_name NodeSpawner2D extends Marker2D

@export var disabled: bool = false
@export var scene: PackedScene
@export var spawn_on_ready: bool = false
@export var amount: int = 1
@export var delay: float
@export var interval: float
@export var autostart: bool = false

@onready var timer := Timer.new()


func _ready() -> void:
	timer.autostart = false
	timer.one_shot = false
	timer.timeout.connect(spawn)
	timer.wait_time = interval
	add_child(timer)
	
	if disabled:
		return
	
	if spawn_on_ready:
		spawn()
	
	if interval and autostart:
		start()


func spawn() -> void:
	for i in amount:
		_spawn(i)
		if delay:
			await get_tree().create_timer(delay).timeout


func _spawn(index: int = -1, properties: Dictionary = {}) -> void:
	var node = _create()
	for property in properties.keys():
		node.set(property, properties.get(property))
	get_tree().get_current_scene().add_child.call_deferred(node)


func _create() -> Node2D:
	var node = scene.instantiate()
	node.position = global_position
	return node


func start() -> void:
	timer.start()


func stop() -> void:
	timer.stop()
