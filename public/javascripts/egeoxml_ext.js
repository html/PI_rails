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

  EGeoXml.prototype.createPolyline = function(points,color,width,opacity,pbounds,name,desc) {
    var thismap = this.map;
    var iwoptions = this.opts.iwoptions || {};
    var polylineoptions = this.opts.polylineoptions || {};
    //var p = new GPolyline(points,color,width,opacity,polylineoptions);
    var p = new GPolyline(points, '#FFFFFF', 1, 1,polylineoptions);

    GEvent.addListener(p, 'mouseover', function(){
        this.setStrokeStyle({
           weight: 3
        });
    });
    GEvent.addListener(p, 'mouseout', function(){
        this.setStrokeStyle({
            weight: 1
        });
    });
    this.map.addOverlay(p);
    this.gpolylines.push(p);
    var html = "<div style='font-weight: bold; font-size: medium; margin-bottom: 0em;'>"+name+"</div>"
               +"<div style='font-family: Arial, sans-serif;font-size: small;width:"+this.iwwidth+"px'>"+desc+"</div>";
    GEvent.addListener(p,"click", function() {
      thismap.openInfoWindowHtml(p.getVertex(Math.floor(p.getVertexCount()/2)),html,iwoptions);
    } );
    return;
    if (this.opts.sidebarid) {
      var n = this.gpolylines.length-1;
      var blob = '&nbsp;&nbsp;<span style=";border-left:'+width+'px solid '+color+';">&nbsp;</span> ';
      this.side_bar_list.push (name + "$$$polyline$$$" + n +"$$$" + blob );
    }
  }
}
