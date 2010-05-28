function updatePoint(ll){
  $.post(gallery_options['update_url'], { item_id: updatePoint.item_id, lat: ll.lat(), lng: ll.lng()}, function(result){
    if(result){
      alert('Успішно збережено');
    }
  }, 'json');
}

function getMarker(ll){
  if(!getMarker.marker){
    getMarker.marker = new GMarker(ll, { draggable: true});
    getMarker.marker.disableDragging();
    window.map.addOverlay(getMarker.marker);
    GEvent.addListener(getMarker.marker, 'dragstart', function(){
      getMarker.marker.closeInfoWindow();
    });
    GEvent.addListener(getMarker.marker, 'dragend', function(){
      getMarker.marker.disableDragging();
      updatePoint(getMarker.marker.getLatLng());
    });
  }else{
    getMarker.marker.setPoint(ll);
  }

  return getMarker.marker;
}

function setMarkerCenter(result){
    var ll = new GLatLng(result[0], result[1]);

    getMarker(ll).show();
    window.map.panTo(ll);
}

function changeMarkerPosition(){
  window.showMap(true);
  var marker = getMarker.marker || getMarker(window.map.getCenter());
  marker.show();
  marker.enableDragging();
  marker.openInfoWindowHtml('<div style="padding:5px">Перетягніть прапорець щоб змінити<br/> позицію фотографії на карті<br/>Для зручності використовуйте кнопки <br/>"збільшити" і "зменшити" в лівому верхньому кутку</div>');
}

function updateMapTopPosition(){
  $('#map_container').css('top', $(document).scrollTop());
}


$(function(){
  var map = $('#map_outer'), inner = $('#fancy_inner'), outer = $('#fancy_outer'),
      map_is_visible = gallery_options['show_map'], zoomLevel;

  window.map.addControl(new GSmallZoomControl());
  $(window).bind("resize.fb scroll.fb", updateMapTopPosition);
  function showMap(){
    map.css({
      display: 'block',
      position: 'absolute',
      left: 20,
      right: 0,
      top: 20,
      height: 'auto',
      bottom: 45
    });

    outer.css({
      marginLeft: 'auto',
      marginRight: 0,
      left: 'auto',
      right: 0
    });
    $.cookie('include_map', map_is_visible = 1);
  }
  window.showMap = showMap;

  function showZoomControls(){
    $('#zoomControls').css({ position: 'absolute', margin: 10, top: 0}).appendTo(
      $('#fancy_inner')
    ).show();
    map.width(
      $(window).width() - outer.outerWidth() - 20
    );
    window.map.checkResize();
    updateMapTopPosition();

    var match = $('#fancy_img').attr('src').match(/images\/(\d+)/);

    if(match){
      updatePoint.item_id = +match[1];
      $.getJSON(gallery_options['get_point_url'].replace('%25', match[1]), function(result){
        if(result){
          setMarkerCenter(result);

          if(map_is_visible){
            showMap(false);
          }

          $('#showMap').show();
        }else{
          $('#showMap').hide();
          hideMap(false);
        }
      });
    }

    if(!zoomLevel){
      zoomLevel = 16;
      window.map.setZoom(16);
    }
  }

  function hideMap(save){
    map.css('left', - 1500);
    $(window).trigger('resize.fb');
    outer.css({
      right: 'auto'
    });
    if(save){
      $.cookie('include_map', map_is_visible = 0);
    }
  }

  $('.fancy').fancybox({ zoomSpeedChange: 100, callbackOnShow: showZoomControls, frameWidth: '100%', frameHeight: '100%', callbackOnClose: function(){ map.css('left', -1500); }});
  $('#showMap').click(function(){
    if(map_is_visible){
      hideMap(true);
    }else{
      showZoomControls();
      showMap();
    }
  });
});
