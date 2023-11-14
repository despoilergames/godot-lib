class_name NodeSpawner2D extends Marker2D

@export var scene: PackedScene
@export var spawn_on_ready: bool = false
@export var amount: int = 1
@export var delay: float
@export var interval: float


@onready var timer := Timer.new()


func _ready() -> void:
	timer.autostart = false
	timer.one_shot = false
	timer.timeout.connect(spawn)
	add_child(timer)
	
	if spawn_on_ready:
		spawn()
	
	if interval:
		timer.wait_time = interval
		start()


func spawn() -> void:
	for i in amount:
		_spawn()
		if delay:
			await get_tree().create_timer(delay).timeout


func _spawn() -> void:
	var node = scene.instantiate()
	node.position = global_position
	get_tree().get_current_scene().add_child.call_deferred(node)


func start() -> void:
	timer.start()


func stop() -> void:
	timer.stop()
