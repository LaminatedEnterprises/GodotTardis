shader_type spatial;
render_mode unshaded, shadows_disabled, cull_disabled;

uniform sampler2D camera_tex;

void fragment() {
	ALBEDO = pow(texture(camera_tex, SCREEN_UV).rgb, vec3(2.2));//texture(camera, SCREEN_UV).rgb;
}
