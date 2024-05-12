shader_type canvas_item;

uniform sampler2D tex;
uniform float progress: hint_range(0.01, 1.0, 0.01);
uniform vec4 color: source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float prog = texture(tex, UV).r;
	prog = step(progress, prog);
	
	COLOR = prog * color;
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
