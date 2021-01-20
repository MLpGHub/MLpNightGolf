shader_type spatial;
// render_mode depth_draw_alpha_prepass, cull_disabled;

// https://docs.godotengine.org/en/stable/tutorials/shading/shading_reference/spatial_shader.html#vertex-built-ins
// https://docs.godotengine.org/en/stable/tutorials/shading/migrating_to_godot_shader_language.html#gl-position
// https://docs.godotengine.org/en/stable/tutorials/shading/advanced_postprocessing.html#depth-texture

uniform vec4 albedo: hint_color = vec4(0.341176, 0.541176, 0.701961, 1.0);
uniform sampler2D albedo_texture; // 1024x1024, seamless, open simplex with 2 octaves
uniform float emission_amount: hint_range(0, 10) = 5;
uniform vec3 ball_pos = vec3(0);
uniform float scale = 0.25;
uniform vec2 diff = vec2(0);

varying vec3 ball;
varying vec3 view;


void vertex() {
	/* coordinate transforms
	VERTEX is in model space
	view space gives positions relative to the camera (z is distance)
	clip space is with (0, 0) in mid; [-1, -1](bottom left) to [1, 1](top right)
	world space is 'generic' world
	*/
	
	// orgn = origin;
	// orgn = vec3(0);
	// orgn.y = dy;
	// orgn.y = -0.6;
	ball = vec3(0.113, -0.656, -0.285069);
	// ball = ball_pos;
}

void fragment() {
	vec4 albedo_tex = texture(albedo_texture, UV);
	ALBEDO = albedo.rgb * albedo_tex.rgb;
	// cam has to look straight to the sphere
	
//	vec4 ball_vs = vec4(ball_pos, 1.0) * INV_CAMERA_MATRIX * PROJECTION_MATRIX;
//	vec4 view_center_vs = vec4(view_center_pos, 1.0) * INV_CAMERA_MATRIX * PROJECTION_MATRIX;
//
//	vec4 center_vs = vec4(0, 0, 0, 1) * INV_PROJECTION_MATRIX;
//	vec2 offset = ball_vs.xy - view_center_vs.xy;

	vec2 offset = ball.xy;
	
//	vec2 offset = (vec4(diff, 0, 1) * INV_PROJECTION_MATRIX).xy;
	
	EMISSION = ALBEDO;
	float dist = length((VERTEX.xy - offset));
	float scl = scale; // scale
	float d_inner = 0.2 * scl;
	float d_outer = 1.0 * scl;
	float delta = d_outer - d_inner;
	
	bool debug = false;
	
	if (debug) {
		if (dist < 0.2) {
			EMISSION *= emission_amount;
		} else {
			EMISSION *= 0.0;
		}
	} else {
		if (dist < d_inner) {
			EMISSION *= emission_amount;
		} else if (dist > d_inner /*&& dist < d_outer*/) {
			float perc = 1.0 - (dist - d_inner) / delta;
			EMISSION *= emission_amount * perc;
		}
	}
}
