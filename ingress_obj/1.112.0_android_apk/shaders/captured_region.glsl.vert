// GENERATED FILE //
#ifndef GL_ES
#define lowp
#define mediump
#define highp
#endif
varying vec3 v_texCoord0;
varying vec3 v_texCoord1;
varying vec4 v_color;
attribute vec4 a_position;
attribute vec4 a_color;
uniform mat4 u_modelViewProject;
uniform vec2 u_modelToTexOrigin;
uniform vec2 u_modelToTexScale;
uniform vec2 u_texCoordOffset0;
uniform vec2 u_texCoordOffset1;
void main() {
 v_color = a_color;
 v_texCoord0.xy = a_position.xy * u_modelToTexScale + u_modelToTexOrigin + u_texCoordOffset0;
 v_texCoord1.xy = v_texCoord0.xy + u_texCoordOffset1;
 v_texCoord0.z = a_position.z;
 v_texCoord1.z = pow(a_position.w, 0.75);
 gl_Position = u_modelViewProject * vec4(a_position.x, 0.0, a_position.y, 1.0);
}

