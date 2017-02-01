/**
* Create the shaders. These interpolate between uniform positions for each
* vertex, so that the mesh need not change when endpoints move.
*
* The complexity is mostly creating coherent movement along a strip, with
* disorganized movement across strips.
*
* TODO(leorleor): Get or make a better texture.  Like a grayscale, then tint by team as well.
*/
#ifdef FRAGMENT
precision mediump float;
#endif

varying float v_alpha;
varying vec2 v_texCoord0;

#ifdef VERTEX
// uniform attributes
uniform mat4 u_modelViewProject;
// The attack is from map coordinates xz0 to xz1
uniform vec2 u_xz0;
uniform vec2 u_xz1;

// The current time in seconds
uniform float u_time;

// vertex attributes
attribute vec3 v_interps;

void main() {
  // Values that increase from 0 to 1 per strip/row/edge (aka interpolators, alphas).
  float stripA = v_interps.x;
  float rowA = v_interps.y;
  float edgeA = v_interps.z;

  // The from height of 2 looks good whenfrom portals.
  // The to height of 3.2 looks good when to players.
  vec3 u_pos0 = vec3(u_xz0, 1.0).xzy;
  vec3 u_pos1 = vec3(u_xz1, 3.2).xzy;

  // A sawtooth wave with a slope that varies over both strips and time.
  // This makes multiple strips move independently, sans patterns.
  // The sawtooth slope changes every randStep seconds
  float randStep = 1.0;
  // The sawtooth goes from 0 to 1 every randCount * step.
  float randCount = 3.0;

  // A "random" 0 to 1 value is consistently calculated for the current and next time step.
  // The slope between these random values also varies randomly.
  // This gives a different random slope each time step.
  float randTime = (u_time / randStep) + stripA + 5.0;
  float time0 = floor(randTime);
  float time1 = time0 + 1.0;
  vec2 time = vec2(time0, time1);
  vec2 rand = fract(time * time * time / (31.415926 + stripA));

  // Divide the 0 to 1 transition across multiple time steps.
  rand = (rand + mod(time + randCount * stripA, randCount)) / randCount;
  rand.y = rand.y + step(rand.y, rand.x);

  // Interpolate between the changing slopes
  float randA = (randTime - time0) / (time1 - time0);
  float timeA = fract(mix(rand.x, rand.y, randA));

  vec3 axis = u_pos1 - u_pos0;
  float axisL = length(axis);
  axis = axis * 1.0 / axisL;
  // Shortcut for horizontal tangent calc: tangent = norm(cross(axis,up))
  vec3 tangent = normalize(vec3(-axis.z, 0.0, axis.x));

  // The scale of the strip widths in meters.
  float widthL = 10.0;
  // To give the strip width, move the 2 edges tangent to axis in different directions.
  // To give the strip a pear profile, vary strip width across rows.
  float widthA = (0.5 - edgeA) * min(0.67 + 0.33 * rowA, 1.33 - 0.67 * rowA);
  vec3 width = tangent * widthA * widthL;

  // To make the strip move, add a vector tangent to the axis (same direction for each edge).
  float wanderL = 4.0 * min(rowA * rowA + 0.05 , 2.2 - 2.0 * rowA);
  float wanderA = fract(timeA);
  wanderA = fract(timeA + 1.0 - rowA);
  wanderA = 1.0 - (wanderA  * wanderA * wanderA);
  wanderA = (min(wanderA, 1.0 - wanderA) - 0.25) * 4.0;
  wanderA = clamp(wanderA, -0.81, 0.81) + 2.0 * (stripA - 0.5);
  vec3 wander = tangent * wanderL * wanderA;

  // The altitude is an upside down x^2 parabola, so the strip arcs into the air.
  float arcL = 4.0 * log(1.0 + 0.1 * axisL);
  float arcH = 2.0 * rowA - 1.0;
  float arc = arcL * (1.0 - arcH * arcH);

  vec3 pos = mix(u_pos0, u_pos1, rowA) + width + wander;
  pos.y = pos.y + arc;
  gl_Position = u_modelViewProject * vec4(pos, 1.0);

  // The commented code is to use v_color instead of v_alpha and u_color.
  // Not using now because it does 4 per-pixel interps instead of 1.
  // Left comments so you could see, then will delete.
  v_alpha = min(1.0, 25.0 * min(rowA, 1.0 - rowA));
  // Strobe strips.  Per Dennis, to make them look like tesla bolts instead vs plasma.
  v_alpha = v_alpha * step(0.25, mod(timeA + stripA, 0.5));

  // The texture is scaled to match axis length to maintain aspect ratio (width is constant).
  // The 0.9 exponent makes it look better when axis is long, perhaps compensates for the arc.
  v_texCoord0 = vec2(rowA * (pow(axisL, 0.9) / 12.0) - timeA, edgeA);
}
#endif

#ifdef FRAGMENT
uniform sampler2D u_texture;
void main() {
  vec4 attackTexture = texture2D(u_texture, v_texCoord0);
  gl_FragColor = vec4(attackTexture.rgb, attackTexture.a * v_alpha)
  //  * 0.67 + 0.33 * vec4(1.0, 0.1, 0.1, 1.0) // Uncomment to debug the geometry
  ;
  // Uncomment for awesome debug gridlines
  // gl_FragColor.g = step(0.2, fract(10.0 * v_texCoord0.x));
  // gl_FragColor.b = step(0.2, fract(10.0 * v_texCoord0.y));
}
#endif

