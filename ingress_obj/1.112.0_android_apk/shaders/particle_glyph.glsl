// Shader for particles in glyph game
#ifdef FRAGMENT
precision mediump float;
#endif

#include "particle_common.glh"

#ifdef VERTEX
#pragma optimize none

#define CAMSCALE_EXPONENT 0.125

/* uniform array lengths set by GlyphParticleVisuals.SYSTEMS_PER_DRAW */
uniform vec4 u_position[60];
uniform vec4 u_params[60];
uniform vec4 u_color;
uniform vec4 u_fadeColor;
uniform float u_fadeTime;
uniform float u_time;
attribute float a_speed;
attribute float a_stencilIndex;
attribute float a_index;

/* This shader is driven by com.nianticproject.ingress.common.minigames.glyphs.
   GlpyhParticleVisuals. Please refer to that file for documentation on how
   it works. */
void main() {
  int stencilIndex = int(a_stencilIndex);
  float n = u_params[stencilIndex].x;
  if (a_index > n) {
     gl_Position = vec4(0.0, 0.0, 0.0, 1.0);
     v_texCoord0 = vec2(0.0, 0.0);
     v_color = vec4(0.0, 0.0, 0.0, 0.0);
  } else {
    float z = -1.0;
    vec3 segmentBegin = vec3(u_position[stencilIndex].xy, z);
    vec3 segmentEnd = vec3(u_position[stencilIndex].zw, z);

    float camScale = 1.0;
    vec3 normal = vec3(u_params[stencilIndex].yz, 0.0);

    vec3 dynamics = 0.25 * (normal * cos(a_speed * u_time) * a_position.x +
        vec3(0.0, 0.0, 1.0) * sin(a_speed * u_time) * a_position.z);

    // we use a manual lerp here instead of the mix() function because
    // the mix() impl on the S2/S3 screws up on position vectors
    float lerp = a_index / n;
    vec3 particle_position = lerp * segmentBegin + (1.0 - lerp) * segmentEnd + dynamics;

    float startTime = u_params[stencilIndex].w;
    float color_mix = min((u_time - startTime) / u_fadeTime, 1.0);
    v_color =  u_color * (1.0 - color_mix) + u_fadeColor * color_mix;

    // get billboard coordinate system
    vec3 billboard_offset = buildBillboardOffset(particle_position, 1.0);
    gl_Position = u_modelViewProject * vec4(particle_position + billboard_offset, 1.0);
  }
}

#endif

#ifdef FRAGMENT
void main() {
  gl_FragColor = defaultParticleFragment();
}
#endif

