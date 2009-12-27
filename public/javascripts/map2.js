var exml, map;
var apiLoaded = typeof GBrowserIsCompatible != 'undefined' && GBrowserIsCompatible();

if (apiLoaded) {
  EGeoXml.prototype.createPolygon = function(points,color,width,opacity,fillcolor,fillopacity,pbounds, name, desc) {
    var thismap = this.map;
    var iwoptions = this.opts.iwoptions || {};
    var polygonoptions = this.opts.polygonoptions || {};
    color = '#FFFF00';
    fillcolor = '#FFFF00';
    var p = new GPolygon(points,color, 1,opacity,fillcolor, 0,polygonoptions)
    p.hover = true;
    GEvent.addListener(thismap, 'zoomend', function(f,t){
        if(f > t || p.hover){
            p.hover = thismap.getBounds().containsBounds(p.getBounds());
        }
    });
    GEvent.addListener(p, 'mouseover', function(){
        if(this.hover){
            this.setFillStyle({
              opacity: opacity
            });
            this.setStrokeStyle({
              opacity: 1
            });
            this.strokeOpacity = 1;
        }
    });
    GEvent.addListener(p, 'mouseout', function(){
        this.setFillStyle({
          opacity: 0
        });
        this.setStrokeStyle({
          opacity: opacity
        });
    });
    this.map.addOverlay(p);
    this.gpolygons.push(p);
    var html = "<div style='font-weight: bold; font-size: medium; margin-bottom: 0em;'>"+name+"</div>"
               +"<div style='font-family: Arial, sans-serif;font-size: small;width:"+this.iwwidth+"px'>"+desc+"</div>";
    iwoptions.onOpenFn = function(){
      p.setStrokeStyle({
        opacity: 1
      });
    };

    iwoptions.onCloseFn = function(){
      p.setStrokeStyle({
        opacity: opacity
      });
    };

    GEvent.addListener(p,"click", function() {
      thismap.openInfoWindowHtml(pbounds.getCenter(), html, iwoptions);
    });
    if (this.opts.sidebarid) {
      var n = this.gpolygons.length-1;
      this.side_bar_list.push(name + "$$$polygon$$$" + n +"$$$");
    }
  }
}
	
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
	
