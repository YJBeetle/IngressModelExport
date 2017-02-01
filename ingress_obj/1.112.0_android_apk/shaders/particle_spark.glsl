// Shader for finger tracking sparks in glyph game.

#ifdef FRAGMENT
precision mediump float;
#endif

#include "particle_common.glh"

#ifdef VERTEX
#pragma optimize none

uniform vec4 u_color;
uniform float u_scale;
uniform float u_time;
uniform float u_timescale;
uniform float u_trails;
uniform vec3 u_position;
attribute float a_lifetime;
attribute float a_radius;
attribute float a_angle;
attribute float a_trailIndex;

/* This shader is driven by com.nianticproject.ingress.common.minigames.glyphs.
   GlyphTouchParticleVisuals. Please refer to that file for documentation on how
   it works. */
void main() {
  float time = clamp(u_time, 0.0, a_lifetime);
  float frac = 1.0 - mod(time * u_timescale, a_lifetime) / a_lifetime;
  float radius = a_radius * u_scale;
  float distance = radius * frac + clamp(a_scale * 0.1 * a_trailIndex, 0.0, radius);
  float angle = a_angle + a_radius * floor(time / a_lifetime);
  vec3 particle_position = a_position + u_position +
      vec3(distance * cos(angle), distance * sin(angle), -1);

  v_color.rgb = u_color.rgb;
  float fade = 1.0 - 1.0 / u_trails * (a_trailIndex + 1.0);
  v_color.a = (u_color.a - fade) * sqrt(1.0 - frac);

  vec3 billboard_offset = buildBillboardOffset(particle_position, 1.0);
  gl_Position = u_modelViewProject * vec4(particle_position + billboard_offset, 1.0);
}

#endif

#ifdef FRAGMENT
void main() {
  gl_FragColor = defaultParticleFragment();
}
#endif

