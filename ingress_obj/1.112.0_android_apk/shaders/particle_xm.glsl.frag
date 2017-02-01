// GENERATED FILE //
#ifndef GL_ES
#define lowp
#define mediump
#define highp
#endif
#ifdef GL_ES
precision mediump float;
#endif
const vec3 xm_color = vec3(0.3789, 0.4648, 1.0);
varying vec2 v_texCoord0;
varying float v_alpha;
uniform sampler2D u_texture;
void main() {
 vec4 texture = texture2D(u_texture, v_texCoord0);
 gl_FragColor = vec4(xm_color.r + texture.r, xm_color.g + texture.r, xm_color.b + texture.r, (texture.r + texture.b) * v_alpha);
}

