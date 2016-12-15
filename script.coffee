---
---

dataurl = "https://api.citybik.es/v2/networks/citybike-wien"

map = {}
stations = []

$ ->
  map = new google.maps.Map(document.getElementById('map'), {
    center: {lat: 48.2082, lng: 16.3738}
    zoom: 13
    scaleControl: true
  })

  $.ajax dataurl
    .error (err) ->
      console.log err
    .done (data) ->
      stations = data.network.stations
      for s in stations
        newMarker(s.latitude, s.longitude, s.free_bikes)

newMarker = (lat, lon, num) ->
  color = switch
    when num == 0 then "red"
    when num <= 3 then "yellow"
    when num > 3 then "green"

  new google.maps.Marker(
    position:
      lat: lat
      lng: lon
    color: "green"
    label:
      fontWeight: "bold"
      text: num.toString()
    icon:
      path: "M 0 0 A 5 5 0 1 1 10 0 L 5 10 z"
      anchor:
        x: 5
        y: 10
      labelOrigin:
        x: 5
        y: 0
      fillOpacity: 1
      scale: 3
      strokeOpacity: 0
      fillColor: color
    map: map
  )
