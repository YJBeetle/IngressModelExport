#ifdef FRAGMENT
precision mediump float;
#endif

#include "shield_common.glh"

uniform vec4 u_waveColor;
uniform vec4 u_xmpCenterAndAnimation; // xyz = point, w = radius animation
uniform float u_waveIntensity;

varying vec3 v_position;

#ifdef VERTEX
#pragma optimize full

attribute vec3 a_position;
attribute vec3 a_normal;
attribute vec2 a_texCoord0;

void main() {
  v_texCoord0 = a_texCoord0;
  v_position = a_position;
  gl_Position = u_modelViewProject * vec4(a_position, 0.85);
}
#endif

#ifdef FRAGMENT
vec4 computeShieldColor() {
  // Compute wave color-change effect contribution.
  vec3 xmpToSurface = v_position - u_xmpCenterAndAnimation.xyz;
  float distToCenter = length(xmpToSurface);
  float toWavefront = u_xmpCenterAndAnimation.w - distToCenter;
  // redFactor is 0 until the blast wavefront passes this point, then 1:
  //float redFactor = step(0.0, toWavefront) * u_waveIntensity; // GN driver BUG
  //float redFactor = (float(toWavefront > 0.0)) * u_waveIntensity; // GN driver BUG
  //float redFactor = step(distToCenter, u_xmpCenterAndAnimation.w) * u_waveIntensity; // OK
  float redFactor = (toWavefront > 0.0 ? 1.0 : 0.0) * u_waveIntensity; // OK

  // Compute wave-front contribution.
  // 0..wavefrontRadius maps to 0..1 (0 means color is redColor, 1 means color is unchanged)
  float waveFactor = clamp((1.0 / wavefrontRadius) * abs(toWavefront), 0.0, 1.0);

  // Combine for the final shield color.
  vec3 shieldColor = mix(u_color.rgb, u_waveColor.rgb, redFactor);
  vec4 shieldTexColor = getShieldColor(shieldColor);
  vec4 finalColor = mix(u_waveColor, shieldTexColor, waveFactor);
  return vec4(finalColor.rgb, finalColor.a * u_contributionsAndAlpha.z);
}

void main() {
  gl_FragColor = computeShieldColor();
}
#endif

