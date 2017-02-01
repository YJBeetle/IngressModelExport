// GDX sprite shader (see CustomShaderDrawable) that replaces a given color channel with
// a uniform color. The uniform color is mixed in based on the channel value from the texture.
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
uniform vec4 u_replaceColor;
uniform int u_replaceChannel; // 0, 1, 2 or 3 corresponds with r, g, b, a

void main()
{
  LOWP vec4 tex = texture2D(u_texture, v_texCoords);
#if 0
  //
  // This method doesn't work on some drivers! The shader compiles, but renders garbage.
  //

  // Pull out replacement factor from channel.
  float replaceFactor = tex[u_replaceChannel];
  // Set replaced channel in texture back to 0.
  tex[u_replaceChannel] = 0.0;
#else
  // Pull out replacement factor from red channel.
  float replaceFactor = tex.r;
  // Set red channel in texture back to 0.
  tex = vec4(0.0, tex.gba);
#endif

  // Texture alpha always contributes to final alpha in case replacement color needs to fade out
  // into transparency.
  vec4 replaceColor = vec4(u_replaceColor.rgb, tex.a * u_replaceColor.a);

  vec4 newColor = mix(tex, replaceColor, replaceFactor);
  gl_FragColor = v_color * newColor;
}

#endif
