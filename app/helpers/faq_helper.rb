module FaqHelper
  def question_for(item, escape = true)
    item = if item.question
      item.question
    else
      '< питання відсутнє >'
    end

    escape ? h(item) : item
  end
end
