// GENERATED FILE //
#ifndef GL_ES
#define lowp
#define mediump
#define highp
#endif
attribute vec2 a_texCoord0;
attribute vec3 a_position;
uniform vec3 u_lightDir;
uniform vec2 u_pulseTimeAndViewScale;
uniform vec2 u_myLocation;
uniform mat4 u_modelView;
uniform mat4 u_modelViewProject;
varying vec4 v_pulseColorAndTime;
varying vec4 v_pulseVals;
varying vec2 v_texCoord0;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = a_position;
  gl_Position = (u_modelViewProject * tmpvar_1);
  vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = a_position;
  v_pulseColorAndTime.xyz = (vec3(1.0, 0.5, 0.0) * clamp (dot ((u_modelView * tmpvar_2).xyz, u_lightDir), 0.1, 1.0));
  v_pulseColorAndTime.w = u_pulseTimeAndViewScale.x;
  v_texCoord0 = a_texCoord0;
  vec2 tmpvar_3;
  tmpvar_3.y = 50.0;
  tmpvar_3.x = (cos(((a_texCoord0.y - 0.5) * 3.14159)) * 100.0);
  v_pulseVals.xy = ((a_texCoord0 - u_myLocation) * tmpvar_3);
  v_pulseVals.z = (2.0 * u_pulseTimeAndViewScale.y);
  v_pulseVals.w = (v_pulseVals.z * v_pulseVals.z);
}

