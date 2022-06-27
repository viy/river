import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["rivers", "form", "destId"]

  connect() {
    this.initMap()
    this.drawRivers()
    addEventListener('turbo:submit-end',async (event) => {
          this.drawRivers()
        }
    )
  }

  importMap() {
    addEventListener('turbo:submit-end', updateRiverList)
    function updateRiverList(){
      document.querySelector('turbo-frame#river_list').src = 'rivers/list'
      removeEventListener('turbo:submit-end', updateRiverList)
    }
  }

  initMap() {
    this.map = L.map('map').setView(this.rivers['source']['coord'][0], 13);
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      maxZoom: 19,
      attribution: '© OpenStreetMap'
    }).addTo(this.map);
  }

  get rivers() {
    return JSON.parse(this.riversTarget.dataset['value'])
  }

  buildSource() {
    let source = this.rivers['source']
    this.source_polyline = L.polyline(source['coord'], {color: 'red'}).addTo(this.map);
    this.map.fitBounds(this.source_polyline.getBounds());
    this.source_polyline.bindTooltip(this.rivers['source']['name']);
  }

  buildDestinations() {
    let destinations = this.rivers['destinations']
    this.pLineGroup = L.layerGroup()

    for (let key in destinations) {
      let options = {color: destinations[key]['color'], id: destinations[key]['id'], name: destinations[key]['name']}
      let polyline = L.polyline(destinations[key]['coord'], options);
      this.pLineGroup.addLayer(polyline)
      polyline.bindTooltip(destinations[key]['name']);
      polyline.on('click', (e) => {
        if (confirm("Matching " + e.target['options']['name'])) {
          this.destIdTarget.value = e.target['options']['id']
          this.formTarget.requestSubmit()
          this.source_polyline.remove()
          this.pLineGroup.remove()
        }
      });
    }
    this.pLineGroup.addTo(this.map)
  }

  drawRivers() {
    this.buildSource()
    this.buildDestinations()
  }
}
