// GENERATED FILE //
#ifndef GL_ES
#define lowp
#define mediump
#define highp
#endif
#ifdef GL_ES
precision mediump float;
#endif
varying vec2 v_texCoord;
uniform vec4 u_color;
void main() {
 float glow = 1.0 - smoothstep(0.0, 1.0, length(v_texCoord));
 gl_FragColor = vec4(u_color.rgb, u_color.a * glow);
}

