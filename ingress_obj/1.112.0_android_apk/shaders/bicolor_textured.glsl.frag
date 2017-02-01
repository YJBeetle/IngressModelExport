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
uniform vec4 u_color1;
uniform vec4 u_color0;
varying vec2 v_texCoord0;
void main ()
{
vec4 tmpvar_1;
  tmpvar_1 = texture2D (u_texture, v_texCoord0);
vec4 tmpvar_2;
  tmpvar_2.xyz = tmpvar_1.xyz;
  tmpvar_2.w = u_color0.w;
vec4 tmpvar_3;
  tmpvar_3 = (mix (u_color0, tmpvar_2, (2.0 * clamp (tmpvar_1.w, 0.0, 0.5))) * mix (vec4(1.0, 1.0, 1.0, 1.0), u_color1, (2.0 * (clamp (tmpvar_1.w, 0.5, 1.0) - 0.5))));
  gl_FragColor = tmpvar_3;
}

