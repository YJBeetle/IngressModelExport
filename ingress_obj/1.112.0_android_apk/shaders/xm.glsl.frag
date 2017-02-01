// GENERATED FILE //
#ifndef GL_ES
#define lowp
#define mediump
#define highp
#endif
#ifdef GL_ES
precision mediump float;
#endif
uniform vec4 u_altColor;
uniform vec4 u_teamColor;
uniform sampler2D u_texture;
varying vec4 v_texCoord0And1;
void main ()
{
vec4 tmpvar_1;
  tmpvar_1 = texture2D (u_texture, v_texCoord0And1.xy);
vec4 tmpvar_2;
  tmpvar_2 = texture2D (u_texture, (v_texCoord0And1.zw * 1.35));
float tmpvar_3;
  tmpvar_3 = (((tmpvar_1.y * tmpvar_2.y) + (tmpvar_1.x * tmpvar_2.x)) * 2.0);
vec4 tmpvar_4;
  tmpvar_4 = ((mix (u_altColor, u_teamColor, (tmpvar_3 - 0.25)) + vec4(tmpvar_3)) - vec4(1.0, 1.0, 1.0, 1.0));
  gl_FragColor.xyz = tmpvar_4.xyz;
  gl_FragColor.w = u_teamColor.w;
}

