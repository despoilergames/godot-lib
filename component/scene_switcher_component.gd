class_name SceneSwitcherComponent extends Node

@export var next_scene: PackedScene
@export var change_on_ready: bool = false
@export var delay: float = 0
@export var scenes: Dictionary = {}


func _ready() -> void:
	if change_on_ready:
		goto_next_scene()


func goto_next_scene() -> void:
	if delay:
		await get_tree().create_timer(delay).timeout
	get_tree().change_scene_to_packed.call_deferred(next_scene)


func goto_file(file: String) -> void:
	if delay:
		await get_tree().create_timer(delay).timeout
	get_tree().change_scene_to_file.call_deferred(file)


func goto_scene(scene_name: StringName) -> void:
	if not scenes.has(scene_name):
		return
	goto_file(scenes[scene_name])
