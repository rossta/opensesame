# encoding: utf-8
require 'vcr'
require 'fakeweb'

VCR.configure do |c|
  ruby_major_minor = RUBY_VERSION.split('.')[0,2].join('.')
  c.cassette_library_dir  = "spec/vcr/#{ruby_major_minor}"
  c.allow_http_connections_when_no_cassette = true
  c.hook_into :fakeweb
end

RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true
  c.around(:each, :vcr) do |example|
    name = example.metadata[:cassette]
    unless name
      namespace = example.metadata[:full_description].split.first.split("::").last.downcase
      spec_name = example.metadata[:description].split.join("_")
      name = [namespace, spec_name].join("/")
    end
    VCR.use_cassette(name, :record => example.metadata[:record]) { example.call }
  end
end
