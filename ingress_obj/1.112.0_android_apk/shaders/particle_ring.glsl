#ifdef FRAGMENT
precision mediump float;
#endif

#include "particle_common.glh"

#ifdef VERTEX

uniform vec4 u_color;
uniform vec4 u_position;
uniform vec4 u_params;
// The tendency for arbitrary particles to resist convergence. If non-zero, different particles
// will converge (or even diverge) during the middle of the animation spline.
uniform float u_counterSpread;
// The tilt of the system off of the xz plane, split into cos/sin.
uniform vec2 u_tiltCosSin;
// The number of subsystems, distributed evenly by rotation around the y-axis. Only visually
// apparent if u_tilt is non-zero.
uniform float u_subsystems;
// The rotatation speed of the entire system. Only visually apparent if u_tilt is non-zero.
uniform float u_systemRotationSpeed;
attribute float a_speed;
attribute float a_tOffset;
attribute float a_index;

void main() {
  vec3 system_position = u_position.xyz;
  float radius = u_position.w;

  float elapsedSystemTime = u_params.x;
  float elapsedTime = elapsedSystemTime + a_tOffset;
  float defaultTModulus = u_params.y;
  float tModulus = defaultTModulus / a_speed;  // time to complete the spline
  float spread = u_params.z;  // how far apart the particles should be from each other
  float camScale = u_params.w;  // uniform scaling due to distance to camera

  // account for system dynamics here
  // TODO(nkanodia): If lots of different rings want to do arbitrary system rotation, move this
  // into java maybe?
  // systemP is the percentage of the spline we've traversed across the entire system
  float systemP = u_systemRotationSpeed * mod(elapsedSystemTime, defaultTModulus) / defaultTModulus;
  float cosT = u_tiltCosSin.x;
  float oneMCosT = 1.0 - cosT;
  float sinT = u_tiltCosSin.y;
  float systemTheta = PI * 2.0 * (a_index / u_subsystems + systemP);
  vec3 u = vec3(cos(systemTheta), 0.0, sin(systemTheta));
  // NOTE(nkanodia): The matrix for a rotation around u, ASSUMING y == 0.
  // If we need y to be non-zero, we'll need to add a bunch of terms.
  mat3 system_transform = mat3(
    cosT + u.x * u.x * oneMCosT, u.z * sinT, u.z * u.x * oneMCosT,
    -u.z * sinT, cosT, u.x * sinT,
    u.x * u.z * oneMCosT, -u.x * sinT, cosT + u.z * u.z * oneMCosT
  );

  // account for particle dynamics here - t is a parametric variable restricted to tModulus
  // p is the percentage through the path we've traveled.
  float p = mod(elapsedTime, tModulus) / tModulus;
  // pTheta is the radians through the path we've traveled.
  float pTheta = p * 2.0 * PI;
  vec3 particle_rotation = vec3(-cos(pTheta), 0.0, sin(pTheta));

  // To add variety, particles can move with different speeds. Arbitrarily, this is proportional
  // to the particle's position offset.
  float counter_radius_ratio = 1.0 - u_counterSpread * length(a_position) * (1.0 - spread * spread);
  vec3 dynamics = system_transform * particle_rotation * radius * counter_radius_ratio;

  vec3 particle_position = system_position + a_position * spread + dynamics;

  // get billboard coordinate system
  vec3 billboard_offset = buildBillboardOffset(particle_position, camScale);

  v_color = u_color;

  vec3 temp = particle_position + billboard_offset;
  gl_Position = u_modelViewProject * vec4(temp, 1.0);
}

#endif

#ifdef FRAGMENT
void main() {
  gl_FragColor = defaultParticleFragment();
}
#endif

