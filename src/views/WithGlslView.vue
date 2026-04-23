<template>
  <div class="home">
    <canvas ref="canvas"></canvas>
  </div>
</template>


<style scoped>
canvas {
  width: 100%;
  height: 100vh;
  display: block;
}
</style>

<script setup lang="ts">
import { onMounted, onUnmounted, ref } from 'vue'
import * as THREE from 'three'
import vertShader from '../shaders/test/vert.glsl'
import fragShader from '../shaders/test/frag.glsl'

const canvas = ref<HTMLCanvasElement>()
let animationId: number
let resizeHandler: () => void

onMounted(() => {
  if (!canvas.value) return

  const scene = new THREE.Scene()
  scene.background = new THREE.Color(0x111111)

  const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000)
  camera.position.set(0, 5, 8)
  camera.lookAt(0, 0, 0)

  const renderer = new THREE.WebGLRenderer({ canvas: canvas.value, antialias: true })
  renderer.setPixelRatio(window.devicePixelRatio)
  renderer.setSize(window.innerWidth, window.innerHeight)
  renderer.outputColorSpace = THREE.SRGBColorSpace

  resizeHandler = () => {
    camera.aspect = window.innerWidth / window.innerHeight
    camera.updateProjectionMatrix()
    renderer.setSize(window.innerWidth, window.innerHeight)
  }

  window.addEventListener('resize', resizeHandler)

  // Plane geometry
  const geometry = new THREE.PlaneGeometry(10, 10, 64, 64)

  // GLSL Shader Material
  const material = new THREE.ShaderMaterial({
    vertexShader: vertShader,
    fragmentShader: fragShader,
    uniforms: {
      uTime: { value: 0 },
      uAmplitude: { value: 0.5 },
      uColorA: { value: new THREE.Color(0x0066ff) },
      uColorB: { value: new THREE.Color(0xff6600) }
    },
    side: THREE.DoubleSide
  })

  // Mesh
  const plane = new THREE.Mesh(geometry, material)
  plane.rotation.x = -Math.PI / 2
  scene.add(plane)

  // Animation loop
  const animate = (time: number) => {
    animationId = requestAnimationFrame(animate)
    material.uniforms.uTime.value = time * 0.001
    renderer.render(scene, camera)
  }
  animate(0)
})

onUnmounted(() => {
  if (animationId) {
    cancelAnimationFrame(animationId)
  }
  if (resizeHandler) {
    window.removeEventListener('resize', resizeHandler)
  }
})
</script>