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
uniform vec4 u_position[60];
uniform vec4 u_params[60];
uniform vec4 u_color;
uniform vec4 u_fadeColor;
uniform float u_fadeTime;
uniform float u_time;
attribute float a_speed;
attribute float a_stencilIndex;
attribute float a_index;
void main() {
 int stencilIndex = int(a_stencilIndex);
 float n = u_params[stencilIndex].x;
 if (a_index > n) {
 gl_Position = vec4(0.0, 0.0, 0.0, 1.0);
 v_texCoord0 = vec2(0.0, 0.0);
 v_color = vec4(0.0, 0.0, 0.0, 0.0);
 } else {
 float z = -1.0;
 vec3 segmentBegin = vec3(u_position[stencilIndex].xy, z);
 vec3 segmentEnd = vec3(u_position[stencilIndex].zw, z);
 float camScale = 1.0;
 vec3 normal = vec3(u_params[stencilIndex].yz, 0.0);
 vec3 dynamics = 0.25 * (normal * cos(a_speed * u_time) * a_position.x +
 vec3(0.0, 0.0, 1.0) * sin(a_speed * u_time) * a_position.z);
 float lerp = a_index / n;
 vec3 particle_position = lerp * segmentBegin + (1.0 - lerp) * segmentEnd + dynamics;
 float startTime = u_params[stencilIndex].w;
 float color_mix = min((u_time - startTime) / u_fadeTime, 1.0);
 v_color = u_color * (1.0 - color_mix) + u_fadeColor * color_mix;
 vec3 billboard_offset = buildBillboardOffset(particle_position, 1.0);
 gl_Position = u_modelViewProject * vec4(particle_position + billboard_offset, 1.0);
 }
}

