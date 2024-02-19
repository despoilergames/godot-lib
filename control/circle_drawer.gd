@tool
class_name CircleDrawer extends Control

@export var radius: float = 10:
	set(value):
		radius = value
		queue_redraw()
@export var width: float = 1:
	set(value):
		width = value
		queue_redraw()
@export var border_width: float = 0:
	set(value):
		border_width = value
		queue_redraw()
@export_range(0, 1) var length: float = 1:
	set(value):
		length = value
		queue_redraw()
@export var color: Color = Color.WHITE:
	set(value):
		color = value
		queue_redraw()
@export var border_color: Color = Color.BLACK:
	set(value):
		border_color = value
		queue_redraw()
@export var points: int = 30:
	set(value):
		points = value
		queue_redraw()
@export_range(-1, 1) var start_position: float = 0:
	set(value):
		start_position = value
		queue_redraw()
@export var use_background: bool = false:
	set(value):
		use_background = value
		queue_redraw()
@export var background_color: Color = Color.BLACK:
	set(value):
		background_color = value
		queue_redraw()
@export var use_aliasing: bool = true:
	set(value):
		use_aliasing = value
		queue_redraw()
@export var hollow: bool = true:
	set(value):
		hollow = value
		queue_redraw()


func _draw() -> void:
	var _start_angle: float = TAU * start_position
	var _end_angle: float = _start_angle + (TAU * length)
	
	if border_width:
		if hollow:
			draw_arc(Vector2.ZERO, radius, _start_angle, _end_angle, points, border_color, border_width, use_aliasing)
		else:
			draw_circle(Vector2.ZERO, radius + border_width, border_color)
	
	if use_background:
		if hollow:
			draw_arc(Vector2.ZERO, radius, 0, TAU, points, background_color, width, use_aliasing)
		else:
			draw_circle(Vector2.ZERO, radius, background_color)
	
	if hollow:
		draw_arc(Vector2.ZERO, radius, _start_angle, _end_angle, points, color, width, use_aliasing)
	else:
		draw_circle(Vector2.ZERO, radius, color)
