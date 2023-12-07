shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
void fragment() {
	vec4 pixelColor = texture(SCREEN_TEXTURE, SCREEN_UV);
	float brightness = (pixelColor.r + pixelColor.g + pixelColor.b) / 3.0;
	vec4 grayscale = vec4(brightness, brightness, brightness, pixelColor.a);
	COLOR = grayscale;
}
