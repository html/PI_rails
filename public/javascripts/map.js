  $.fn.exchangeData = function(key, val){
    var ret = this.data(key);
    this.data(key, val);
    return ret;
  };

  function changeHeight(selector, value, around, map){
    $(selector).click(function(){
      var map = $('#map_container');
      var h = map.height() + value;

      around.css('overflow', value > 0 ? 'visible' : 'hidden');


      if(h < 200)
        alert('Карту зменшено до мінімального розміру');
      else{
        around.height(h);
        map.data('height', h);
        map.height(map.data('height'));
        mix_in_the_url({
          map_height: map.data('height')
        });
      }
    });
  }

  function get_args(){
    var default_hash = 'lat=48.2084306&lon=28.8844299&z=14&l=37&ifr=1&m=b&lang=ua';
    var args = $.deparam($.param.fragment(), true);

    if (typeof args != 'object') {
      window.location.hash = default_hash;
      args = $.deparam(default_hash, true);
    }

    return args;
  }

  function mix_in_the_url(new_args){
      var args = get_args();
      $.extend(args, new_args);
      window.location.hash = $.param(args);
  }

  $(function(){
    var map_obj = $('#aroundmap'), $soria = $('.soria');

    if(get_args().map_height){
      map_obj.find('#map').height(get_args().map_height);
    }

    (function($t, $m, $c){
      //$t.data('title', 'Зменшити карту');
      $c.data('width', 900);

      var change_title = function(){
        //$t.attr('title', ($t.exchangeData('title', $t.attr('title'))));
        $c.width($c.exchangeData('width', $c.width()));

        mix_in_the_url({
          wide : $c.data('width') != 900
        });
      };

      $t.toggle(function(){
        $m.toggle('slow', change_title);
        $('.soria').height($(window).height());
        $.scrollTo('.soria', {duration: 500});
      }, function(){
        change_title();
        $m.toggle('slow');
        $.scrollTo('body', {duration: 500});
      });

      if(get_args().wide){
        $t.click();
      }
    })($('#toggleMap'), $('#leftmenu'), $soria);


    var map = $('#map', map_obj), around = $('#aroundmap', map_obj);
    changeHeight('#decHeight', -20, around, map);
    changeHeight('#incHeight', 20, around, map);

  });

  $(function(){
    var map = $('#map');
    var height;

    function updateFancyContent(){
      var t = $(this), fo = $('#fancy_outer'), ft = $('#fancy_title');

      fo.css({top: $(window).scrollTop(), left: $(window).scrollLeft()});

      $(['width', 'height']).each(function(){
        eval("$('#fancy_content').%s(t.%s() - 100)".replace(/%s/g, this));
      });

      fo.height(t.height() - 80);
      fo.width(t.width() - 40);

      ft.css('top', (fo.outerHeight() - 32 + $(window).scrollTop()));
      ft.css('left', (fo.outerWidth() * 0.5) - (ft.width() * 0.5));
    }

    $('#fullscreen').fancybox({
      'hideOnContentClick': false, 
      callbackOnClose: function(){
        $(window).unbind('resize');
        map.appendTo($('.soria')).height(height).show();
        $('#controls').append($('#zoomControls').css({position: 'relative', float: 'left', margin: 0}).appendTo()).show();

        mix_in_the_url({
          fullscreen : false
        });

        enableTooltipsFor('#controls a.tooltip');
      },
      callbackOnStart: function(){
        $('#zoomControls').hide();
        height = $('#map_container').height();
        mix_in_the_url({
          fullscreen : true
        });
        map.hide()
      },
      callbackOnShow: function(){
        $(window).resize(updateFancyContent);
        $(window).trigger('resize');
        var f = $('#fancy_div');
        $('#map_container').height('100%');
        map.height('100%');
        f.empty().append(map.css('z-index', 1000)).show();
        map.show();
        $('#zoomControls').css({ position: 'absolute', top: 0, float: 'right', margin: 10}).appendTo(map).show();
      }
    });

    if(get_args().fullscreen){
      $('#fullscreen').click();
    }

    var rpc = $('#rpContainer');
    $('#rightPanel').toggle(function(){
      mix_in_the_url({
        'sidebar' : false
      });
      rpc.children().hide();
      rpc.width(1);
    }, function(){
      mix_in_the_url({
        'sidebar' : true
      });
      rpc.children().show();
      rpc.width(172);
    });

    var cEvents = $('#rightPanel').data('events').click;

    for(var i in cEvents){
      $('#rightPanel').live('click', cEvents[i]);
      return;
    }
  });
