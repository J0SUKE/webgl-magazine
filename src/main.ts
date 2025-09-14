import "./style.css"
import Canvas from "./canvas"
import Scroll from "./scroll"
import gsap from "gsap"
import { ScrollTrigger } from "gsap/ScrollTrigger"
import { $, $$ } from "./utils/dom"

gsap.registerPlugin(ScrollTrigger)

class App {
  canvas: Canvas
  scroll: Scroll

  constructor() {
    this.scroll = new Scroll()
    this.canvas = new Canvas({ scroll: this.scroll })

    const pages = $$("[data-page]")
    let currentPageIndex = 0
    const container = $("[data-pages-container]")

    document.addEventListener("click", (e) => {
      pages[currentPageIndex].style.setProperty("--turn-page", "1")
      currentPageIndex++
      container.style.setProperty(
        "--data-current-page-index",
        currentPageIndex.toString()
      )
    })

    this.render()
  }

  render() {
    this.canvas.render()
    requestAnimationFrame(this.render.bind(this))
  }
}

export default new App()
