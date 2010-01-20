module IndexHelper
  def li_class(item, items)
    case item
      when items.last
        'lastTweet'
      when items.first
        'firstTweet'
      else
        ''
    end
  end
end
