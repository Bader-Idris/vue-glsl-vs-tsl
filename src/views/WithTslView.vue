<template>
  <div class="home">
    <canvas ref="tslCanvas"></canvas>
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
import * as THREE from 'three/webgpu'
import {
  Fn,
  uniform,
  varying,
  vec4,
  float,
  positionLocal,
  sin,
  smoothstep,
  mix
} from 'three/tsl'

const tslCanvas = ref<HTMLCanvasElement | null>(null)
let animationId: number | null = null
let resizeHandler: (() => void) | null = null

onMounted(async () => {
  if (!tslCanvas.value) return

  // Scene
  const scene = new THREE.Scene()
  scene.background = new THREE.Color(0x111111)

  // Camera
  const camera = new THREE.PerspectiveCamera(
    75,
    window.innerWidth / window.innerHeight,
    0.1,
    1000
  )
  camera.position.set(0, 5, 8)
  camera.lookAt(0, 0, 0)

  // Renderer
  const renderer = new THREE.WebGPURenderer({
    canvas: tslCanvas.value,
    antialias: true
  })
  renderer.setPixelRatio(window.devicePixelRatio)
  renderer.setSize(window.innerWidth, window.innerHeight)
  await renderer.init()

  // Uniforms
  const uTime = uniform(0)
  const uAmplitude = uniform(0.5)
  const uColorA = uniform(new THREE.Color(0x0066ff))
  const uColorB = uniform(new THREE.Color(0xff6600))
  const vDisplacement = varying(float(0), 'vDisplacement')

  const vertexShader = Fn(() => {
    const pos = positionLocal

    const displacement = sin(pos.x.mul(4.0).add(uTime)).mul(uAmplitude)
    displacement.addAssign(
      sin(pos.z.mul(3.0).add(uTime.mul(0.8)))
        .mul(uAmplitude)
        .mul(0.5)
    )

    pos.y.addAssign(displacement)
    vDisplacement.assign(displacement)

    return pos
  })

  const fragmentShader = Fn(() => {
    const mixFactor = smoothstep(float(-1.0), float(1.0), vDisplacement)
    const color = mix(uColorA, uColorB, mixFactor)
    return vec4(color, 1.0)
  })

  const material = new THREE.MeshBasicNodeMaterial()
  material.positionNode = vertexShader()
  material.colorNode = fragmentShader()

  const geometry = new THREE.PlaneGeometry(10, 10, 64, 64)
  const mesh = new THREE.Mesh(geometry, material)
  mesh.rotation.x = -Math.PI / 2
  scene.add(mesh)

  const onResize = () => {
    camera.aspect = window.innerWidth / window.innerHeight
    camera.updateProjectionMatrix()
    renderer.setSize(window.innerWidth, window.innerHeight)
  }

  resizeHandler = onResize
  window.addEventListener('resize', onResize)

  const animate = (time: number) => {
    animationId = requestAnimationFrame(animate)
    uTime.value = time * 0.001
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