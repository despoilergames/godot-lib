class_name InteractRayCast3D extends RayCast3D

signal target_gained(new_target: InteractArea3D)
signal target_lost

@export var action_name: StringName

var _target: InteractArea3D


func _ready() -> void:
	if not action_name:
		set_physics_process(false)
		set_process_unhandled_input(false)


func _physics_process(_delta: float) -> void:
	if not action_name or not enabled:
		return
	
	if is_colliding() and get_collider() is InteractArea3D:
		if _target != get_collider():
			_target = get_collider()
			_target.focus(self)
			target_gained.emit(_target)
	elif _target:
		if is_instance_valid(_target):
			_target.remove_focus()
		_target = null
		target_lost.emit()


func _unhandled_input(event: InputEvent) -> void:
	if not action_name or not enabled:
		return
	
	if event.is_action(action_name):
		if is_instance_valid(_target):
			if event.is_pressed():
				_target.interact()
			else:
				_target.remove_interact()
