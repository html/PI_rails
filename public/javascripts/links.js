$(function(){
  $('#addLink').jqm({
    modal: true,
    trigger: '.jqm',
    onShow: function(el){
      $('.message').remove();
      $('.error').remove();
      el.w.show();
    }
  });

  (function(saveButton, form, url){
    $(saveButton).click(function(){
      var form = $(form);
      form.ajaxSubmit({
        type : 'POST',
        dataType : 'json',
        url : url,
        semantic: true,
        success : function(result){
          if(result.success){
            $('#addLink').jqmHide();
            $.scrollTo('body', {
              duration: 500, 
              onAfter: function(){
                $('.soria').prepend('<span class="message">Успішно додано, після перевірки адміністратором посилання потрапить на цю сторінку</span>');
                form.clearForm();
              }
            });
          }else{
            var errors = result;
            for (var i = 0; i < errors.length; i++) {
              $('#link_' + errors[i][0]).parent().siblings('.for_error').append(
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
  })('.save', '#jqmForm', window.add_url);
});
