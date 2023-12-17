class_name DebugPropertiesList extends VBoxContainer

enum ProcessType { IDLE, PHYSICS }

@export var target: Node
@export var follow_2d: Node2D
@export var follow_3d: Node3D
@export var properties: PackedStringArray
@export var process_type: ProcessType = ProcessType.IDLE
@export var font_size: int = 0

var _property_labels: Dictionary = {}

func _ready() -> void:
	if not target:
		target = get_parent()
	
	_render()


func _process(_delta: float) -> void:
	if process_type == ProcessType.IDLE:
		_render()


func _physics_process(_delta: float) -> void:
	if process_type == ProcessType.PHYSICS:
		_render()


func _render() -> void:
	if not target or not visible:
		return
	
	if follow_2d:
		global_position = follow_2d.global_position
	
	for property in properties:
		var property_label = property
		var type = "string"
		if property.contains(":"):
			var parts = property.split(":", true, 2)
			property_label = parts[0]
			property = parts[1]
			if parts.size() == 3:
				type = parts[2]
		var property_value = _get_deep(target, property)
		if property_value != null:
			match type:
				"int": property_value = "%d" % int(property_value)
		var text_value = "%s: %s" % [property_label, property_value]
		if _property_labels.has(property):
			_property_labels.get(property).text = text_value
		else:
			var label = Label.new()
			label.text = text_value
			if font_size:
				label.set("theme_override_font_sizes/font_size", font_size)
			add_child(label)
			_property_labels[property] = label


func _get_property_value(key: String) -> Variant:
	if target:
		_get_deep(target, key)
	return null


func _get_deep(element, key: String) -> Variant:
	if key.contains("."):
		var keys = key.split(".", true, 1)
		var child = element.get(keys[0])
		if child:
			return _get_deep(child, keys[1])
		else:
			return child
	else:
		return element.get(key)
