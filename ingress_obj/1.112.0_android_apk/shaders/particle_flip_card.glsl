#ifdef FRAGMENT
precision mediump float;
#endif

#include "particle_common.glh"

#ifdef VERTEX
#pragma optimize none

uniform vec4 u_color;
uniform vec4 u_position;
uniform vec4 u_params;
uniform vec3 u_destinations[9]; /* tied to FlipParticleEffect.MAX_DESTINATIONS */
attribute float a_speed;
attribute float a_tOffset;
attribute float a_index;

const float T_MODULUS_S = 10.0; /* tied to FlipParticleEffect.DEFAULT_TIME_MODULUS_S */

void main() {
  int destinationIndex = int(a_index);
  float n = u_params.y;
  if (a_index >= n) {
     gl_Position = vec4(0.0, 0.0, 0.0, 1.0);
     v_texCoord0 = vec2(0.0, 0.0);
     v_color = vec4(0.0, 0.0, 0.0, 0.0);
  } else {
    vec3 destination = u_destinations[destinationIndex];
    vec3 system_position = u_position.xyz;

    float elapsedTime = u_params.x + a_tOffset;
    float tModulus = T_MODULUS_S / a_speed;  // time to complete the spline

      // from 0 to 3, governs parametric animation
    float convergence = u_params.z + a_tOffset * 2.0 * a_speed / T_MODULUS_S - 1.0;
    float camScale = u_params.w;  // uniform scaling due to distance to camera

    float spread = 1.0 - smoothstep(1.0, 1.5, convergence);
    float destinationPull = 1.0 - smoothstep(3.25, 4.0, convergence);
    float radius = u_position.w * spread;

      // account for particle dynamics here
      // p is the percentage through the path we've traveled.
    float p = mod(elapsedTime, tModulus) / tModulus;
    vec3 rotation = vec3(-cos(p * 2.0 * PI) * radius, 0.0, sin(p * 2.0 * PI) * radius);

    vec3 particle_position = system_position + a_position * spread + rotation
         + destination * destinationPull;

    vec3 billboard_offset = buildBillboardOffset(particle_position, camScale);

    float finalAlphaReduction = 1.0 - smoothstep(3.9, 4.0, convergence);

    v_color = vec4(u_color.xyz, u_color.w * finalAlphaReduction);

    gl_Position = u_modelViewProject *
        vec4(particle_position + billboard_offset, 1.0);
  }
}

#endif

#ifdef FRAGMENT
void main() {
  gl_FragColor = defaultParticleFragment();
}
#endif

