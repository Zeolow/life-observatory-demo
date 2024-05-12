shader_type spatial;
render_mode unshaded;

uniform sampler2D height_tex;
uniform sampler2D color_gradient;
uniform vec4 color_1: source_color;
uniform vec4 color_2: source_color;
uniform float cutoff: hint_range(0.0,1.0,0.00001);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float tex = texture(height_tex, UV).r;
	tex = step(cutoff, tex);
	vec3 color = mix(color_1.rgb, color_2.rgb, tex);
	ALBEDO = color;
	// Called for every pixel the material is visible on.
}

void light() {
	// Called for every pixel for every light affecting the material.
}
