// GDX sprite shader that outputs v_color with alpha modulated by the texture's alpha channel. 
#ifdef FRAGMENT
#define LOWP lowp
precision mediump float;
#else
#define LOWP
#endif

#pragma optimize none

varying LOWP vec4 v_color;
varying vec2 v_texCoords;


#ifdef VERTEX

attribute vec2 a_position;
attribute vec4 a_color;
attribute vec2 a_texCoord0;
uniform mat4 u_projTrans;

void main()
{
  v_color = a_color;
  v_texCoords = a_texCoord0;
  gl_Position =  u_projTrans * vec4(a_position, 0.0, 1.0);
}

#endif


#ifdef FRAGMENT

uniform sampler2D u_texture;

void main()
{
  LOWP vec4 tex = texture2D(u_texture, v_texCoords);
  gl_FragColor = v_color;
  gl_FragColor.a *= tex.a;
}

#endif
