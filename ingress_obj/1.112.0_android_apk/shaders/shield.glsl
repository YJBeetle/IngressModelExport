#ifdef FRAGMENT
precision mediump float;
#endif

#include "shield_common.glh"

#ifdef VERTEX
#pragma optimize full

attribute vec3 a_position;
attribute vec2 a_texCoord0;

void main() {
  v_texCoord0 = a_texCoord0;
  gl_Position = u_modelViewProject * vec4(a_position, 0.85);
}
#endif

#ifdef FRAGMENT
void main() {
  vec4 outColor = getShieldColor(u_color.rgb);
  gl_FragColor = vec4(outColor.rgb, outColor.a * u_contributionsAndAlpha.z);
}
#endif

