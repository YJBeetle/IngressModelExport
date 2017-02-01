// GENERATED FILE //
#ifndef GL_ES
#define lowp
#define mediump
#define highp
#endif
#ifdef GL_ES
precision mediump float;
#endif
varying vec3 v_perturbCoordAndAngle;
uniform vec2 u_AngleAndPerturbFactor;
uniform sampler2D u_holeNoiseTexture;
varying vec2 v_texCoord0;
uniform vec3 u_contributionsAndAlpha;
uniform vec2 u_rampTargetInvWidth;
uniform sampler2D u_texture;
void main ()
{
float tmpvar_1;
  tmpvar_1 = (v_perturbCoordAndAngle.z - (u_AngleAndPerturbFactor.x + (texture2D (u_holeNoiseTexture, v_perturbCoordAndAngle.xy).w * u_AngleAndPerturbFactor.y)));
float tmpvar_2;
  tmpvar_2 = float((tmpvar_1 >= 0.0));
float tmpvar_3;
  tmpvar_3 = (6.66667 * tmpvar_1);
float tmpvar_4;
  tmpvar_4 = clamp ((tmpvar_3 * tmpvar_3), 0.0, 1.0);
vec4 tmpvar_5;
  tmpvar_5 = texture2D (u_texture, v_texCoord0);
float tmpvar_6;
  tmpvar_6 = dot (u_contributionsAndAlpha.xy, tmpvar_5.xy);
float tmpvar_7;
  tmpvar_7 = min (1.0, abs(((tmpvar_5.z - u_rampTargetInvWidth.x) * u_rampTargetInvWidth.y)));
vec3 tmpvar_8;
  tmpvar_8 = (vec3(0.93, 0.11, 0.14) * (tmpvar_5.w + 0.75));
float tmpvar_9;
  if ((tmpvar_7 > 0.5)) {
    tmpvar_9 = tmpvar_5.w;
  } else {
    tmpvar_9 = ((tmpvar_7 + 0.35) * tmpvar_6);
  };
vec4 tmpvar_10;
  tmpvar_10.xyz = tmpvar_8;
  tmpvar_10.w = tmpvar_9;
vec4 tmpvar_11;
  tmpvar_11.xyz = tmpvar_10.xyz;
  tmpvar_11.w = (tmpvar_2 * tmpvar_9);
vec4 tmpvar_12;
  tmpvar_12 = mix (vec4(1.0, 1.0, 1.0, 1.0), tmpvar_11, tmpvar_4);
vec4 tmpvar_13;
  tmpvar_13.xyz = tmpvar_12.xyz;
  tmpvar_13.w = (tmpvar_12.w * u_contributionsAndAlpha.z);
  gl_FragColor = tmpvar_13;
}

