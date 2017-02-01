// GENERATED FILE //
#ifndef GL_ES
#define lowp
#define mediump
#define highp
#endif
#ifdef GL_ES
precision mediump float;
#endif
uniform vec3 u_borderRange;
uniform vec3 u_glowRange;
uniform sampler2D u_borderGradient;
uniform sampler2D u_texture;
varying float v_intensity;
varying vec4 v_texCoord0AndLatLng;
void main ()
{
vec4 tmpvar_1;
  tmpvar_1 = texture2D (u_texture, v_texCoord0AndLatLng.xy);
vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = (mix ((vec3(0.25, 0.25, 0.25) * texture2D (u_borderGradient, v_texCoord0AndLatLng.zw).w), mix (vec3(1.0, 0.659, 0.0), vec3(1.0, 1.0, 1.0), clamp (((tmpvar_1.w - u_borderRange.x) * u_borderRange.z), 0.0, 1.0)), clamp (((tmpvar_1.w - u_glowRange.x) * u_glowRange.z), 0.0, 1.0)) * v_intensity);
  gl_FragColor = tmpvar_2;
}

