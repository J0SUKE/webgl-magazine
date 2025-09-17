import GUI from "lil-gui"
import * as THREE from "three"
import vertexShader from "./shaders/vertex.glsl"
import fragmentShader from "./shaders/fragment.glsl"
import gsap from "gsap"

interface Props {
  scene: THREE.Scene
  debug: GUI
}

export default class Magazine {
  scene: THREE.Scene
  instancedMesh: THREE.InstancedMesh
  geometry: THREE.BoxGeometry
  material: THREE.ShaderMaterial
  meshCount: number = 30
  pageThickness: number = 0.01
  debug: GUI
  pageDimensions: {
    width: number
    height: number
  }

  constructor({ scene, debug }: Props) {
    this.scene = scene
    this.debug = debug

    this.pageDimensions = {
      width: 2,
      height: 3,
    }

    this.createGeometry()
    this.createMaterial()
    this.createMeshes()

    let progress = {
      value: 0,
    }

    this.debug
      .add(this.material.uniforms.uRotAcceleration, "value", 0, 1)
      .name("rotation acceleration")
      .onChange((value: number) => {
        this.material.uniforms.uRotAcceleration.value = value
      })
      .min(0)
      .max(1)
      .step(0.001)
      .listen()

    let reset = false
    let anim: gsap.core.Tween

    document.body.addEventListener("click", () => {
      if (reset) {
        reset = false
        anim?.kill()
        this.material.uniforms.uRotAcceleration.value = 0
        this.material.uniforms.uInfinitRotation.value = 0
      } else {
        reset = true
        anim = gsap.fromTo(
          this.material.uniforms.uRotAcceleration,
          { value: 0 },
          {
            value: 1,
            duration: 3,
            ease: "power2.inOut",
            onComplete: () => {
              this.material.uniforms.uInfinitRotation.value = 1
            },
          }
        )
      }
    })
  }

  createMaterial() {
    this.material = new THREE.ShaderMaterial({
      vertexShader,
      fragmentShader,
      side: THREE.DoubleSide,
      transparent: true,
      uniforms: {
        uRotAcceleration: new THREE.Uniform(0),
        uPageThickness: new THREE.Uniform(this.pageThickness),
        uPageWidth: new THREE.Uniform(this.pageDimensions.width),
        uMeshCount: new THREE.Uniform(this.meshCount),
        uTime: new THREE.Uniform(0),
        uInfinitRotation: new THREE.Uniform(0),
      },
    })
  }

  createGeometry() {
    this.geometry = new THREE.BoxGeometry(
      this.pageDimensions.width,
      this.pageDimensions.height,
      this.pageThickness,
      50,
      50,
      1
    )
  }

  createMeshes() {
    this.instancedMesh = new THREE.InstancedMesh(
      this.geometry,
      this.material,
      this.meshCount
    )

    //const positions = new Float32Array(this.meshCount * 3)
    const aIndex = new Float32Array(this.meshCount)

    for (let i = 0; i < this.meshCount; i++) {
      // positions[i * 3] = 0
      // positions[i * 3 + 1] = 0
      // positions[i * 3 + 2] = (-i + this.meshCount / 2) * this.pageThickness

      aIndex[i] = i
    }

    // this.instancedMesh.geometry.setAttribute(
    //   "aPosition",
    //   new THREE.InstancedBufferAttribute(positions, 3)
    // )

    this.instancedMesh.geometry.setAttribute(
      "aIndex",
      new THREE.InstancedBufferAttribute(aIndex, 1)
    )

    this.scene.add(this.instancedMesh)
  }

  render(time: number) {
    this.material.uniforms.uTime.value = time
  }
}
