// GENERATED FILE //
#ifndef GL_ES
#define lowp
#define mediump
#define highp
#endif
#ifdef GL_ES
precision mediump float;
#endif
uniform sampler2D u_texture;
uniform vec4 u_color;
varying vec2 v_texCoord0;
void main ()
{
vec4 tmpvar_1;
  tmpvar_1.xyz = u_color.xyz;
  tmpvar_1.w = (u_color.w * texture2D (u_texture, v_texCoord0).w);
  gl_FragColor = tmpvar_1;
}

