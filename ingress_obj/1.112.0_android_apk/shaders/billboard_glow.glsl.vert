// GENERATED FILE //
#ifndef GL_ES
#define lowp
#define mediump
#define highp
#endif
attribute vec2 a_position;
uniform vec4 u_rect;
varying vec2 v_texCoord;
void main ()
{
  v_texCoord = a_position;
  vec4 tmpvar_1;
  tmpvar_1.zw = vec2(0.0, 1.0);
  tmpvar_1.xy = (u_rect.xy + ((u_rect.zw * 0.5) * (a_position + vec2(1.0, 1.0))));
  gl_Position = tmpvar_1;
}

