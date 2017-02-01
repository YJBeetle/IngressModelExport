// GENERATED FILE //
#ifndef GL_ES
#define lowp
#define mediump
#define highp
#endif
#ifdef GL_ES
precision mediump float;
#endif
varying vec3 v_texCoord0;
varying vec4 v_color;
void main() {
 float v = v_texCoord0.y;
 gl_FragColor.rgb = v_color.rgb +
 vec3(1.0) * (5. * (v - 0.6) * step(0.6, v) + 10. *(0.8 - v) * step(0.8, v));
 gl_FragColor.a = v_color.a * (0.66 + 0.33*sin(v_texCoord0.z)) *
 (v + smoothstep(0.79, 0.81, v) * 6.0*(1.0 - v));
}

