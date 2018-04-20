import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["tagsCount", "tootsCount", "instancesCount"]

  connect() {
    this.startRefreshing()
  }

  load() {
    fetch('/stats.json')
      .then(response => response.text())
      .then(resp => {
        let json = JSON.parse(resp)

        this.tagsCountTarget.innerHTML = json.tags_count
        this.tootsCountTarget.innerHTML = json.toots_count
        this.instancesCountTarget.innerHTML = json.instances_count
      })
  }

  startRefreshing() {
    setInterval(() => {
      this.load()
    }, 10000)
  }
}
