shader_type canvas_item;

uniform vec3 color : source_color;
uniform float amount : hint_range(0, 1.0) = 0;

void fragment() {
	COLOR.rgb = mix(COLOR.rgb, color, amount);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
