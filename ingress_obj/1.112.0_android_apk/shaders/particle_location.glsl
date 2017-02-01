/**
  * Note that the maximum number of uniform vec4's we can use is 128, which is the minimum
  * supported by the OpenGL ES 2.0 spec; that is, 2 * SYSTEMS_PER_DRAW + N_COLORS +
  * 4 (MVP) + 1 (camera) must be equal to or less than 128
  */

#ifdef FRAGMENT
precision mediump float;
#endif

#include "particle_common.glh"

varying float v_alpha;

#ifdef VERTEX
#pragma optimize none

/* uniform array lengths set by ParticleEnergyGlobVisuals.SYSTEMS_PER_DRAW  */
uniform vec2 u_globParams[120];

const float CAMSCALE_EXPONENT = 0.25; // set by ParticleEnergyGlobVisuals.CAMSCALE_EXPONENT

void main() {
  int portalIndex = int(a_position.z);
  vec3 position = vec3(u_globParams[portalIndex].x,
                       0.0,
                       u_globParams[portalIndex].y);

  vec3 camVec = position - u_cameraPos;
  vec3 camVecNorm = normalize(camVec);
  float camScale = pow(length(camVec), CAMSCALE_EXPONENT);

  // get billboard coordinate system
  vec3 right = cross(camVecNorm, y_hat);
  vec3 up = cross(right, camVecNorm);

  // adjust right and up vectors for scale
  vec2 scales = (a_position.xy - vec2(0.5)) * camScale;
  right = right * scales.x;
  up = up * scales.y;

  v_texCoord0 = a_position.xy;
  gl_Position = u_modelViewProject * vec4(position + up + right, 1.0);
}

#endif

#ifdef FRAGMENT
void main() {
  vec4 texture = texture2D(u_texture, v_texCoord0);
  gl_FragColor = vec4(1.0, 0.0, 0.0, texture.w)
       + vec4(texture.z, texture.z, texture.z, texture.z);
}
#endif

