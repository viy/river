import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search-form"
export default class extends Controller {
  static targets = [ "form", "map" ]
  static values = {
    src: String
  }


  search() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      this.formTarget.requestSubmit()
    }, 200)
  }

  map(event) {
    document.getElementById('rivers_frame').setAttribute('src', event.params['src'])
  }
}
