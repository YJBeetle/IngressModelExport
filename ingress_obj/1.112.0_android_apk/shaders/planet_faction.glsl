// draws faction clouds on globe
#ifdef FRAGMENT
precision mediump float;
#endif

#pragma optimize full

varying vec4 v_texCoord0AndBlendAndIntensity;

#ifdef VERTEX
uniform mat4 u_modelViewProject;
uniform mat4 u_modelView;
uniform vec3 u_lightDir;
uniform vec2 u_shellSize;
attribute vec3 a_position;
attribute vec2 a_texCoord0;

void main() {
  const vec3 alienColor = vec3(0.168627451, 0.929411765, 0.105882353);
  const vec3 resistanceColor = vec3(0.0, 0.749019608, 1.0);
  gl_Position = u_modelViewProject * vec4(a_position * u_shellSize.x, 1.0);
  vec4 normal = u_modelView * vec4(a_position, 0.0);
  v_texCoord0AndBlendAndIntensity.xy = vec2(a_texCoord0.x, a_texCoord0.y);
  v_texCoord0AndBlendAndIntensity.z = u_shellSize.y;
  v_texCoord0AndBlendAndIntensity.w = clamp(dot(normal.xyz, u_lightDir), 0.1, 1.0);
}
#endif


#ifdef FRAGMENT
uniform sampler2D u_texture;
uniform sampler2D u_lut;

void main() {
  vec4 factionValues = texture2D(u_texture, v_texCoord0AndBlendAndIntensity.xy);
  vec4 mColor = texture2D(u_lut, vec2(factionValues.r, factionValues.g));
  gl_FragColor.rgb = mColor.rgb * v_texCoord0AndBlendAndIntensity.w;
  gl_FragColor.a = mColor.a * v_texCoord0AndBlendAndIntensity.z;
}
#endif

