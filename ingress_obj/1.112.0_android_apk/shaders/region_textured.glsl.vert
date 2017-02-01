// GENERATED FILE //
#ifndef GL_ES
#define lowp
#define mediump
#define highp
#endif
attribute vec2 a_texCoord0;
attribute vec3 a_position;
uniform vec2 u_texCoordExtent;
uniform vec2 u_texCoordBase;
uniform mat4 u_modelViewProject;
varying vec2 v_texCoord0;
void main ()
{
  v_texCoord0 = ((a_texCoord0 * u_texCoordExtent) + u_texCoordBase);
  vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = a_position;
  gl_Position = (u_modelViewProject * tmpvar_1);
}

