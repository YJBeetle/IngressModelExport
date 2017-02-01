// Renders a wavy swoosh effect (meant for triangle strips).
#ifdef FRAGMENT
precision mediump float;
#endif

#pragma optimize none

varying vec3 v_texCoord0;  // TODO(nkanodia): Change to vec2, rename.
varying vec4 v_color;

#ifdef VERTEX
uniform mat4 u_modelViewProject;
uniform vec3 u_cameraFwd;
uniform float u_elapsedTime;
uniform float u_alpha;
uniform vec4 u_color;           // {color RGBA}
attribute vec4 a_position;      // {x,y,z, final height}
attribute vec4 a_texCoord0;     // {u,v, normalXZ}
void main() {
  // In order to pack data more tightly, we omit the Y component of the normal.  In the case
  // that the XZ components are zero, the normalize will re-construct <0,1,0>, otherwise the
  // small value in Y will not significantly change the normal's direction.
  vec3 normal = normalize(vec3(a_texCoord0.z, .001, a_texCoord0.w));
  v_texCoord0.xy = a_texCoord0.xy;
  v_color = u_color;

  // Alpha out the geometry when the normal is perpendicular to the view direction,
  // use an ease curve to make the transitions a little nicer (push closer to 1 or 0
  // when the value is near 1 or 0)
  float alpha = clamp(abs(dot(normal, u_cameraFwd)), 0.5, 1.0);
  v_color.a *= (3.0 * alpha * alpha) - (2.0 * alpha * alpha * alpha);

  // modify alpha by the global modifier
  v_color.a *= u_alpha;

  // use the vertex shader to precompute and stash components for "shimmer" animation
  v_texCoord0.z = 5.0 * v_texCoord0.x + 25.0 * u_elapsedTime;

  // use the vertex shader to transition from the fully wavy state to the normal link shape
  gl_Position = u_modelViewProject * vec4(a_position.x,
      u_elapsedTime * a_position.y + (1.0 - u_elapsedTime) * a_position.w,
      a_position.z, 1.0);
}
#endif

#ifdef FRAGMENT
void main() {
  float v = v_texCoord0.y; // texture v coordinate
  gl_FragColor.rgb = v_color.rgb +
      vec3(1.0) * (5. * (v - 0.6) * step(0.6, v) + 10. *(0.8 - v) * step(0.8, v));
  gl_FragColor.a = v_color.a * (0.66 + 0.33*sin(v_texCoord0.z)) *
      (v + smoothstep(0.79, 0.81, v) * 6.0*(1.0 - v));
}
#endif
