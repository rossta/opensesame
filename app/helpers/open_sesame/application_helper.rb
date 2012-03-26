module OpenSesame
  module ApplicationHelper
    include OpenSesame::ViewHelper

    def page_header(text)
      content_tag(:header, class: "content-header") do
        content_tag(:h1, text)
      end
    end
  end
end
