class_name NodeSpawner3D extends Marker3D

signal node_spawned(node: Node3D)

@export var disabled: bool = false
@export var scene: PackedScene
@export var spawn_on_ready: bool = false
@export var amount: int = 1
@export var delay: float
@export var start_delay: float
@export var spawn_interval: float
@export var autostart: bool = false
@export var max_runs: int = 0
@export var parent_node: Node
@export var random_offset: Vector3
@export var random_rotation: Vector3
@export var use_current_position: bool = true
@export var use_current_rotation: bool = true
@export var auto_respawn: bool = false
@export var respawn_delay: float = 5

@onready var timer: Timer
@onready var respawn_timer: Timer

var _runs: int = 0
var _nodes: Array[Node3D]

func _ready() -> void:
	if disabled:
		return
	
	if spawn_interval:
		timer = Timer.new()
		timer.autostart = false
		timer.one_shot = false
		timer.timeout.connect(spawn)
		timer.wait_time = spawn_interval
		add_child(timer)
	
	if respawn_delay:
		respawn_timer = Timer.new()
		respawn_timer.autostart = false
		respawn_timer.one_shot = true
		respawn_timer.timeout.connect(spawn)
		respawn_timer.wait_time = respawn_delay
		add_child(respawn_timer)
	
	if start_delay:
		await get_tree().create_timer(start_delay).timeout
	
	if spawn_on_ready:
		spawn()
	
	if spawn_interval and autostart:
		timer.start()


func spawn() -> void:
	for i in amount:
		_spawn(i)
		if delay:
			await get_tree().create_timer(delay).timeout
	
	if max_runs:
		_runs += 1
		
		if _runs > max_runs:
			timer.stop()


func _spawn(_index: int = -1, properties: Dictionary = {}) -> void:
	var node: Node3D = _create()
	for property: StringName in properties.keys():
		node.set(property, properties.get(property))
	
	if parent_node:
		parent_node.add_child.call_deferred(node)
	else:
		get_tree().get_current_scene().add_child.call_deferred(node)
	
	node.tree_exited.connect(_on_node_tree_exited)
	_nodes.append(node)
	
	await get_tree().process_frame
	node_spawned.emit(node)


func _create() -> Node3D:
	var node: Node3D = scene.instantiate()
	if use_current_position:
		node.position = global_position
	if use_current_rotation:
		node.rotation = global_rotation
	if not random_offset.is_zero_approx():
		node.position += Vector3(randf_range(-random_offset.x, random_offset.y), randf_range(-random_offset.y, random_offset.y), randf_range(-random_offset.z, random_offset.z))
	if not random_rotation.is_zero_approx():
		node.rotation_degrees += Vector3(randf_range(-random_rotation.x, random_rotation.y), randf_range(-random_rotation.y, random_rotation.y), randf_range(-random_rotation.z, random_rotation.z))
	return node


func start() -> void:
	timer.start()


func stop() -> void:
	timer.stop()


func _on_node_tree_exited() -> void:
	_nodes.erase(null)
	if respawn_delay:
		respawn_timer.start()
