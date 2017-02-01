// GENERATED FILE //
#ifndef GL_ES
#define lowp
#define mediump
#define highp
#endif
attribute vec2 a_texCoord0;
attribute vec3 a_position;
uniform vec3 u_lightDir;
uniform mat4 u_modelView;
uniform mat4 u_modelViewProject;
varying float v_intensity;
varying vec4 v_texCoord0AndLatLng;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = a_position;
  gl_Position = (u_modelViewProject * tmpvar_1);
  vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = a_position;
  vec2 tmpvar_3;
  tmpvar_3.x = a_texCoord0.x;
  tmpvar_3.y = a_texCoord0.y;
  v_texCoord0AndLatLng.xy = tmpvar_3;
  v_texCoord0AndLatLng.zw = (a_texCoord0 * vec2(36.0, 18.0));
  v_intensity = clamp (dot ((u_modelView * tmpvar_2).xyz, u_lightDir), 0.1, 1.0);
}

