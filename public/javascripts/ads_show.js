$(function(){
  var map = new GMap2($('#mapContainer')[0]);
  var point = new GLatLng(window.lat, window.lng);

  //Begin load kml file
  var mapurl = "/pi.kml";

  exml = new EGeoXml('exml', map, mapurl); //Default onload layer

  GEvent.addListener(exml, 'parsed', function(){
    map.setCenter(point, 14);
  });

  exml.parse();
  //End load kml file

  map.addOverlay(new GMarker(point));
  map.setCenter(point, 14, G_SATELLITE_MAP);
  map.addControl(new GSmallZoomControl());
});
