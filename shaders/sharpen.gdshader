shader_type canvas_item;

uniform float intensity : hint_range(0.0, 2.0) = 1;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

void fragment() {
	vec2 uv = SCREEN_UV;
	vec2 ss = SCREEN_PIXEL_SIZE;
	float dx = intensity * ss.x;
	float dy = intensity * ss.y;
	vec4 sum = vec4(0.0);
	
	sum += -1.0 * texture(SCREEN_TEXTURE, uv + vec2( -1.0 * dx , 0.0 * dy));
	sum += -1.0 * texture(SCREEN_TEXTURE, uv + vec2( 0.0 * dx , -1.0 * dy));
	sum += 5.0 * texture(SCREEN_TEXTURE, uv + vec2( 0.0 * dx , 0.0 * dy));
	sum += -1.0 * texture(SCREEN_TEXTURE, uv + vec2( 0.0 * dx , 1.0 * dy));
	sum += -1.0 * texture(SCREEN_TEXTURE, uv + vec2( 1.0 * dx , 0.0 * dy));
	
	COLOR = sum;
}
