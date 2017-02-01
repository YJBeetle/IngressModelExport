/**
  * Note that the maximum number of uniform vec4's we can use is 128, which is the minimum
  * supported by the OpenGL ES 2.0 spec; that is, 2 * SYSTEMS_PER_DRAW + N_COLORS +
  * 4 (MVP) + 1 (camera) must be equal to or less than 128
  */

#ifdef FRAGMENT
precision mediump float;
#endif

const vec3 xm_color = vec3(0.3789, 0.4648, 1.0);

varying vec2 v_texCoord0;
varying float v_alpha;

#ifdef VERTEX
#pragma optimize none

/* uniform array lengths set by ParticleEnergyGlobVisuals.SYSTEMS_PER_DRAW  */
uniform mat4 u_modelViewProject;
uniform vec2 u_scale;
uniform vec2 u_mapCenter;
uniform float u_timeSec;
uniform vec4 u_globParams[120];
attribute vec3 a_position;   // center of the particle shifted w/r/t system center
attribute vec2 a_texCoord0;  // the texture coordinate also provides vertex offsets
attribute float a_scale;     // size of each particle
attribute float a_speed;
attribute float a_portalIndex;
attribute float a_index;

const vec3 y_hat = vec3(0.0, 1.0, 0.0);

#define NUM_PARTICLES 3.0  // sync with ParticleEnergyGlobVisuals.NUM_PARTICLES
#define INV_NUM_PARTICLES (1.0 / NUM_PARTICLES)
#define TIME_MODULUS 30.0
#define INV_TIME_MODULUS (1.0 / TIME_MODULUS)
#define ALPHA_STEPS 128.0  // sync with ParticleEnergyGlobVisuals.ALPHA_STEPS
#define SPREAD 14.0
#define CAMSCALE_EXPONENT 0.125

void main() {
  // first, determine if we don't need to bother rendering this particle because its index
  // number plus the offset is greater than ParticleEnergyGlobVisuals.NUM_PARTICLES, or its
  // index number is less than the offset number, making it so that we render exactly
  // NUM_PARTICLES
  int portalIndex = int(a_portalIndex);
  float nOffset = u_globParams[portalIndex].w;

  // decide the number of particles we're going to render based on the distance from the player
  if (a_index >= NUM_PARTICLES + nOffset || a_index < nOffset) {
     // Set position outside of -1..1 clip space.
     gl_Position = vec4(2.0, 0.0, 0.0, 1.0);
  } else {
    vec3 position = vec3(u_globParams[portalIndex].x + u_mapCenter.x,
                         0.0, // set by ParticleEnergyGlobVisuals.PARTICLE_Y_ORIGIN
                         u_globParams[portalIndex].z + u_mapCenter.y);

    // NOTE: This code used to use fract() which might be higher performance but this causes
    // issues on Galaxy S4.  Once Galaxy S4 fixes its issues, we may want to revisit this shader.
    //
    // timeOffset is stored in the fractional component of w (stored in nOffset)
    float timeOffset = nOffset - floor(nOffset);
    float elapsedTime = timeOffset * TIME_MODULUS + u_timeSec;

    // t is a parametric variable in the range 0...TIME_MODULUS
    float t = mod(a_speed * elapsedTime, TIME_MODULUS);
    float tm = t * INV_TIME_MODULUS;

    // HOOVER STUFF
    // determine the integer component of y, the fractional component is the hoover fraction.
    v_alpha = floor(u_globParams[portalIndex].y);
    // subtract the integer component to isolate the fraction, the hoover fraction.
    float hoover = u_globParams[portalIndex].y - v_alpha;
    // normalize alpha
    v_alpha *= 1.0 / ALPHA_STEPS;
    // first compute the offset due to the hoover effect, if its active; we want to stream the
    // particles in so we need to delay it particle by particle
    float normIndex = (a_index - nOffset) * INV_NUM_PARTICLES;
    vec3 hooverDynamics = -position * min(1.0, hoover * (1.0 + normIndex));
    // END HOOVER STUFF

    // SPREAD is how far apart the particles should be from each other
    // use this for a "back and forth" motion
    vec3 dynamics = a_position * SPREAD * (-2.0 + 2.0 * tm - 4.0 * step(tm, 0.5) * (tm - 0.5));

    v_texCoord0 = a_texCoord0;

    gl_Position = u_modelViewProject * vec4(position + dynamics + hooverDynamics, 1.0);

    // compute billboard offsets
    float camScale = pow(gl_Position.z, CAMSCALE_EXPONENT);
    gl_Position.xy += u_scale * (a_texCoord0.xy - vec2(0.5)) * a_scale * camScale;
  }
}

#endif

#ifdef FRAGMENT
uniform sampler2D u_texture;

void main() {
  vec4 texture = texture2D(u_texture, v_texCoord0);

  // the texture r coordinate stores the extent of the colored particle "glow", while
  // texture b coordinate stores the particle white inner core. we additively blend the
  // core and the outer glow together to derive the total particle
  // bake in the color for the XM particle
#if 0
  // this code does not work properly on the PowerVR SGX540.
  // the problem is related to texture.bbb
  gl_FragColor = vec4(xm_color + texture.rrr, (texture.r + texture.b) * v_alpha);
#else
  gl_FragColor = vec4(xm_color.r + texture.r, xm_color.g + texture.r, xm_color.b + texture.r, (texture.r + texture.b) * v_alpha);
#endif
}
#endif

