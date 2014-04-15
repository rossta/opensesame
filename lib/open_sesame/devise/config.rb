Devise.setup do |config|
  config.warden do |manager|
    manager.default_strategies(:opensesame_github, :scope => :opensesame)
    manager.serialize_into_session(:opensesame) { |member| member.login }
    manager.serialize_from_session(:opensesame) { |login| OpenSesame::Member.find(login) }
  end
end
