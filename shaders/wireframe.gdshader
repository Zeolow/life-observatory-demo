shader_type spatial;
render_mode unshaded, wireframe, cull_disabled;

uniform vec3 color: source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = color;
}

void light() {
	// Called for every pixel for every light affecting the material.
}
