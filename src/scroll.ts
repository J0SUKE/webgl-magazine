import Lenis from "lenis"
import { ScrollTrigger } from "gsap/dist/ScrollTrigger"

export default class Scroll {
  lenis: Lenis
  scroll: number
  paralaxElements: HTMLElement[]
  startedScrolling: boolean
  isTouchDevice: boolean

  constructor() {
    this.lenis = new Lenis()

    this.lenis.scrollTo(0, {
      immediate: true,
    })

    this.scroll = this.lenis.scroll

    this.lenis.on("scroll", (e) => {
      this.scroll = e.scroll
      this.startedScrolling = true
    })

    requestAnimationFrame(this.raf.bind(this))
  }

  onScroll(callback: () => void) {
    this.lenis.on("scroll", callback.bind(this))
  }

  resetScroll() {
    this.lenis.scrollTo(0, { immediate: true })
    this.scroll = 0
    ScrollTrigger.refresh()
  }

  getScroll() {
    return this.scroll
  }

  raf(time: number) {
    this.lenis.raf(time)
    ScrollTrigger.update()
    requestAnimationFrame(this.raf.bind(this))
  }
}
