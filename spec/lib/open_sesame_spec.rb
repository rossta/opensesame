require 'spec_helper'

describe OpenSesame do

  it { defined?(OpenSesame).should be_true }

  it { defined?(OpenSesame::Configuration).should be_true }
  it { defined?(OpenSesame::GithubAuth).should be_true }
  it { defined?(OpenSesame::GithubWarden).should be_true }
  it { defined?(OpenSesame::Member).should be_true }
  it { defined?(OpenSesame::Failure::App).should be_true }
  it { defined?(OpenSesame::Failure::DeviseApp).should be_true }
  it { defined?(OpenSesame::Helpers::ControllerHelper).should be_true }
  it { defined?(OpenSesame::Helpers::ViewHelper).should be_true }
end
