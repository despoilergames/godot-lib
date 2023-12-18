shader_type canvas_item;

uniform vec4 transparent_color : source_color;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	if (color == transparent_color) {
		color.a = 0.0;
	}
	COLOR = color;
}
