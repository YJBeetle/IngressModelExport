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
varying float v_alpha;
uniform vec2 u_globParams[120];
const float CAMSCALE_EXPONENT = 0.25;
void main() {
 int portalIndex = int(a_position.z);
 vec3 position = vec3(u_globParams[portalIndex].x,
 0.0,
 u_globParams[portalIndex].y);
 vec3 camVec = position - u_cameraPos;
 vec3 camVecNorm = normalize(camVec);
 float camScale = pow(length(camVec), CAMSCALE_EXPONENT);
 vec3 right = cross(camVecNorm, y_hat);
 vec3 up = cross(right, camVecNorm);
 vec2 scales = (a_position.xy - vec2(0.5)) * camScale;
 right = right * scales.x;
 up = up * scales.y;
 v_texCoord0 = a_position.xy;
 gl_Position = u_modelViewProject * vec4(position + up + right, 1.0);
}

