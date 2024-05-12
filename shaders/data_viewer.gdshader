shader_type spatial;
render_mode wireframe;

uniform vec3 color_1: source_color;
uniform vec3 color_2: source_color;


uniform sampler2D influence_tex;
uniform float influence[121];
/*
int calcIndex(vec2 uv, int array_width) {
	uv *= float(array_width);
	int y = int(uv.y);
	int x = int(uv.x);
	int result = y * array_width + x;
	return = result;
}*/

void vertex() {
	//float dist_1 = 1.0 - distance(UV, UV/vec2(5.0));
	//float dist_2 = 1.0 - distance(UV, (UV + vec2(1.0,0.0))/vec2(5.0) );
	//float dist_3 = 1.0 - distance(UV, (UV + vec2(2.0,0.0))/vec2(5.0));
	//float dist_4 = 1.0 - distance(UV, (UV + vec2(1.0,1.0))/vec2(5.0));
	//float dist_5 = 1.0 - distance(UV, (UV + vec2(0.0,1.0))/vec2(5.0));
	
	//dist_1 = smoothstep(0.75, 1.0, dist_1);
	//dist_2 = smoothstep(0.75, 1.0, dist_2);
	//dist_3 = smoothstep(0.75, 1.0, dist_3);
	//dist_4 = smoothstep(0.75, 1.0, dist_4);
	//dist_5 = smoothstep(0.75, 1.0, dist_5);
	float sum = 0.0;
	
	for(int i = 0; i<121; i++) {
		float x = mod(float(i), 11.0);
		float y = floor(float(i)/11.0);
		vec2 distance_point = (vec2(x,y) + vec2(0.5))/vec2(11.0);
		float dist = 1.0 - distance(UV, distance_point);
		dist = smoothstep(0.9, 1.0, dist);
		sum += dist * influence[i];
	};
	
	//float sum = dist_1 * influence[0] + dist_2 * influence[1]+dist_3 * influence[2]+dist_4 * influence[3]+dist_5 * influence[4];
	
	//vec2 uv = UV * 5.0;
	//int y = int(uv.y);
	//int x = int(uv.x);
	//int index = y * 5 + x;
	VERTEX.y += sum;
}

void fragment() {
	
	float tex = texture(influence_tex,UV).r;
	
	float sum = 0.0;
	
	for(int i = 0; i < 121; i++) {
		float x = mod(float(i), 11.0);
		float y = floor(float(i)/11.0);
		float dist = 1.0 - distance(UV, (UV+vec2(x,y))/vec2(11.0));
		dist = smoothstep(0.9, 1.0, dist);
		sum += dist * influence[i];
	};
	
	sum = smoothstep(-2.0,2.0,sum);
	vec3 color = vec3(0.0);
	color = mix(vec3(sum), color_1, color_2);
	
	ALBEDO = vec3(sum)*color_1;
}	



void light() {
	// Called for every pixel for every light affecting the material.
}

