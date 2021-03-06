module DistributionPlugin::DistributionLayoutHelper

  HeaderButtons = [
    [:start, _('Start'), proc{ @node.profile.url }, proc{ on_homepage? }],
    [:orders, _('Orders'), {:controller => :distribution_plugin_order, :action => :index}],
    #[:about, _('About'), {:controller => :distribution_plugin_node, :action => :about}],
    #[:history, _('History'), {:controller => :distribution_plugin_node, :action => :history}],
    [:adm, _('Administration'), {:controller => :distribution_plugin_node, :action => 'index'}, proc{ @admin_action },
      proc{ @user_node and @node.has_admin?(@user_node) }],
  ]

  def display_header_buttons
    HeaderButtons.map do |key, label, url, selected_proc, if_proc|
      next if if_proc and !instance_eval(&if_proc)

      url = instance_eval(&url) if url.is_a?(Proc)
      if key != :adm and @admin_action
        selected = false
      elsif selected_proc
        selected = instance_eval(&selected_proc)
      else
        selected = params[:controller].to_s == url[:controller].to_s
      end
      link_to label, url, :class => "menu-button #{"menu-selected" if selected}"
    end.join
  end

  def load_node
    @node = DistributionPluginNode.find_by_profile_id profile.id if profile
    @user_node = DistributionPluginNode.find_or_create current_user.person if current_user
  end

  def render_header
    return unless @node and @node.collective?
    output = render :file => 'distribution_plugin_layouts/default'
    if on_homepage?
      extend DistributionPlugin::DistributionProductHelper
      output += render :file => 'distribution_plugin_gadgets/sessions'
    end
    output
  end

  protected

  # FIXME: workaround to fix Profile#is_on_homepage?
  def on_homepage?
    @node.profile.is_on_homepage?(request.path, @page) or request.path == "/profile/#{@node.profile.identifier}"
  end

end
