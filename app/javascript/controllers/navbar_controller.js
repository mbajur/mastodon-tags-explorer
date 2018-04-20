import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["menu"]

  toggleMenu() {
    this.menuTarget.classList.toggle("is-active")
  }
}
