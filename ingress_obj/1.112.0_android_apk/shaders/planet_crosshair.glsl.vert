// GENERATED FILE //
#ifndef GL_ES
#define lowp
#define mediump
#define highp
#endif
attribute vec2 a_texCoord0;
attribute vec3 a_position;
uniform vec4 u_texScaleAndBias;
uniform mat4 u_modelViewProject;
varying vec2 v_texCoord0;
void main ()
{
  v_texCoord0 = ((a_texCoord0 * u_texScaleAndBias.xy) + u_texScaleAndBias.zw);
  vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = a_position;
  vec4 tmpvar_2;
  tmpvar_2 = (u_modelViewProject * tmpvar_1);
  gl_Position.zw = tmpvar_2.zw;
  gl_Position.xy = clamp (tmpvar_2.xy, -(tmpvar_2.w), tmpvar_2.w);
}

