#ifdef FRAGMENT
precision mediump float;
#endif

#pragma optimize full

#include "shield_common.glh"

uniform sampler2D u_holeNoiseTexture;
uniform vec3 u_holeNormal; // xyz = normal
uniform vec3 u_holeTangentX; // xyz = tangent normal
uniform vec3 u_holeTangentY; // xyz = tangent normal
uniform vec2 u_AngleAndPerturbFactor; // x = radians animation, y = perturb factor

varying vec3 v_perturbCoordAndAngle;

#ifdef VERTEX
attribute vec3 a_position;
attribute vec3 a_normal;
attribute vec2 a_texCoord0;

void main() {
  v_texCoord0 = a_texCoord0;
  gl_Position = u_modelViewProject * vec4(a_position, 0.85);

  // Project normal onto the hole normal coordinate system.
  vec3 normal = a_normal;
  vec3 holeNormal = u_holeNormal;
  vec3 holeTangentX = u_holeTangentX;
  vec3 holeTangentY = u_holeTangentY;
  vec3 normalProjX = dot(normal, holeTangentX) * holeTangentX;
  vec3 normalProjY = dot(normal, holeTangentY) * holeTangentY;
  // We also need to know the directions relative to the hole coordinate system.
  vec2 signs = vec2(dot(normalProjX, holeTangentX), dot(normalProjY, holeTangentY));
  signs = sign(signs);
  // holeEdgeXY is the x,y coordinates of a circle that goes through this point. The circle is
  // aligned with the holeNormal.
  vec2 holeEdgeXY = signs * vec2(length(normalProjX), length(normalProjY));
  // holeEdgePos2Pi goes from -PI to PI, based on our position in the circle.
  float holeEdgePos2Pi = atan(holeEdgeXY.y, holeEdgeXY.x);
  float angleHoleCenterToMe = acos(dot(normal, holeNormal));
  v_perturbCoordAndAngle = vec3(holeEdgePos2Pi * (0.5 / PI),
      angleHoleCenterToMe * (1.0 / PI), angleHoleCenterToMe);
}
#endif

#ifdef FRAGMENT
vec4 computeShieldColor() {
  // Lookup in the noise texture to find how much we should perturb the circle edge.
  // The x coordinate is our position on the circle, the y coordinate is the angular distance
  // from the hole normal.
  float peelAnglePerturb = texture2D(u_holeNoiseTexture, v_perturbCoordAndAngle.xy).a;
  peelAnglePerturb *= u_AngleAndPerturbFactor.y;
  // peelAngle is the angular distance from the hole normal that is on the edge of the hole.
  float peelAngle = u_AngleAndPerturbFactor.x + peelAnglePerturb;
  // peelAngleOffset: offset from hole edge angle to our angular distance from the hole normal.
  float peelAngleOffset = v_perturbCoordAndAngle.z - peelAngle;
  // The original shield texture is gone as the hole edge passes.
  float shieldTexFactor = step(0.0, peelAngleOffset);
  // 0..peelRadius maps to 0..1 (0 means color is redTint, 1 means color is unchanged)
  float peel01 = (1.0 / peelRadius) * peelAngleOffset;
  float peelFactor = clamp(peel01 * peel01, 0.0, 1.0);

  // Combine for the final shield color.
  vec4 outColor = getShieldColor(redTint.rgb);
  vec4 shieldColor = vec4(outColor.rgb, shieldTexFactor * outColor.a);
  vec4 finalColor = mix(peelColor, shieldColor, peelFactor);
  return vec4(finalColor.rgb, finalColor.a * u_contributionsAndAlpha.z);
}

void main() {
  gl_FragColor = computeShieldColor();
}
#endif

