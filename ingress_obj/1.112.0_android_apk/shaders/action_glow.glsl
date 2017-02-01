// Billboard circular glow effect based on smoothstep function.
#ifdef FRAGMENT
precision mediump float;
#endif

#define PI 3.1415926535897932384626433832795

varying vec2 v_billboardCoords;

#ifdef VERTEX
#pragma optimize full

uniform vec4 u_rect; // x, y, width, height
attribute vec2 a_position;

void main() {
  // Convert from -1..1 to 0..1
  vec2 billboardCoords = 0.5 * (a_position + vec2(1.0));

  // Compute billboard vertex positions.
  v_billboardCoords.xy = a_position;
  vec2 pos = u_rect.xy + u_rect.zw * billboardCoords;
  gl_Position = vec4(pos, 0.0, 1.0);
}

#endif


#ifdef FRAGMENT

uniform vec2 u_yCuttoff; // fade out visual between these y coordinates 0,0 does no cutoff
uniform vec4 u_color;
void main() {
  float glow = smoothstep(1.0, 0.0, length(v_billboardCoords.xy));
  glow *= 1.0 - smoothstep(u_yCuttoff.x, u_yCuttoff.y, v_billboardCoords.y);
  // TODO(nkanodia): Add a gradient texture to allow for greater customization.
  gl_FragColor = vec4(u_color.rgb, u_color.a * glow);
}

#endif
