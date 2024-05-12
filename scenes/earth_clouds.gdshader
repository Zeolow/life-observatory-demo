shader_type spatial;
render_mode unshaded, blend_mix;

uniform sampler2D noise_tex;
uniform sampler2D distort_tex;
uniform float cutoff: hint_range(0.0,1.0,0.002);
uniform float dist_fac: hint_range(0.0, 1.0, 0.001);
uniform float pole_fac: hint_range(0.0,2.0,0.002);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 distort = texture(distort_tex, UV).rg;
	float tex = texture(noise_tex, UV+distort*dist_fac).r;
	
	float dp_1 = smoothstep(0.3,1.0, UV.y);
	float dp_2 = smoothstep(0.3,1.0, 1.0 - UV.y);
	float pole_gradient = dp_1 + dp_2; 
	tex *= pole_gradient * pole_fac;
	
	float color = step(cutoff, tex);
	ALBEDO = vec3(color);
	ALPHA_SCISSOR_THRESHOLD = 0.5;
	ALPHA = color * 0.5;
	// Called for every pixel the material is visible on.
}

void light() {
	// Called for every pixel for every light affecting the material.
}
