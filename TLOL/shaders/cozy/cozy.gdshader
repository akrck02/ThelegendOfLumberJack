shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	vec4 current = texture(SCREEN_TEXTURE, SCREEN_UV ,0);
	COLOR = vec4(current.r ,current.g,current.g,1);
}