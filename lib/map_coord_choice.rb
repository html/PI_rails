ActionView::Helpers::FormHelper.class_eval do
  def require_map_coord_choice
    require_jquery_modal
    require_google_map_v2_scripts
    require_egeoxml

    once :require_map_coord_choice do
      javascript 'map_coord_choice'
    end
  end

  def map_coord_choice(options = {})
    raise ArgumentError, "Name not set" unless options[:name]
    raise ArgumentError, "Title not set" unless options[:title]

    require_map_coord_choice

    render :partial => '/map_coord_choice', :locals => {
      :link_title => options[:title],
      :frm => options[:form],
      :name => options[:name]
    }
  end
end
