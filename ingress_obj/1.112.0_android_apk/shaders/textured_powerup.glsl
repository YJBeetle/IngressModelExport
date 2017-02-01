#ifdef FRAGMENT
precision mediump float;
#endif

#include "powerup_common.glh"

#ifdef VERTEX
#pragma optimize full

attribute vec3 a_position;
attribute vec2 a_texCoord0;
uniform float u_elapsedTime;

void main() {
  //v_texCoord0 = a_texCoord0;
  v_texCoord0And1 = vec4(a_texCoord0, a_texCoord0);
  v_texCoord0And1 += vec4(0, 0, 0, -u_elapsedTime * 0.45);
  
  gl_Position = u_modelViewProject * vec4(a_position, 0.85);
}
#endif

#ifdef FRAGMENT
void main() {
  vec4 outColor = getPowerupColor();
  gl_FragColor = vec4(outColor.rgb, outColor.a);
}
#endif

