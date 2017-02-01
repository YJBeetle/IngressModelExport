// GENERATED FILE //
#ifndef GL_ES
#define lowp
#define mediump
#define highp
#endif
#ifdef GL_ES
precision mediump float;
#endif
varying vec4 v_pulseColorAndTime;
varying vec4 v_pulseVals;
void main ()
{
  vec4 tmpvar_1;
  float pulseStrength_2;
  float tmpvar_3;
  tmpvar_3 = dot (v_pulseVals.xy, v_pulseVals.xy);
  if ((tmpvar_3 > v_pulseVals.w)) {
    tmpvar_1 = vec4(0.0, 0.0, 0.0, 0.0);
  } else {
    float tmpvar_4;
    tmpvar_4 = sqrt(tmpvar_3);
    float tmpvar_5;
    tmpvar_5 = (1.0 - (tmpvar_4 / v_pulseVals.z));
    pulseStrength_2 = 1.0;
    if ((tmpvar_4 > (0.2 * v_pulseVals.z))) {
      pulseStrength_2 = ((clamp ((-0.3 + (1.7 * cos((((4.0 * tmpvar_5) + v_pulseColorAndTime.w) * 6.28319)))), -1.0, 1.0) + 1.0) * 0.5);
    };
    vec4 tmpvar_6;
    tmpvar_6.xyz = (v_pulseColorAndTime.xyz * pulseStrength_2);
    tmpvar_6.w = tmpvar_5;
    tmpvar_1 = tmpvar_6;
  };
  gl_FragColor = tmpvar_1;
}

