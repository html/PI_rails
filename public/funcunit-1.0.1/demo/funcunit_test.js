// To run simply open http://articles.pi.ua:3000/funcunit-1.0.1/demo/funcunit.html

module("Статті",{
	setup : function(){
	}
})

namedFunction("Ідем на головну", function(){
  S.open("http://me:3000/");
});

namedFunction("Ідем на сторінку статей", function(callback){
  S.open("http://articles.pi.ua:3000/", callback);
});

namedFunction("Вводим дані для форми на сторінці статей", function(callback){
  S("#article_title").click()
      .type('TestTitle');
  S("textarea").click()
      .type('Content');
  callback();
});

namedFunction("Ідем на сторінку для додавання статті", function(callback){
  callNamedFunction("Ідем на сторінку статей", function(){
    S('#add_image').visible(function(){
      S('#add_image').click(function(){
        S('#article_title').visible(callback);
      });
    });
  });
});

namedFunction("Додаєм статтю на сторінці", function(callback){
  callNamedFunction("Вводим дані для форми на сторінці статей", function(){
    S("#article_submit").click(callback);
  });
});

namedFunction("Видаляєм статтю на сторінці показу статті", function(callback){
  S("a[title=Видалити статтю]").visible(function(){
    FuncUnit._opened();
    FuncUnit.confirm(true); 
    S(S._window.$.browser.mozilla ? "a[title=Видалити статтю]" : "img[alt=Remove]").click(function(){
      S('body').visible(function(){
        ok(S('.notice').exists());
        S('.articles-list').visible(function(){
          ok(/Article was successfully destroyed/.test(S('.notice').text()));
          callback();
        });
      });
    });
  });
});

test("Ширина поля для контенту на сторінці статей повинна бути нормальною", function(){
  callNamedFunction("Ідем на сторінку для додавання статті");
  S('#article_content').visible(function(){
    ok(S._window.$('#article_content').width() < S._window.$('#article_content').parents('p').width());
  });
});

test('Повинно показати повідомлення про додану статтю', function(){
  callNamedFunction("Ідем на сторінку для додавання статті", function(){
    callNamedFunction("Додаєм статтю на сторінці", function(){
      ok(S('.notice').exists());
      S('.notice').visible(function(){
        ok(/Article was successfully created/.test(S('.notice').text()));
        callNamedFunction("Видаляєм статтю на сторінці показу статті", function(){
        });
      });
    });
  });
});

test('Сторінка статей повинна завантажуватись нормально', function(){
  callNamedFunction("Ідем на сторінку статей", function(){
    S('.soria').visible(function(){
      ok(S._window.$('.soria').length > 0);
    });
  });
});
