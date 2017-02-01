// GENERATED FILE //
#ifndef GL_ES
#define lowp
#define mediump
#define highp
#endif
uniform mat4 u_modelViewProject;
uniform vec3 u_cameraPos;
attribute vec3 a_position;
attribute vec2 a_texCoord0;
attribute float a_scale;
varying vec2 v_texCoord0;
varying vec4 v_color;
const vec3 y_hat = vec3(0.0, 1.0, 0.0);
vec3 buildBillboardOffset(vec3 particle_position, float camScale) {
 vec3 camVec = normalize(particle_position - u_cameraPos);
 vec3 right = cross(camVec, y_hat);
 vec3 up = cross(right, camVec);
 vec2 scales = a_scale * (a_texCoord0.xy - vec2(0.5)) * camScale;
 right = right * scales.x;
 up = up * scales.y;
 v_texCoord0 = a_texCoord0;
 return up + right;
}
uniform vec4 u_color;
uniform vec4 u_position;
uniform vec4 u_params;
uniform vec3 u_destinations[9];
attribute float a_speed;
attribute float a_tOffset;
attribute float a_index;
const float T_MODULUS_S = 10.0;
void main() {
 int destinationIndex = int(a_index);
 float n = u_params.y;
 if (a_index >= n) {
 gl_Position = vec4(0.0, 0.0, 0.0, 1.0);
 v_texCoord0 = vec2(0.0, 0.0);
 v_color = vec4(0.0, 0.0, 0.0, 0.0);
 } else {
 vec3 destination = u_destinations[destinationIndex];
 vec3 system_position = u_position.xyz;
 float elapsedTime = u_params.x + a_tOffset;
 float tModulus = T_MODULUS_S / a_speed;
 float convergence = u_params.z + a_tOffset * 2.0 * a_speed / T_MODULUS_S - 1.0;
 float camScale = u_params.w;
 float spread = 1.0 - smoothstep(1.0, 1.5, convergence);
 float destinationPull = 1.0 - smoothstep(3.25, 4.0, convergence);
 float radius = u_position.w * spread;
 float p = mod(elapsedTime, tModulus) / tModulus;
 vec3 rotation = vec3(-cos(p * 2.0 * 3.1415926535897932384626433832795) * radius, 0.0, sin(p * 2.0 * 3.1415926535897932384626433832795) * radius);
 vec3 particle_position = system_position + a_position * spread + rotation
 + destination * destinationPull;
 vec3 billboard_offset = buildBillboardOffset(particle_position, camScale);
 float finalAlphaReduction = 1.0 - smoothstep(3.9, 4.0, convergence);
 v_color = vec4(u_color.xyz, u_color.w * finalAlphaReduction);
 gl_Position = u_modelViewProject *
 vec4(particle_position + billboard_offset, 1.0);
 }
}

