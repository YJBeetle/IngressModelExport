// GENERATED FILE //
#ifndef GL_ES
#define lowp
#define mediump
#define highp
#endif
#ifdef GL_ES
precision mediump float;
#endif
uniform sampler2D u_texture;
uniform float u_rampTarget;
uniform float u_alpha;
vec4 computePortalColor(vec2 texCoords) {
 vec4 tex = texture2D(u_texture, texCoords);
 float t = 1.0 - min(1.0, abs(tex.r - u_rampTarget) * 5.0);
 float c_max = tex.g;
 return vec4(tex.bbb * (1.3 + c_max * t), tex.a * u_alpha);
}
varying vec2 v_texCoord0;
uniform vec4 u_baseColor;
void main() {
 gl_FragColor = u_baseColor * computePortalColor(v_texCoord0);
}

