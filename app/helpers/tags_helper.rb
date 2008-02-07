module TagsHelper

  module Cloud
    MAX_SIZE = 32
    MIN_SIZE = 12
  end

  # <tt>tags</tt> must be a hash where the keys are tag names and the values
  # the count of elements tagged with the tag, as returned by
  # Profile#find_tagged_with. If not tags were returned, just returns
  # _('No tags yet.')
  #
  # <tagname_option> must be a symbol representing the key to be inserted in
  # <tt>url</tt> with the tag name as value, if <tt>url</tt> is a Hash. If
  # <tt>url_options</tt> is a String, then the tag name is just appended to it.
  #
  # Example:
  #
  #   tag_cloud({ 'first-tag' => 10, 'second-tag' => 2, 'third-tag' => 1 }, :id, { :action => 'show_tag' })
  #
  # <tt>options</tt> can include one or more of the following:
  #
  # * <tt>:max_size</tt>: font size for the tag with largest count 
  # * <tt>:min_size</tt>: font size for the tag with smallest count 
  # 
  # The algorithm for generating the different sizes and positions is a
  # courtesy of Aurelio: http://www.colivre.coop.br/Aurium/Nuvem 
  # (pt_BR only).
  def tag_cloud(tags, tagname_option, url, options = {})
  

    return _('No tags yet.') + '<br/>' +
           '<a href="' + _('http://en.wikipedia.org/wiki/Tag_%28metadata%29') +
           '" class="button with-text icon-help" target="wptags"><span>' +
           _('What are tags?') + '</span></a>' if tags.empty?

    max_size = options[:max_size] || Cloud::MAX_SIZE
    min_size = options[:min_size] || Cloud::MIN_SIZE

    delta = max_size - min_size
    max = tags.values.max.to_f

    tags.map do |tag,count|
      v = count.to_f / max
      style = ""+
        "font-size: #{ (v * delta).round + min_size }px;"+
        "top: #{ -4 - (v * 4).round }px;"
      destination = url.kind_of?(Hash) ? url_for(url.merge(tagname_option => tag)) : (url.to_s + tag)

      link_to "#{tag}<small><sup>(#{count})</sup></small>", destination, :style => style
    end.join("\n")
  end

end
