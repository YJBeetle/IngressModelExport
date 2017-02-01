// GENERATED FILE //
#ifndef GL_ES
#define lowp
#define mediump
#define highp
#endif
#ifdef GL_ES
precision mediump float;
#endif
varying vec2 v_billboardCoords;
uniform vec2 u_yCuttoff;
uniform vec4 u_color;
void main() {
 float glow = smoothstep(1.0, 0.0, length(v_billboardCoords.xy));
 glow *= 1.0 - smoothstep(u_yCuttoff.x, u_yCuttoff.y, v_billboardCoords.y);
 gl_FragColor = vec4(u_color.rgb, u_color.a * glow);
}

