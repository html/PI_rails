$(function(){
  $('#addLink').jqm({
    modal: true,
    trigger: '#add_image',
    onShow: function(el){
      $('.message').remove();
      $('.error').remove();
      el.w.show();
    }
  });
    (function(saveButton, form, url){
      var form = $(form);
      var ids = {
        title: '#photo_title',
        image_file_name: '#photo_image'
      };

      $(saveButton).click(function(){
        form.ajaxSubmit({
          type : 'POST',
          dataType : 'json',
          url : url,
          semantic: true,
          success : function(result){
            if(result.success){
              $('#addLink').jqmHide();
              $('#photos').load(list_url);
              $.scrollTo('body', {
                duration: 500, 
                onAfter: function(){
                  $('.soria').prepend('<span class="message">Успішно додано</span>');
                  form.clearForm();
                }
              });
            }else{
              var errors = result;
              for (var i = 0; i < errors.length; i++) {
                $(ids[errors[i][0]]).parent().siblings('.for_error').append(
                  '<span class="error">' + errors[i][1] + '</span>'
                );
              };
            }
          },
          failure: function(){
            alert('Виникла помилка зв\'язку з сервером')
          },
          beforeSubmit : function(){
            $('.error').remove();
          }
        });
      });
    })('.save', '#jqmForm', ad_url);
});
