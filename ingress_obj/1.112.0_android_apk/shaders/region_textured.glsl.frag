// GENERATED FILE //
#ifndef GL_ES
#define lowp
#define mediump
#define highp
#endif
#ifdef GL_ES
precision mediump float;
#endif
uniform vec4 u_color;
uniform sampler2D u_texture;
varying vec2 v_texCoord0;
void main ()
{
vec4 tmpvar_1;
  tmpvar_1 = (texture2D (u_texture, v_texCoord0) * u_color);
  gl_FragColor = tmpvar_1;
}

