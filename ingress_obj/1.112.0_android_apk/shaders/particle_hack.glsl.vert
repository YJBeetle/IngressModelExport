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
attribute float a_speed;
attribute float a_tOffset;
attribute float a_index;
uniform vec4 u_color;
uniform vec4 u_params;
uniform vec3 u_beginPos;
uniform vec3 u_endPos;
uniform vec3 u_beginTimes;
uniform vec3 u_endTimes;
uniform vec3 u_timeSkews;
uniform int u_linear;
void main() {
 vec3 elapsedTimes = u_params.xxx - u_timeSkews * a_tOffset;
 vec3 progress;
 if (u_linear == 1) {
 progress = clamp((elapsedTimes.xyy - u_beginTimes) / (u_endTimes - u_beginTimes), 0.0, 1.0);
 } else {
 progress = smoothstep(u_beginTimes, u_endTimes, elapsedTimes.xyy);
 }
 float fadeIn01 = progress.x;
 float fly01 = progress.y;
 float fadeOut01 = progress.z;
 vec3 toParticleNorm = normalize(a_position);
 float undulationMagnitude = u_params.z;
 vec3 undulationOffset = toParticleNorm * undulationMagnitude * cos(1.3 * 3.1415926535897932384626433832795 * elapsedTimes.z);
 vec3 startPos = u_beginPos + a_position + undulationOffset;
 vec3 targetPos = u_endPos + u_params.y * a_position;
 vec3 toTarget = (targetPos - startPos);
 vec3 particle_position = startPos + toTarget * fly01;
 vec3 billboard_offset = buildBillboardOffset(particle_position, u_params.w);
 v_color = u_color;
 v_color.a *= fadeIn01 * (1.0 - fadeOut01);
 gl_Position = u_modelViewProject * vec4(particle_position + billboard_offset, 1.0);
}

