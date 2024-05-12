shader_type spatial;
render_mode unshaded, cull_disabled;

uniform sampler2D tex;
uniform vec4 color_1: source_color;
uniform vec4 color_2: source_color;
uniform float alpha_scissor: hint_range(0.0, 1.0, 0.05);
uniform bool bottom_gradient = false;
uniform bool billboard = true;


void vertex() {
	//UV=UV*uv1_scale.xy+uv1_offset.xy;
	if(billboard){
		MODELVIEW_MATRIX = VIEW_MATRIX * mat4(vec4(normalize(cross(vec3(0.0, 1.0, 0.0), INV_VIEW_MATRIX[2].xyz)), 0.0), vec4(0.0, 1.0, 0.0, 0.0), vec4(normalize(cross(INV_VIEW_MATRIX[0].xyz, vec3(0.0, 1.0, 0.0))), 0.0), MODEL_MATRIX[3]);
		MODELVIEW_MATRIX = MODELVIEW_MATRIX * mat4(vec4(length(MODEL_MATRIX[0].xyz), 0.0, 0.0, 0.0),vec4(0.0, length(MODEL_MATRIX[1].xyz), 0.0, 0.0), vec4(0.0, 0.0, length(MODEL_MATRIX[2].xyz), 0.0), vec4(0.0, 0.0, 0.0, 1.0));
		MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
	}
}

void fragment() {
	float shape_tex = texture(tex, UV).r;
	ALPHA = shape_tex;
	
	if(bottom_gradient){
		shape_tex *= 1.0 - UV.y;
	}
	
	vec3 color = mix(color_1.rgb, color_2.rgb, shape_tex);
	
	ALBEDO = vec3(color);
	ALPHA_SCISSOR_THRESHOLD = alpha_scissor;
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
