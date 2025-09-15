import GUI from "lil-gui"
import * as THREE from "three"
import vertexShader from "./shaders/vertex.glsl"
import fragmentShader from "./shaders/fragment.glsl"

interface Props {
  scene: THREE.Scene
  debug: GUI
}

export default class Magazine {
  scene: THREE.Scene
  instancedMesh: THREE.InstancedMesh
  geometry: THREE.BoxGeometry
  material: THREE.ShaderMaterial
  meshCount: number = 20
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

    // this.debug
    //   .add(progress, "value", 0, 10)
    //   .name("Current Page")
    //   .onChange((value: number) => {
    //     this.material.uniforms.uCurrentPage.value = value
    //   })
    //   .min(0)
    //   .max(this.meshCount)
    //   .step(1)
  }

  createMaterial() {
    this.material = new THREE.ShaderMaterial({
      vertexShader,
      fragmentShader,
      side: THREE.DoubleSide,
      transparent: true,
      uniforms: {
        uCurrentPage: new THREE.Uniform(0),
        uPageThickness: new THREE.Uniform(this.pageThickness),
        uPageWidth: new THREE.Uniform(this.pageDimensions.width),
        uMeshCount: new THREE.Uniform(this.meshCount),
        uTime: new THREE.Uniform(0),
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
