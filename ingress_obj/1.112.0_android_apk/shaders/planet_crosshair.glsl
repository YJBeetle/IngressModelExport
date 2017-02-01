// draws faction clouds on globe
#ifdef FRAGMENT
precision mediump float;
#endif

#pragma optimize full

varying vec2 v_texCoord0;

#ifdef VERTEX
uniform mat4 u_modelViewProject;
uniform vec4 u_texScaleAndBias;
attribute vec3 a_position;
attribute vec2 a_texCoord0;
void main() {
  v_texCoord0 = a_texCoord0 * u_texScaleAndBias.xy + u_texScaleAndBias.zw;
  gl_Position = u_modelViewProject * vec4(a_position, 1.0);
  // Clamping x and y by with w so that the vertices that lie outside the screen
  // are brought back to the screen clipping boundary.
  // This allows us the stretch the texture mapping of the crosshair axis all the
  // way across the screen.
  gl_Position.xy = clamp(gl_Position.xy, -gl_Position.w, gl_Position.w);
}
#endif

#ifdef FRAGMENT
uniform vec4 u_color;
uniform sampler2D u_texture;
uniform vec2 u_options;
void main() {
  gl_FragColor = u_color * texture2D(u_texture, v_texCoord0);
}
#endif

