// GENERATED FILE //
#ifndef GL_ES
#define lowp
#define mediump
#define highp
#endif
#ifdef GL_ES
precision mediump float;
#endif
varying float v_alpha;
varying vec2 v_texCoord0;
uniform sampler2D u_texture;
void main() {
 vec4 attackTexture = texture2D(u_texture, v_texCoord0);
 gl_FragColor = vec4(attackTexture.rgb, attackTexture.a * v_alpha)
 ;
}

