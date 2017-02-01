// GENERATED FILE //
#ifndef GL_ES
#define lowp
#define mediump
#define highp
#endif
uniform float u_elapsedTime;
attribute vec2 a_texCoord0;
attribute vec3 a_position;
varying vec4 v_texCoord0And1;
uniform mat4 u_modelViewProject;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = vec3(0.0, 0.0, 0.0);
  tmpvar_1.w = (-(u_elapsedTime) * 0.45);
  v_texCoord0And1 = (a_texCoord0.xyxy + tmpvar_1);
  vec4 tmpvar_2;
  tmpvar_2.w = 0.85;
  tmpvar_2.xyz = a_position;
  gl_Position = (u_modelViewProject * tmpvar_2);
}

