@tool
class_name Primitive2D extends Node2D

@export_range(1, 4, 1) var point_count: int = 1:
	set(value):
		point_count = value
		queue_redraw()
@export var size: float:
	set(value):
		size = value
		queue_redraw()
@export var rect_size: Vector2 = Vector2.ONE:
	set(value):
		rect_size = value
		queue_redraw()
@export var points: PackedVector2Array:
	set(value):
		points = value
		queue_redraw()
@export var colors: PackedColorArray:
	set(value):
		colors = value
		queue_redraw()
@export var uvs: PackedVector2Array:
	set(value):
		uvs = value
		queue_redraw()
@export var texture: Texture2D:
	set(value):
		texture = value
		queue_redraw()


func _draw() -> void:
	var _points: PackedVector2Array = points.duplicate()
	
	if _points.is_empty() and size > 0:
		match point_count:
			1:
				_points.append(Vector2.ZERO)
			
			2:
				_points.append(Vector2.LEFT * size / 2)
				_points.append(Vector2.RIGHT * size / 2)
			
			3:
				_points.append(Vector2.UP * size)
				_points.append(Vector2.UP.rotated(TAU/3) * size)
				_points.append(Vector2.UP.rotated((TAU/3)*2) * size)
			
			4:
				_points.append(Vector2(1, 1) * rect_size * size / 2)
				_points.append(Vector2(-1, 1) * rect_size * size / 2)
				_points.append(Vector2(-1, -1) * rect_size * size / 2)
				_points.append(Vector2(1, -1) * rect_size * size / 2)
	
	draw_primitive(_points, colors, uvs, texture)
