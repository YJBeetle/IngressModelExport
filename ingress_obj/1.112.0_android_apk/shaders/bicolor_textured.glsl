// Blends texture with 2 colors, mixed by the alpha of the
// texture. The texture color peaks at alpha=0.5, u_color0
// peaks at alpha=0.0. If alpha is greater than 0.5, then
// the texture color is multiplied by u_color1, with
// progressively higher saturation from alpha=0.5 to full
// saturation at alpha=1.0.
// u_color0's alpha is used for all output colors except where
// u_color1 contributes as defined above.
#ifdef FRAGMENT
precision mediump float;
#endif

#pragma optimize full

varying vec2 v_texCoord0;

#ifdef VERTEX
uniform mat4 u_modelViewProject;
attribute vec3 a_position;
attribute vec2 a_texCoord0;

void main() {
  v_texCoord0 = a_texCoord0;
  gl_Position = u_modelViewProject * vec4(a_position, 1.0);
}
#endif

#ifdef FRAGMENT
uniform vec4 u_color0;
uniform vec4 u_color1;
uniform sampler2D u_texture;

void main() {
  vec4 sampled = texture2D(u_texture, v_texCoord0);
  vec4 mixed = mix(u_color0, vec4(sampled.xyz, u_color0.a), 2.0 * clamp(sampled.w, 0.0, 0.5));
  vec4 desaturated = mix(vec4(1.0), u_color1, 2.0 * (clamp(sampled.w, 0.5, 1.0) - 0.5));
  gl_FragColor = mixed * desaturated;
}
#endif

