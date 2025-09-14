import "./style.css"
import Canvas from "./canvas"
import Scroll from "./scroll"
import gsap from "gsap"
import { ScrollTrigger } from "gsap/ScrollTrigger"

gsap.registerPlugin(ScrollTrigger)

class App {
  canvas: Canvas
  scroll: Scroll

  constructor() {
    this.scroll = new Scroll()
    this.canvas = new Canvas({ scroll: this.scroll })

    this.render()
  }

  render() {
    this.canvas.render()
    requestAnimationFrame(this.render.bind(this))
  }
}

export default new App()
