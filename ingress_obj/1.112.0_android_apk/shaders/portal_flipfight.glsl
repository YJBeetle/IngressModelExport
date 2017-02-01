// Portal shader when being faction flipped
#ifdef FRAGMENT
precision mediump float;
#endif

#include "portal_common.glh"

varying vec3 v_texCoord0;

#ifdef VERTEX
#pragma optimize none

uniform mat4 u_modelViewProject;
attribute vec4 a_position;
attribute vec2 a_texCoord0;
void main() {
   v_texCoord0.xy = a_texCoord0;

   vec3 rotatedPosition = rotateXZ(a_position.xyz, u_rotation * a_position.w);

   /* use the z component of the texture coords to pass the distance from the portal base. */
   v_texCoord0.z = length(rotatedPosition);

   gl_Position = u_modelViewProject * vec4(rotatedPosition, 1.0);
}
#endif

#ifdef FRAGMENT
uniform vec4 u_baseColor;
uniform vec4 u_transitionColor;
uniform float u_boundary;

const float INV_TRANSITION_REGION_SIZE = 1.0 / 2.0;
const float MAX_DARKEN = 0.5;

void main() {
  vec4 base_color = computePortalColor(v_texCoord0.xy);

  // how much of the transition color to take (vs the base color), [0..1]
  // 0 past the boundary, and then ramps to 1 at boundary - TRANSITION_REGION_SIZE.
  float transition_fraction = clamp((u_boundary - v_texCoord0.z) * INV_TRANSITION_REGION_SIZE, 0.0, 1.0);
  // how much of the boundary effect to use (vs the transition color), [0..1]
  // 0 when transition_fraction == 0 or 1, 1 when transition_fraction == 0.5
  float boundary_fraction = 1.0 - 2.0 * abs(transition_fraction - 0.5);

  // Munge the transition color near the boundary:
  // - rgb gets darker near the boundary
  // - a is super-saturated near the boundary (this helps the boundary stand-out among the
  //   otherwise tranluscent portal)
  vec4 munged_transition_color = vec4(
      u_transitionColor.rgb * (1.0 - (boundary_fraction * MAX_DARKEN)),
      u_transitionColor.a + 10.0 * boundary_fraction);
  vec4 tint = mix(u_baseColor, munged_transition_color, transition_fraction);
  gl_FragColor = base_color * tint;
}
#endif

