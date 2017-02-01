// The swirly XM stuff, such as the inner part of a resonator.
#ifdef FRAGMENT
precision mediump float;
#endif

#pragma optimize full

varying vec4 v_texCoord0And1;

#ifdef VERTEX
uniform mat4 u_modelViewProject;
uniform float u_elapsedTime;
attribute vec3 a_position;  // {x,y,z}
attribute vec2 a_texCoord0; // {u,v}
void main() {
  // Compute two texture coordinates xy and zw with different animated offsets for y and w.
  // Slightly scale the second coordinate pair to increase the appearance of randomness
  // when textures are blended together.
  v_texCoord0And1 = vec4(a_texCoord0, a_texCoord0 * 1.35);
  v_texCoord0And1 += vec4(0, u_elapsedTime * 0.6, u_elapsedTime * 0.6, u_elapsedTime * 0.45);
  gl_Position = u_modelViewProject * vec4(a_position.xyz, 1.0);
}
#endif

#ifdef FRAGMENT
uniform sampler2D u_texture;
uniform vec4 u_teamColor; // {color RGBA}
uniform vec4 u_altColor;  // {color RGBA}
void main() {
  vec4 base = texture2D(u_texture, v_texCoord0And1.xy);
  vec4 scrolled = texture2D(u_texture, v_texCoord0And1.zw * 1.35);
  float blend_mask = ((base.g * scrolled.g) + (base.r * scrolled.r)) * 2.0;
  // create a 2-hue blend with some color shift adjustment
  vec4 colorTint = mix(u_altColor, u_teamColor, blend_mask - 0.25);
  // 'linear burn' blending between target color and blend mask
  gl_FragColor = colorTint + vec4(blend_mask) - vec4(1.0);
  gl_FragColor.a = u_teamColor.a;
}
#endif

