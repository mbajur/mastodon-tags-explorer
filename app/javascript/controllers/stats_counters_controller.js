import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["tagsCount", "tootsCount", "instancesCount"]

  connect() {
    // this.load()
    this.startRefreshing()
  }

  load() {
    fetch('/stats.json')
      .then(response => response.text())
      .then(resp => {
        let json = JSON.parse(resp)
        this.tagsCountTarget.innerHTML = json.tags_count
      })
  }

  startRefreshing() {
    setInterval(() => {
      this.load()
    }, 10000)
  }
}
