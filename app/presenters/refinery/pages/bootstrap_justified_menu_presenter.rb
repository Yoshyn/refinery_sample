require 'active_support/core_ext/string'
require 'active_support/configurable'
require 'action_view/helpers/tag_helper'
require 'action_view/helpers/url_helper'

module Refinery
  module Pages
    class BootstrapJustifiedMenuPresenter < MenuPresenter

      self.dom_id         = 'menu'
      self.css            = 'navbar'
      self.menu_tag       = :nav
      self.list_tag       = :ul
      self.list_item_tag  = :li
      self.selected_css   = :active

      private
      def render_menu(items)
        content_tag(menu_tag, :id => dom_id, :class => css, :role => :navigation) do
          render_menu_items(items)
        end
      end

      def render_menu_items(menu_items, tag_css: 'nav nav-justified', role: '')
        if menu_items.present?
          list_options = { :class => tag_css, :role => role }.delete_if { |_, value| value.blank? }

          content_tag(list_tag, list_options) do
            menu_items.each_with_index.inject(ActiveSupport::SafeBuffer.new) do |buffer, (item, index)|
              buffer << render_menu_item(item, index)
            end
          end
        end
      end

      def render_menu_item_link(menu_item, options = {})
        title = options.delete(:carret) ? "#{menu_item.title} <span class='caret'></span>" : menu_item.title
        link_to(title.html_safe, context.refinery.url_for(menu_item.url), options)
      end

      def render_menu_item(menu_item, index)
        menu_item_childrens = menu_item_children(menu_item)
        item_css            = menu_item_css(menu_item, index)
        link_options        = {}
        if menu_item_childrens.present?
          link_options = {'class' => 'dropdown-toggle', 'data-toggle' => 'dropdown', carret: true}
          item_css << "dropdown"
        end

        content_tag(list_item_tag, :class => item_css) do
          buffer = ActiveSupport::SafeBuffer.new
          buffer << render_menu_item_link(menu_item, link_options)
          buffer << render_menu_items(menu_item_childrens, :tag_css => 'dropdown-menu', :role => "menu")
          buffer
        end
      end

      def menu_item_css(menu_item, index)
        css = []
        css << selected_css if selected_item_or_descendant_item_selected?(menu_item)
        css
      end
    end
  end
end
