// GENERATED FILE //
#ifndef GL_ES
#define lowp
#define mediump
#define highp
#endif
#ifdef GL_ES
precision mediump float;
#endif
varying vec2 v_texCoord0;
varying vec4 v_color;
const vec3 y_hat = vec3(0.0, 1.0, 0.0);
uniform sampler2D u_texture;
vec4 defaultParticleFragment() {
 vec4 texture = texture2D(u_texture, v_texCoord0);
 return vec4(v_color.xyz + texture.xxx, (texture.x + texture.z) * v_color.w);
}
varying float v_alpha;
void main() {
 vec4 texture = texture2D(u_texture, v_texCoord0);
 gl_FragColor = vec4(1.0, 0.0, 0.0, texture.w)
 + vec4(texture.z, texture.z, texture.z, texture.z);
}

