uniform vec3 uColorA;
uniform vec3 uColorB;

varying float vDisplacement;

void main() {
    float mixFactor = smoothstep(-1.0, 1.0, vDisplacement);
    vec3 color = mix(uColorA, uColorB, mixFactor);
    
    gl_FragColor = vec4(color, 1.0);
}