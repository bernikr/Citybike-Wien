---
---

dataurl = "https://api.citybik.es/v2/networks/citybike-wien"

map = {}
stations = []
showSlots = false

$ ->
  map = new google.maps.Map(document.getElementById('map'), {
    center: {lat: 48.2082, lng: 16.3738}
    zoom: 13
    scaleControl: true
  })

  reload()

  $('#slots_toggle').change ->
    showSlots = @checked
    redrawStations()

reload = ->
  for s in stations
    s.setMap null
  stations = []

  $.ajax dataurl
    .error (err) ->
      console.log err
    .done (data) ->
      for s in data.network.stations
        s.marker = newMarker(s.latitude, s.longitude)
        stations.push s
      redrawStations()

redrawStations = ->
  for s in stations
    num = switch showSlots
      when true then s.empty_slots
      when false then s.free_bikes
    color = switch
      when num == 0 then "red"
      when num <= 3 then "yellow"
      when num > 3 then "green"

    s.marker.setLabel
      fontWeight: "bold"
      text: num.toString()
    s.marker.setIcon
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

newMarker = (lat, lon) ->
  return new google.maps.Marker
    position:
      lat: lat
      lng: lon
    map: map
