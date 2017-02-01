// Billboard circular glow effect based on smoothstep function.
#ifdef FRAGMENT
precision mediump float;
#endif

varying vec2 v_texCoord;

#ifdef VERTEX
#pragma optimize full

uniform vec4 u_rect; // x, y, width, height
attribute vec2 a_position;
void main() {
  v_texCoord = a_position;
  vec2 pos = u_rect.xy + u_rect.zw * 0.5 * (a_position + vec2(1.0));
  gl_Position = vec4(pos, 0.0, 1.0);
}

#endif


#ifdef FRAGMENT

uniform vec4 u_color;
void main() {
  float glow = 1.0 - smoothstep(0.0, 1.0, length(v_texCoord));
  gl_FragColor = vec4(u_color.rgb, u_color.a * glow);
}

#endif
