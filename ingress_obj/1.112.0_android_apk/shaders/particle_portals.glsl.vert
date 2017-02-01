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
uniform vec4 u_color[40];
uniform vec4 u_position[40];
uniform vec4 u_params[40];
attribute float a_speed;
attribute float a_portalIndex;
attribute float a_index;
void main() {
 int portalIndex = int(a_portalIndex);
 float n = u_color[portalIndex].w;
 if (a_index > n) {
 gl_Position = vec4(0.0, 0.0, 0.0, 1.0);
 v_texCoord0 = vec2(0.0, 0.0);
 v_color = vec4(0.0, 0.0, 0.0, 0.0);
 } else {
 vec4 params = u_params[portalIndex];
 vec4 color = vec4(u_color[portalIndex].rgb, 1.0);
 vec3 system_position = u_position[portalIndex].xyz;
 float height = u_position[portalIndex].w;
 float elapsedTime = params.x;
 float tModulus = params.y;
 float spread = params.z;
 float camScale = params.w;
 float t = mod(a_speed * elapsedTime, tModulus);
 vec3 dynamics = vec3(0.0, t * height, 0.0);
 vec3 particle_position = system_position + a_position * spread + dynamics;
 v_color = color;
 v_color.w *= (1.0 - t / tModulus) * smoothstep(0.0, 0.2, t / tModulus);
 vec3 billboard_offset = buildBillboardOffset(particle_position, camScale);
 gl_Position = u_modelViewProject * vec4(particle_position + billboard_offset, 1.0);
 }
}

