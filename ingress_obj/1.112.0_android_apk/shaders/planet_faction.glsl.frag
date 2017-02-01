// GENERATED FILE //
#ifndef GL_ES
#define lowp
#define mediump
#define highp
#endif
#ifdef GL_ES
precision mediump float;
#endif
uniform sampler2D u_lut;
uniform sampler2D u_texture;
varying vec4 v_texCoord0AndBlendAndIntensity;
void main ()
{
vec4 tmpvar_1;
  tmpvar_1 = texture2D (u_lut, texture2D (u_texture, v_texCoord0AndBlendAndIntensity.xy).xy);
vec3 tmpvar_2;
  tmpvar_2 = (tmpvar_1.xyz * v_texCoord0AndBlendAndIntensity.w);
  gl_FragColor.xyz = tmpvar_2;
float tmpvar_3;
  tmpvar_3 = (tmpvar_1.w * v_texCoord0AndBlendAndIntensity.z);
  gl_FragColor.w = tmpvar_3;
}

