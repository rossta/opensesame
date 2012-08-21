module OpenSesame
  module ViewHelper

    def login_image_link_to(provider)
      link_to identity_request_path(provider), :class => "btn btn-large" do
        image_tag("open_sesame/#{provider}_64.png") + "<br/><span>#{provider}</span>".html_safe
      end
    end

    def identity_request_path(provider)
      [OpenSesame.mount_prefix, provider].join('/')
    end

  end
end