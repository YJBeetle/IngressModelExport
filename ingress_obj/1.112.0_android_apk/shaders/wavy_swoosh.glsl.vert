// GENERATED FILE //
#ifndef GL_ES
#define lowp
#define mediump
#define highp
#endif
varying vec3 v_texCoord0;
varying vec4 v_color;
uniform mat4 u_modelViewProject;
uniform vec3 u_cameraFwd;
uniform float u_elapsedTime;
uniform float u_alpha;
uniform vec4 u_color;
attribute vec4 a_position;
attribute vec4 a_texCoord0;
void main() {
 vec3 normal = normalize(vec3(a_texCoord0.z, .001, a_texCoord0.w));
 v_texCoord0.xy = a_texCoord0.xy;
 v_color = u_color;
 float alpha = clamp(abs(dot(normal, u_cameraFwd)), 0.5, 1.0);
 v_color.a *= (3.0 * alpha * alpha) - (2.0 * alpha * alpha * alpha);
 v_color.a *= u_alpha;
 v_texCoord0.z = 5.0 * v_texCoord0.x + 25.0 * u_elapsedTime;
 gl_Position = u_modelViewProject * vec4(a_position.x,
 u_elapsedTime * a_position.y + (1.0 - u_elapsedTime) * a_position.w,
 a_position.z, 1.0);
}

