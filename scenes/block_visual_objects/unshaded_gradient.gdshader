shader_type spatial;
render_mode unshaded;

uniform vec4 color_1: source_color;
uniform vec4 color_2: source_color;


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 color = mix(color_1, color_2, UV.y).rgb;
	ALBEDO = color;
}

void light() {
	// Called for every pixel for every light affecting the material.
}
