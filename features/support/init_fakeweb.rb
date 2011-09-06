# Set up mock responses for the RadDirectory web service to facilitate
# testing without relying on a live service.

require 'fakeweb'

API_URL = "#{RadDirectoryClient::Config.rad_directory_url}/rad_directory"

def load_fixture(name)
  path = "#{Rails.root}/features/fixtures/#{name}.rb"
  eval File.open(path).map { |line| line }.join("")
end

physicians = load_fixture("physicians")

def register_response(method, path, body)
  FakeWeb.register_uri(method,
                       "#{API_URL}#{path}",
                       :body => body,
                       :status => ["304", "Not Modified"],
                       :content_type => "application/json")
end

# Physician.all
register_response(:get, "/physicians.json", physicians.to_json)

physicians.each do |physician|
  # Physician.find(id)
  register_response(:get,
                    "/physicians/#{physician['id']}.json",
                    physician.to_json)
  # Physician.name_like("Flenderson")
  register_response(:get,
                    "/physicians/search.json?name_like=#{physician['family_name']}",
                    [physician].to_json)
end
