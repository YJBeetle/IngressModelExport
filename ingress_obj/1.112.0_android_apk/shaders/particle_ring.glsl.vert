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
uniform float u_counterSpread;
uniform vec2 u_tiltCosSin;
uniform float u_subsystems;
uniform float u_systemRotationSpeed;
attribute float a_speed;
attribute float a_tOffset;
attribute float a_index;
void main() {
 vec3 system_position = u_position.xyz;
 float radius = u_position.w;
 float elapsedSystemTime = u_params.x;
 float elapsedTime = elapsedSystemTime + a_tOffset;
 float defaultTModulus = u_params.y;
 float tModulus = defaultTModulus / a_speed;
 float spread = u_params.z;
 float camScale = u_params.w;
 float systemP = u_systemRotationSpeed * mod(elapsedSystemTime, defaultTModulus) / defaultTModulus;
 float cosT = u_tiltCosSin.x;
 float oneMCosT = 1.0 - cosT;
 float sinT = u_tiltCosSin.y;
 float systemTheta = 3.1415926535897932384626433832795 * 2.0 * (a_index / u_subsystems + systemP);
 vec3 u = vec3(cos(systemTheta), 0.0, sin(systemTheta));
 mat3 system_transform = mat3(
 cosT + u.x * u.x * oneMCosT, u.z * sinT, u.z * u.x * oneMCosT,
 -u.z * sinT, cosT, u.x * sinT,
 u.x * u.z * oneMCosT, -u.x * sinT, cosT + u.z * u.z * oneMCosT
 );
 float p = mod(elapsedTime, tModulus) / tModulus;
 float pTheta = p * 2.0 * 3.1415926535897932384626433832795;
 vec3 particle_rotation = vec3(-cos(pTheta), 0.0, sin(pTheta));
 float counter_radius_ratio = 1.0 - u_counterSpread * length(a_position) * (1.0 - spread * spread);
 vec3 dynamics = system_transform * particle_rotation * radius * counter_radius_ratio;
 vec3 particle_position = system_position + a_position * spread + dynamics;
 vec3 billboard_offset = buildBillboardOffset(particle_position, camScale);
 v_color = u_color;
 vec3 temp = particle_position + billboard_offset;
 gl_Position = u_modelViewProject * vec4(temp, 1.0);
}

