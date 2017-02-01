// Shader for the particles that float up from the portal
#ifdef FRAGMENT
precision mediump float;
#endif

#include "particle_common.glh"

#ifdef VERTEX
#pragma optimize none

/* uniform array lengths set by ParticleVisuals.SYSTEMS_PER_DRAW */
uniform vec4 u_color[40];
uniform vec4 u_position[40];
uniform vec4 u_params[40];
attribute float a_speed;
attribute float a_portalIndex;
attribute float a_index;

void main() {
  int portalIndex = int(a_portalIndex);
  float n = u_color[portalIndex].w;
  if (a_index > n) {
     gl_Position = vec4(0.0, 0.0, 0.0, 1.0);
     v_texCoord0 = vec2(0.0, 0.0);
     v_color = vec4(0.0, 0.0, 0.0, 0.0);
  } else {
    vec4 params = u_params[portalIndex];
    vec4 color = vec4(u_color[portalIndex].rgb, 1.0);
    vec3 system_position = u_position[portalIndex].xyz;
    float height = u_position[portalIndex].w;

    float elapsedTime = params.x;
    float tModulus = params.y;  // in a simple linear model this is distance traveled
    float spread = params.z;  // how far apart the particles should be from each other
    float camScale = params.w;  // uniform scaling due to distance to camera

    // account for particle dynamics here - t is a parametric variable restricted to tModulus
    float t = mod(a_speed * elapsedTime, tModulus);
    vec3 dynamics = vec3(0.0, t * height, 0.0);
    vec3 particle_position = system_position + a_position * spread + dynamics;

    v_color = color;

      // dilute the alpha if the particle is approaching the end of its lifetime
    v_color.w *= (1.0 - t / tModulus) * smoothstep(0.0, 0.2, t / tModulus);

    // get billboard coordinate system
    vec3 billboard_offset = buildBillboardOffset(particle_position, camScale);
    gl_Position = u_modelViewProject * vec4(particle_position + billboard_offset, 1.0);
  }
}

#endif

#ifdef FRAGMENT
void main() {
  gl_FragColor = defaultParticleFragment();
}
#endif

