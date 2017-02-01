// Portal shader
#ifdef FRAGMENT
precision mediump float;
#endif

#include "portal_common.glh"

varying vec2 v_texCoord0;

#ifdef VERTEX
uniform mat4 u_modelViewProject;
attribute vec4 a_position;
attribute vec2 a_texCoord0;
void main() {
   v_texCoord0 = a_texCoord0;
   vec3 rotatedPosition = rotateXZ(a_position.xyz, u_rotation * a_position.w);
   gl_Position = u_modelViewProject * vec4(rotatedPosition, 1.0);
}
#endif

#ifdef FRAGMENT
uniform vec4 u_baseColor;
void main() {
  gl_FragColor = u_baseColor * computePortalColor(v_texCoord0);
}
#endif

