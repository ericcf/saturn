# Set up mock responses for the RadDirectory web service to facilitate
# testing without relying on a live service.

require 'fakeweb'

# only allow local connections, not internet connections
#FakeWeb.allow_net_connect = %r[^https?://(localhost|127.0.0.1)]

API_URL = "#{RadDirectoryClient::Config.rad_directory_url}/rad_directory"

def load_fixture(name)
  path = "#{Rails.root}/features/fixtures/#{name}.rb"
  eval File.open(path).map { |line| line }.join("")
end

physicians = load_fixture("physicians")

# Proxy::Physician.all
FakeWeb.register_uri :get,
                     "#{API_URL}/physicians.json",
                     :body => physicians.to_json,
                     :status => ["304", "Not Modified"],
                     :content_type => "application/json"

physicians.each do |physician|
  # Proxy::Physician.find(id)
  FakeWeb.register_uri :get,
                       "#{API_URL}/physicians/#{physician['id']}.json",
                       :body => physician.to_json,
                       :status => ["304", "Not Modified"],
                       :content_type => "application/json"
end

# Proxy::Physician.name_like("Flenderson")
FakeWeb.register_uri :get,
                     "#{API_URL}/physicians/search.json?name_like=Flenderson",
                     :body => physicians.to_json,
                     :status => ["200", "OK"],
                     :content_type => "application/json"
