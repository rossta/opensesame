Devise.add_mapping(
  :opensesame,
  class_name: 'OpenSesame::Member',
  failure_app: OpenSesame::Failure::DeviseApp.new
)
