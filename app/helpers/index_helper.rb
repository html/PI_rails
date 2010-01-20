module IndexHelper
  def li_class(item, items)
    case item
      when items.first
        'firstTweet'
      when items.last
        'lastTweet'
      else
        ''
    end
  end
end
