shader_type spatial;
render_mode unshaded;

uniform vec4 light_color: source_color;
uniform vec4 dark_color: source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = mix(light_color.rgb, dark_color.rgb, UV.y);
}

void light() {
	// Called for every pixel for every light affecting the material.
}
