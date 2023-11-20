shader_type canvas_item;

uniform float paletteMix: hint_range(0.0, 1.0)  = 0.0;
uniform sampler2D pal0 : hint_default_black;
uniform sampler2D pal1 : hint_default_black;

uniform float lerper: hint_range(0.0, 1.0);



vec3 c_lerp(vec4 c1, vec4 c2, float pos) {
	pos = clamp (pos, 0.0, 1.0);
	return vec3(c1.x*pos + c2.x*(1.0-pos),c1.y*pos + c2.y*(1.0-pos),c1.z*pos + c2.z*(1.0-pos));
}

void fragment() {
	
	vec3 tex_uv = vec3(UV, 0.0);
	vec3 color_input;
	float alpa_input;
	
	// Get the colors from the image at specified location
	
	vec4 _tex_read = textureLod(TEXTURE, tex_uv.xy, 0.0);
	color_input = _tex_read.rgb;
	alpa_input = _tex_read.a;
	
	// get the greyscale value through the highest of r, g, and b
	
	float grey_value;
	{
		vec3 c = color_input;
		float max1 = max(c.r, c.g);
		float max2 = max(max1, c.b);
		grey_value = max2;
	}
	
	// Read the colormap and use the greyscale value to map in the new colors for each palette.
	
	vec4 colorP0 = textureLod(pal0, vec2(grey_value, 0.0), 0.0);
	
	vec4 colorP1 = textureLod(pal1, vec2(grey_value, 0.0), 0.0);
	
	// Blend between your two color maps and...   Profit.
	vec4 palette = vec4(c_lerp(colorP1, colorP0, lerper), COLOR.w);
	
	COLOR = mix(_tex_read,palette,paletteMix);
}