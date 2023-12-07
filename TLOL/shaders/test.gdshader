shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;


void fragment() {
	vec4 current = texture(SCREEN_TEXTURE, SCREEN_UV);
	ivec2 pixel_pos = ivec2(UV / SCREEN_PIXEL_SIZE);
	
	float pos_x = float(pixel_pos.x);
	float pos_y = float(pixel_pos.y);
	
	float r = current.r + sin(pos_y + pow(pos_x, 2));
	float g = current.g + sin(pos_x + pow(pos_y,2));
	float b = current.b + tan(pos_y + pos_x); 
	
	COLOR = vec4( r ,g, b,.1);
  
}