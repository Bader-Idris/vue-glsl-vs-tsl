uniform float uTime;
uniform float uAmplitude;

varying float vDisplacement;

void main() {
    vec3 pos = position;
    
    float displacement = sin(pos.x * 4.0 + uTime) * uAmplitude;
    displacement += sin(pos.z * 3.0 + uTime * 0.8) * uAmplitude * 0.5;
    
    pos.y += displacement;
    
    vDisplacement = displacement;
    
    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}