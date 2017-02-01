// Particle system for acquiring an item from a portal hack:
// 1. item pops up from portal and disolves into particles.
// 2. particles linger, compress a bit.
// 3. then particles fly to player.
#ifdef FRAGMENT
precision mediump float;
#endif

#include "disposable_particle_common.glh"

#pragma optimize none

#ifdef VERTEX

uniform vec4 u_color;
uniform vec4 u_params;
uniform vec3 u_beginPos;
uniform vec3 u_endPos;

// Animation stage begin and end times.
// x: fade in
// y: fly to player
// z: fade out
uniform vec3 u_beginTimes;
uniform vec3 u_endTimes;

// Time skews for different stages of animation:
// x: fade in skew.
// y: fly to player skew.
// z: undulation skew.
uniform vec3 u_timeSkews;

// If 1, use linear animations instead of smoothstep.
uniform int u_linear;

// How big the mass of particles is once it reaches the player as a % of initial radius.
// (0 means they all end up at the center of the player)
#define TARGET_RADIUS u_params.y

void main() {
  // Different elapsed times with different skews for different parts of the animation.
  vec3 elapsedTimes = u_params.xxx - u_timeSkews * a_tOffset;

  // elapsedTimes.xyy below, because fly to player and fade out share the same time skew.
  vec3 progress;
  if (u_linear == 1) {
    progress = clamp((elapsedTimes.xyy - u_beginTimes) / (u_endTimes - u_beginTimes), 0.0, 1.0);
  } else {
    progress = smoothstep(u_beginTimes, u_endTimes, elapsedTimes.xyy);
  }
  float fadeIn01 = progress.x;
  float fly01 = progress.y;
  float fadeOut01 = progress.z;

  vec3 toParticleNorm = normalize(a_position);
  float undulationMagnitude = u_params.z;
  vec3 undulationOffset = toParticleNorm * undulationMagnitude * cos(1.3 * PI * elapsedTimes.z);
  vec3 startPos = u_beginPos + a_position + undulationOffset;
  vec3 targetPos = u_endPos + TARGET_RADIUS * a_position;
  vec3 toTarget = (targetPos - startPos);

  vec3 particle_position = startPos + toTarget * fly01;

  // get billboard coordinate system
  vec3 billboard_offset = buildBillboardOffset(particle_position, u_params.w);

  v_color = u_color;
  v_color.a *= fadeIn01 * (1.0 - fadeOut01);

  gl_Position = u_modelViewProject * vec4(particle_position + billboard_offset, 1.0);
}

#endif


#ifdef FRAGMENT
void main() {
  gl_FragColor = defaultParticleFragment();
}
#endif

