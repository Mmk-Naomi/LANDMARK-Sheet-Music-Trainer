shader_type canvas_item;

uniform float size: hint_range(1.0, 2.0) = 1.0;

uniform vec2 center = vec2(0.5);

uniform vec3 color: source_color;

void vertex() {
	//// Called for every vertex the material is visible on.
	//UV += center;
	////mat3 scale_matrix = mat3(vec3(scale,0,0), vec3(0,scale,0), vec3(0,0,scale));
	////vec3 result = scale_matrix * vec3(UV, 1.0);
	//UV *= scale;
	//UV -= vec2(0.5);
	////UV = result.xy;
	//UV -= center;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
