// Tints (all channels of) texture with u_color
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
uniform vec4 u_color;
uniform sampler2D u_texture;

void main() {
  gl_FragColor = u_color * texture2D(u_texture, v_texCoord0);
}
#endif
