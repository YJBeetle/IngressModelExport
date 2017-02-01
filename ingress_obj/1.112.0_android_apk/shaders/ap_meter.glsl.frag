// GENERATED FILE //
#ifndef GL_ES
#define lowp
#define mediump
#define highp
#endif
#ifdef GL_ES
precision mediump float;
#endif
uniform float overdriveFactor;
uniform vec4 overdriveColor;
uniform float highlightFactor;
uniform float mask;
uniform sampler2D u_texture;
varying vec3 v_texCoords;
varying vec4 v_color;
void main ()
{
vec4 tmpvar_1;
  tmpvar_1 = texture2D (u_texture, v_texCoords.zy);
vec4 tmpvar_2;
  tmpvar_2 = texture2D (u_texture, v_texCoords.xy);
vec4 tmpvar_3;
  tmpvar_3.xyz = mix ((mix (overdriveColor.xyz, v_color.xyz, float((overdriveFactor >= tmpvar_1.w))) * tmpvar_2.xyz), vec3(1.0, 0.9, 0.7), (highlightFactor * max (0.0, (1.0 - (10.0 * abs((tmpvar_1.w - mask)))))));
  tmpvar_3.w = ((v_color.w * tmpvar_2.w) * max (0.0, (1.0 - (50.0 * max (0.0, (tmpvar_1.w - mask))))));
  gl_FragColor = tmpvar_3;
}

