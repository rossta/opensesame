require 'spec_helper'

describe OpenSesame do

  it { defined?(OpenSesame).should be_true }

  it { defined?(OpenSesame::Configuration).should be_true }
  it { defined?(OpenSesame::ControllerHelper).should be_true }
  it { defined?(OpenSesame::ViewHelper).should be_true }
end
