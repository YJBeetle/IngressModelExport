// GENERATED FILE //
#ifndef GL_ES
#define lowp
#define mediump
#define highp
#endif
#ifdef GL_ES
precision mediump float;
#endif
varying lowp vec4 v_color;
varying vec2 v_texCoords;
uniform sampler2D u_texture;
void main()
{
 lowp vec4 tex = texture2D(u_texture, v_texCoords);
 gl_FragColor = v_color;
 gl_FragColor.a *= tex.a;
}

