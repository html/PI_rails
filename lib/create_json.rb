module Actions::Repository
  define_action :create_json do
    str = self.class.to_s.sub /Controller$/, ''
    model = str.singularize.camelize.constantize

    item = model.new(params[str.underscore.singularize])

    if item.save
      render :json => {:success => :true}, :content_type => 'text/plain'
    else
      render :json => item.errors, :content_type => 'text/plain'
    end
  end
end
