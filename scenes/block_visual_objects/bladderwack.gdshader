shader_type spatial;
render_mode unshaded, cull_disabled;


uniform vec4 dark_color: source_color;
uniform vec4 light_color: source_color;

uniform sampler2D gradient_map;
uniform sampler2D shape_tex;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float tex = texture(shape_tex, UV).r;
	vec2 g_sample = clamp(vec2(tex), vec2(0.0), vec2(0.9));
	float gradient = texture(gradient_map, g_sample).r;
	
	
	ALBEDO = mix(dark_color.rgb,light_color.rgb, gradient);
	ALPHA_SCISSOR_THRESHOLD = 0.2;
 	ALPHA = tex;
}
