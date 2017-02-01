// GENERATED FILE //
#ifndef GL_ES
#define lowp
#define mediump
#define highp
#endif
#ifdef GL_ES
precision mediump float;
#endif
uniform sampler2D u_texture;
uniform float u_rampTarget;
uniform float u_alpha;
vec4 computePortalColor(vec2 texCoords) {
 vec4 tex = texture2D(u_texture, texCoords);
 float t = 1.0 - min(1.0, abs(tex.r - u_rampTarget) * 5.0);
 float c_max = tex.g;
 return vec4(tex.bbb * (1.3 + c_max * t), tex.a * u_alpha);
}
varying vec3 v_texCoord0;
uniform vec4 u_baseColor;
uniform vec4 u_transitionColor;
uniform float u_boundary;
const float INV_TRANSITION_REGION_SIZE = 1.0 / 2.0;
const float MAX_DARKEN = 0.5;
void main() {
 vec4 base_color = computePortalColor(v_texCoord0.xy);
 float transition_fraction = clamp((u_boundary - v_texCoord0.z) * INV_TRANSITION_REGION_SIZE, 0.0, 1.0);
 float boundary_fraction = 1.0 - 2.0 * abs(transition_fraction - 0.5);
 vec4 munged_transition_color = vec4(
 u_transitionColor.rgb * (1.0 - (boundary_fraction * MAX_DARKEN)),
 u_transitionColor.a + 10.0 * boundary_fraction);
 vec4 tint = mix(u_baseColor, munged_transition_color, transition_fraction);
 gl_FragColor = base_color * tint;
}

