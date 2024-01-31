class_name DebugPropertiesList extends VBoxContainer

enum ProcessType { IDLE, PHYSICS }

@export var target: Node
@export var follow_2d: Node2D
@export var follow_3d: Node3D
@export var properties: PackedStringArray
@export var process_type: ProcessType = ProcessType.IDLE
@export var font_size: int = 0
@export var text_align: HorizontalAlignment

var _property_labels: Dictionary = {}
var _signal_values: Dictionary = {}

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
		#var property_value = _get_deep(target, property)
		var property_value = _get_property_value(property, type)
		if property_value != null:
			match type:
				"int": property_value = "%d" % int(property_value)
		var text_value = "%s: %s" % [property_label, property_value]
		if property_label == "_":
			text_value = "%s" % property_value
		if _property_labels.has(property):
			_property_labels.get(property).text = text_value
		else:
			var label = Label.new()
			label.text = text_value
			label.horizontal_alignment = text_align
			if font_size:
				label.set("theme_override_font_sizes/font_size", font_size)
			add_child(label)
			_property_labels[property] = label


func _get_property_value(key: String, type: String = "string") -> Variant:
	if not target:
		return null
	
	match type:
		"signal":
			if not target[key].is_connected(_on_target_signal.bind(key)):
				target[key].connect(_on_target_signal.bind(key))
			return _signal_values.get(key)
		_: return _get_deep(target, key)


func _get_deep(element, key: String) -> Variant:
	if key.contains("."):
		var keys = key.split(".", true, 1)
		var child = element.get(keys[0])
		if child:
			return _get_deep(child, keys[1])
		else:
			return child
	else:
		match key:
			'length':
				return element.length()
		match typeof(element):
			TYPE_VECTOR2:
				return element.call(key)
		if element is Object:
			if element.has_method(key):
				return element.call(key)
			return element.get(key)
		return null


func _on_target_signal(value, property) -> void:
	_signal_values[property] = value
