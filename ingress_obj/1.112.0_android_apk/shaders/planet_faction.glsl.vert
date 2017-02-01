// GENERATED FILE //
#ifndef GL_ES
#define lowp
#define mediump
#define highp
#endif
attribute vec2 a_texCoord0;
attribute vec3 a_position;
uniform vec2 u_shellSize;
uniform vec3 u_lightDir;
uniform mat4 u_modelView;
uniform mat4 u_modelViewProject;
varying vec4 v_texCoord0AndBlendAndIntensity;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = (a_position * u_shellSize.x);
  gl_Position = (u_modelViewProject * tmpvar_1);
  vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = a_position;
  vec2 tmpvar_3;
  tmpvar_3.x = a_texCoord0.x;
  tmpvar_3.y = a_texCoord0.y;
  v_texCoord0AndBlendAndIntensity.xy = tmpvar_3;
  v_texCoord0AndBlendAndIntensity.z = u_shellSize.y;
  v_texCoord0AndBlendAndIntensity.w = clamp (dot ((u_modelView * tmpvar_2).xyz, u_lightDir), 0.1, 1.0);
}

