// GENERATED FILE //
#ifndef GL_ES
#define lowp
#define mediump
#define highp
#endif
uniform float regionWidth;
uniform float regionX;
uniform mat4 u_projTrans;
attribute vec2 a_texCoord0;
attribute vec4 a_color;
attribute vec2 a_position;
varying vec3 v_texCoords;
varying vec4 v_color;
void main ()
{
  v_color = a_color;
  float tmpvar_1;
  tmpvar_1 = (regionX + (0.5 * (a_texCoord0.x - regionX)));
  vec3 tmpvar_2;
  tmpvar_2.x = tmpvar_1;
  tmpvar_2.y = a_texCoord0.y;
  tmpvar_2.z = (tmpvar_1 + regionWidth);
  v_texCoords = tmpvar_2;
  vec4 tmpvar_3;
  tmpvar_3.zw = vec2(0.0, 1.0);
  tmpvar_3.xy = a_position;
  gl_Position = (u_projTrans * tmpvar_3);
}

