// GENERATED FILE //
#ifndef GL_ES
#define lowp
#define mediump
#define highp
#endif
#ifdef GL_ES
precision mediump float;
#endif
uniform sampler2D u_texture;
uniform vec4 u_color;
uniform vec2 u_rampTargetInvWidth;
uniform vec3 u_contributionsAndAlpha;
uniform mat4 u_modelViewProject;
varying vec2 v_texCoord0;
const float wavefrontRadius = 0.3;
const float peelRadius = 0.15;
const vec4 redTint = vec4(0.93, 0.11, 0.14, 0.6);
const vec4 peelColor = vec4(1.0, 1.0, 1.0, 1.0);
vec4 getShieldColor(vec3 shieldColor) {
 float rampTarget = u_rampTargetInvWidth.x;
 float rampWidth = u_rampTargetInvWidth.y;
 vec4 tex = texture2D(u_texture, v_texCoord0);
 float levelMultiplier = dot(u_contributionsAndAlpha.xy, tex.rg);
 float x = (tex.b - rampTarget) * rampWidth;
 float t = min(1.0, abs(x));
 const float opacityOffset = 0.35;
 vec3 outColor = vec3(shieldColor * (tex.a + 0.75));
 float alpha = (t > 0.5) ? tex.a : (t + opacityOffset) * levelMultiplier;
 return vec4(outColor, alpha);
}
uniform vec4 u_waveColor;
uniform vec4 u_xmpCenterAndAnimation;
uniform float u_waveIntensity;
varying vec3 v_position;
vec4 computeShieldColor() {
 vec3 xmpToSurface = v_position - u_xmpCenterAndAnimation.xyz;
 float distToCenter = length(xmpToSurface);
 float toWavefront = u_xmpCenterAndAnimation.w - distToCenter;
 float redFactor = (toWavefront > 0.0 ? 1.0 : 0.0) * u_waveIntensity;
 float waveFactor = clamp((1.0 / wavefrontRadius) * abs(toWavefront), 0.0, 1.0);
 vec3 shieldColor = mix(u_color.rgb, u_waveColor.rgb, redFactor);
 vec4 shieldTexColor = getShieldColor(shieldColor);
 vec4 finalColor = mix(u_waveColor, shieldTexColor, waveFactor);
 return vec4(finalColor.rgb, finalColor.a * u_contributionsAndAlpha.z);
}
void main() {
 gl_FragColor = computeShieldColor();
}

