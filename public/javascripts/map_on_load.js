$(function(){
  if (apiLoaded) {
    var a = get_args();
    var lat = a.lt ? a.lt : 48.208437;
    var lng = a.ln ? a.ln : 28.886089;
    var point = new GLatLng(lat, lng);
    var zoom = a.zoom ? a.zoom : 14;
    map = new GMap2($('#map_container')[0]);
    map.setCenter(point, zoom, G_SATELLITE_MAP);

    //var mapurl =  "http://maps.google.com/maps/ms?ie=UTF8&hl=uk&vps=1&jsv=196c&oe=UTF8&msa=0&msid=109688911985018730142.00047b531ea8037e1ea37&output=kml";
    //var mapurl= "http://maps.google.com/maps/ms?ssp=addf&vps=3&jsv=196c&ie=UTF8&hl=uk&msa=0&output=kml&msid=109688911985018730142.00047b531ea8037e1ea37"
    var mapurl = "/pi.kml";

    exml = new EGeoXml('exml', map, mapurl, {sidebarid: 'sidebar'}); //Default onload layer

    GEvent.addListener(exml, 'parsed', function(){
      map.setCenter(point, zoom);
    });

    exml.parse();
    $('#zoomIn').live('click', $l('map.zoomIn()'));
    $('#zoomOut').live('click', function(){ (map.getZoom() > 13) ? map.zoomOut() : alert('Масштаб зменшено до мінімального розміру');});
    GEvent.addListener(map, 'moveend', function(){
      var c = (this.getCenter());
      mix_in_the_url({
        ln: c.x,
        lt: c.y,
        zoom: this.getZoom()
      });
    });
  }
});
