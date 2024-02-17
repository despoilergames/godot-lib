class_name GunComponent extends Node

enum State { SAFE, EMPTY, READY, TRIGGER_PULLED, CYCLE, SHOOT }
enum Mode { SINGLE, DOUBLE, BURST, FULL_AUTO, SINGLE_ACTION, DOUBLE_ACTION }

signal shot
signal aim_added
signal aim_removed
signal recoiled(vector: Vector3)
signal cycled
signal cycle_started
signal emptied

@export var disabled: bool = true
@export var handle_input: bool = true
#@export var inventory_item: InventoryItem
@export var default_state: State = State.SAFE
@export var rpm: float:
	set(value):
		rpm = value
		if rpm:
			_rpm = clampf(60.0 / rpm, get_physics_process_delta_time(), 10)
		else:
			_rpm = get_physics_process_delta_time()
@export var modes: Array[Mode]:
	set(value):
		modes = value
		if not modes.is_empty() and not mode:
			mode = modes.front()
@export var shoot_action_name: StringName
@export var next_mode_action_name: StringName
@export var recoil_rof_reset_multiplier: float = 2
@export var ammo: int = 0
@export var ammo_cost: int = 1
@export var burst_amount: int = 3

@onready var state: State = default_state

var state_name: StringName:
	get:
		if state:
			return State.keys()[state]
		return ""

var _rpm: float
var is_trigger_pulled: bool = false
var mode: Mode
var mode_name: StringName:
	get:
		return Mode.keys()[mode]

var _shot_count: int = 0
var _shot_timer: float = -1
var _burst_count: int = 0


func _ready() -> void:
	if not _rpm:
		_rpm = get_physics_process_delta_time()


func _process(delta: float) -> void:
	if _shot_count > 0:
		_shot_timer += delta
		if _shot_timer >= rpm * recoil_rof_reset_multiplier:
			_shot_count = 0
			_shot_timer = 0


func _unhandled_input(event: InputEvent) -> void:
	if disabled or not handle_input:
		return
	
	if shoot_action_name and event.is_action(shoot_action_name):
		if event.is_pressed():
			pull_trigger()
		else:
			release_trigger()
		get_viewport().set_input_as_handled()
	elif next_mode_action_name and event.is_action_pressed(next_mode_action_name):
		next_mode()
		get_viewport().set_input_as_handled()


func pull_trigger() -> void:
	if is_trigger_pulled:
		return
	
	is_trigger_pulled = true
	if state == State.READY:
		change_state(State.TRIGGER_PULLED)


func release_trigger() -> void:
	is_trigger_pulled = false


func eject_magazine() -> void:
	prints("eject mag")
	pass


func insert_magazine() -> void:
	prints("insert mag")
	pass


func insert_round() -> void:
	prints("insert round")
	pass


func next_mode() -> void:
	if modes.size() <= 1:
		return
	
	var _index: int = modes.find(mode)
	var _next: int = _index + 1
	if _next >= modes.size():
		_next = 0
	mode = modes[_next]


func prev_mode() -> void:
	if  modes.size() <= 1:
		return
	
	var _index: int = modes.find(mode)
	var _next: int = _index - 1
	if _next < 0:
		_next = modes.size()
	mode = modes[_next]


func change_state(new_state: State) -> void:
	if new_state == state:
		return
	
	var next_state: State
	
	match new_state:
		State.SAFE: pass
		State.EMPTY: pass
		State.READY:
			_burst_count = 0
		State.TRIGGER_PULLED:
			# if no ammo goto empty
			if ammo <= 0:
				next_state = State.READY
			else:
				next_state = State.SHOOT
		State.CYCLE:
			cycle_started.emit()
			await get_tree().create_timer(_rpm).timeout
			cycled.emit()
			# if no ammo goto empty state
			if mode == Mode.BURST and _burst_count < burst_amount and ammo >= ammo_cost:
				next_state = State.SHOOT
			elif is_trigger_pulled and mode == Mode.FULL_AUTO and ammo >= ammo_cost: # check mode
				next_state = State.SHOOT
			else:
				next_state = State.READY
		State.SHOOT:
			if mode == Mode.BURST:
				_burst_count += 1
			ammo -= ammo_cost
			shot.emit()
			if ammo <= 0:
				emptied.emit()
			next_state = State.CYCLE
	
	state = new_state
	
	if next_state:
		change_state(next_state)


func make_ready() -> void:
	change_state(State.READY)


func make_safe() -> void:
	change_state(State.SAFE)


func enable() -> void:
	disabled = false


func disable() -> void:
	disabled = true
