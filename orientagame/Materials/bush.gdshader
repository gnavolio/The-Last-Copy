shader_type spatial ;

render_mode depth_draw_always, alpha_to_coverage, cull_disabled;

uniform sampler2D foliage_texture ;
uniform vec3 foliage_colour : source_color = vec3(0.13, 0.33, 0.25) ;
uniform vec3 foliage_colour2 : source_color = vec3(0.13, 0.33, 0.25) ;

varying vec3 worldPos;
uniform sampler2D noise;
uniform float noiseScale = 20.0;
void vertex()
{	
    NORMAL = -NORMAL ;
	//UV = UV * uv1_scale.xy + uv1_offset.xy;

    // Generate the 'billboard' 2D coordinates from UV coordinates, shift it to center over UV 0,0.
    vec2 viewspace_offset = UV.xy - vec2(0.5) ; 
	//pretend the coordinates are in viewspace and pass them into inverse(MODELVIEW_MATRIX) to cheat our way into a billboard effect
	vec4 modelspace_offset = inverse(MODELVIEW_MATRIX) * vec4(viewspace_offset.xy, 0.0, 0.0) ;
	
    VERTEX += modelspace_offset.xyz ;

}

void fragment()
{
	
	vec3 noiseLevel = texture(noise, worldPos.xz / noiseScale).rgb;
	ALBEDO = mix(foliage_colour, foliage_colour2, UV.y) * mix(foliage_colour, foliage_colour2, noiseLevel.r);
    ALPHA = texture(foliage_texture, UV).g ;
}