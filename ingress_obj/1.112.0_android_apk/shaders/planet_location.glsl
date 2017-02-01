/**
* These shaders implement the rendering of the planet, along with the lat/lon grid and the
* pulsing location beacon.
* The planet rendering consists in a high resolution texture map of the country borders and
* coastlines that's represented as distance fields. We use the distance fields to smooth the
* border outlines and render a glow effect around them.
* Both the glow effect and the borders width is adjusting dynamically, function of the zoom
* level to give a sharp appearance at all times.
*
* The lat/lon grid is rendered by using a lookup texture.  If you want to change the thickness
* of the lines, you'll need to edit the texture.  If you want to keep the line width constant
* as you zoom in, you could use the derivatives of the texture coordinates to estimate how far
* zoomed you are, and threshold the texture value (or custom author mipmaps).
*
* The pulsing location beacon consist in an oscillating cosine wave with a solid center point.
* To make the cosine wave more sharp, we saturate the cosine function and clamp it to [-1 +1]
* The pulsing wave fades out with the distance from the beacon location.
* In order to render a circular beacon based on texture coordinates regardless of location,
* we need to compensate with the texture's aspect ratio as well as the texture mapping
* anisotropy. Without it the beacon would become oval with latitudes.
* Also as a result, the rendering of the beacon will work pretty well between 70 degrees of
* latitude. Beyond that the beacon loses its circular shape due to extreme projection
* anisotropy.
*/
#ifdef FRAGMENT
precision mediump float;
#endif

#pragma optimize full

varying vec2 v_texCoord0;
varying vec4 v_pulseVals;
varying vec4 v_pulseColorAndTime;

#ifdef VERTEX
uniform mat4 u_modelViewProject;
uniform mat4 u_modelView;
uniform vec2 u_myLocation;
uniform vec2 u_pulseTimeAndViewScale;
uniform vec3 u_lightDir;
attribute vec3 a_position;
attribute vec2 a_texCoord0;

void main() {
  const float pi = 3.14159265;
  // precisionMultipler and pulseRadiusMultiplier are tied together, a change
  // in one necessitates a change in the other.
  const float precisionMultiplier = 100.0;
  const float pulseRadiusMultiplier = 2.0;
  // pre-multiply the textureAspectRatio by the precisionMultiplier to save cycles later.
  const float textureAspectRatio = 0.5 * precisionMultiplier;
  const vec3 pulseColor = vec3(1.0, 0.5, 0.0);
  gl_Position = u_modelViewProject * vec4(a_position, 1.0);
  vec4 normal = u_modelView * vec4(a_position, 0.0);
  // Clamp the illumination intensity so that the Earth has a little bit of ambient lighting
  float intensity = clamp(dot(normal.xyz, u_lightDir), 0.1, 1.0);
  v_pulseColorAndTime.rgb = pulseColor * intensity;
  v_pulseColorAndTime.a = u_pulseTimeAndViewScale.x;
  v_texCoord0 = a_texCoord0;
  float projectionAnisotropy = cos((v_texCoord0.y - 0.5) * pi) * precisionMultiplier;
  v_pulseVals.xy = (v_texCoord0 - u_myLocation) * vec2(projectionAnisotropy, textureAspectRatio);
  v_pulseVals.z = pulseRadiusMultiplier * u_pulseTimeAndViewScale.y;
  v_pulseVals.w = v_pulseVals.z * v_pulseVals.z;
}
#endif

#ifdef FRAGMENT
// TODO(dkornmann): See if some variables can be computed per vertex instead of per fragment.
// TODO(dkornmann): We may want to consider rendering the location beacon as a separate fragment
// shader, should performance become an issue.

vec4 applyMyLocation() {
  const float pulseOffset = -0.3;
  const float pulseAmplitude = 1.7;
  const float pulseRipples = 4.0;
  const float twoPi = 6.2831853;
  const vec4 transparentColor = vec4(0.0, 0.0, 0.0, 0.0);
  vec2 pulseVal = v_pulseVals.xy;
  float pulseRadius = v_pulseVals.z;
  float len2 = dot(pulseVal, pulseVal);
  //   Dismiss the few pixels in the ROI that are not within range of the target location
  //   Also saves a few sqrt() computations...
  if (len2 > v_pulseVals.w) {
    return transparentColor;
  }
  float len = sqrt(len2);
  float factor = 1.0 - len / pulseRadius;
  float pulseStrength = 1.0;
  //   Render the first 20% of the beacon solid, animate the rest with a fading oscillation.
  if (len > 0.2 * pulseRadius) {
    float rippleOscillation = cos((pulseRipples * factor + v_pulseColorAndTime.a) * twoPi);
  //     At this point the oscillation will cause the pulse to vary positively and negatively. We need
  //     to clamp is so that we can normalize it. The pulse offset is used to control the width and
  //     asymmetry of the oscillations.
    float wave = clamp(pulseOffset + pulseAmplitude * rippleOscillation, -1.0, 1.0);
    pulseStrength = (wave + 1.0) * 0.5;
  }
  return vec4(v_pulseColorAndTime.rgb * pulseStrength, factor);
}
void main() {
  gl_FragColor = applyMyLocation();
}
#endif

