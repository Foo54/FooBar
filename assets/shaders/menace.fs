#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
	#define PRECISION highp
#else
	#define PRECISION mediump
#endif

extern PRECISION vec2 menace;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    vec4 pixel_color = Texel(texture, texture_coords);

    vec3 purple_tint = vec3(0.6 + (menace.y * 0.000001), 0.2, 0.8 + (menace.x * 0.000001));
		
    pixel_color.rgb = mix(pixel_color.rgb, purple_tint, 0.2);

    return pixel_color * color;
}

#ifdef VERTEX
vec4 position(mat4 transform_projection,vec4 vertex_position)
{
    return transform_projection*vertex_position;
}
#endif