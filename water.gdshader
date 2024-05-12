shader_type spatial;
render_mode unshaded;

uniform vec4 water_color: source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float alpha = UV.y-0.4;
	ALBEDO = water_color.rgb;
	ALPHA = alpha;
}

void light() {
	// Called for every pixel for every light affecting the material.
}
