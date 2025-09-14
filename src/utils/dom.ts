export function $(selector: string, parent?: HTMLElement) {
  return (parent ? parent : document).querySelector(selector) as HTMLElement
}

export function $$(selector: string, parent?: HTMLElement | string) {
  const p = (
    parent
      ? typeof parent === "string"
        ? (document.querySelector(parent) as HTMLElement)
        : parent
      : document
  ) as Document | HTMLElement
  return [...p.querySelectorAll(selector)] as HTMLElement[]
}

export function height(element: HTMLElement) {
  return element.getBoundingClientRect().height
}
