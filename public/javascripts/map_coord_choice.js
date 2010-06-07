function createMapSelector(options){
  function choosePoint(){
    $('#modalMap').jqmShow();

    if(!choosePoint.map){
      choosePoint.map = new GMap2($('#mapContainer')[0]);
      var hidden_value = $(options.hidden_field_selector).val().split('x');

      if (hidden_value.length > 1){
        var point = new GLatLng(parseFloat(hidden_value[0]), parseFloat(hidden_value[1]));
        choosePoint.map.addOverlay(new GMarker(point));
      }else{
        var point = new GLatLng(options.lat, options.lng);
      }

      choosePoint.map.setCenter(point, 14, G_SATELLITE_MAP);
      choosePoint.map.checkResize();
      choosePoint.map.addControl(new GSmallZoomControl());
    }
  }

  function cancelSetPoint(){
    if(choosePoint.listener){
      GEvent.removeListener(choosePoint.listener);
    }
    setCursor(false);
    choosePoint.settingPoint = false;
  }

  function setMapPoint(point){
    choosePoint.map.clearOverlays();
    if(point){
      choosePoint.map.addOverlay(new GMarker(point));
      $(options.hidden_field_selector).val([point.lat(), 'x', point.lng()].join(''));
    }else{
      $(options.hidden_field_selector).val('');
    }

    setCursor(false);
  }

  function setCursor(crosshair){
    var obj = $('#mapContainer div div');

    if(crosshair){
      choosePoint.cursor = obj.css('cursor');
      obj.css('cursor', 'crosshair');
      $('#modalMap').css('cursor', 'crosshair');
    }else{
      obj.css('cursor', choosePoint.cursor);
      $('#modalMap').css('cursor', 'default');
    }
  }

  $(function(){
    $('#modalMap').jqm({modal: true});

    $('.jqmClose').click(function(){
      setMapPoint();
      cancelSetPoint();
    });

    $('#set_point').click(function(){
      if(!choosePoint.settingPoint){

        setCursor(true);
        choosePoint.settingPoint = true;

        choosePoint.listener = GEvent.addListener(choosePoint.map, 'click', function(dummy, point){
          setMapPoint(point);
          cancelSetPoint();
        });
      }else{
        cancelSetPoint();
      }
    });

    $('.save.link').click(function(){
      $('#modalMap').jqmHide();
      cancelSetPoint();
    });
  });

  return choosePoint;
}
