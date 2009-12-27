/**
Vertigo Tip by www.vertigo-project.com
Requires jQuery
*/

this.vtip = function(){    
    this.xOffset = 20; // x distance from mouse
    this.yOffset = -50; // y distance from mouse       

    var vtipIsVisible = false;
    var mm = function(e){
        this.title = this.t;
        if(!e || !e.relatedTarget || arguments[0].relatedTarget.id != 'vtip'){
            $("#vtip").hide();
            vtipIsVisible = false;
        }
    };
    
    $("a.tooltip")
      .live('mouseover', function(e){
          vtipIsVisible = true;
          if(this.title){
            this.t = this.title;
            this.title = ''; 
          }
          this.top = (e.pageY + yOffset); this.left = (e.pageX + xOffset);
          
          $('#vtip').length || $('body').append('<div id="vtip"><img id="vtipArrow" />' + this.t + '</div>');
          if($('#vtip').is(':animated')){
            $('#vtip').stop();
          }

          $('#vtip').html(this.t);
                      
          $('#vtip #vtipArrow').attr("src", 'images/vtip_arrow.png');
          $('#vtip').css("top", this.top+"px").css("left", this.left+"px").show();
      }).live('mouseout', mm).live('click', mm).live('mousemove', function(e) {
          if(vtipIsVisible){
            var st = $(window).scrollTop(), sl = $(window).scrollLeft();
            this.top = (e.clientY + yOffset);// - $(window);
            this.left = (e.clientX + xOffset);

            if(this.top < st){
              this.top = st;
            }

            if(this.left < sl){
              this.left = sl;
            }
                         
            $("#vtip").css("top", this.top).css("left", this.left);
          }
      });
};

jQuery(document).ready(function($){vtip();}) 
