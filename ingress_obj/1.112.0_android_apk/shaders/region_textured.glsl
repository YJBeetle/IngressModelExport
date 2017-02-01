// Simple textured sprite that offsets the vertex coordinates to a region.
#ifdef FRAGMENT
precision mediump float;
#endif

#pragma optimize full

varying vec2 v_texCoord0;

#ifdef VERTEX
uniform mat4 u_modelViewProject;
uniform vec2 u_texCoordBase;
uniform vec2 u_texCoordExtent;
attribute vec3 a_position;
attribute vec2 a_texCoord0;

void main() {
  v_texCoord0 = a_texCoord0 * u_texCoordExtent + u_texCoordBase;
  gl_Position = u_modelViewProject * vec4(a_position, 1.0);
}
#endif

#ifdef FRAGMENT
uniform sampler2D u_texture;
uniform vec4 u_color;

void main() {
  gl_FragColor = texture2D(u_texture, v_texCoord0) * u_color;
}
#endif

