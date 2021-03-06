require 'sinatra/base'

class GrafanaJsonApp < Sinatra::Base
  configure :production, :development do
    enable :logging
  end
  
  json_hash = JSON.load(File.read('./db.json'))

  get '/' do
    'Introhive AWS Resource JSON'
  end

  post '/search' do
    content_type :json
    target = JSON.parse(request.body.read)
    search = JSON.parse(target['target'])
    if search['environment'] == 'list'
      return json_hash[search['region']].keys.to_json if json_hash.include?(search['region'])
    elsif json_hash.include?(search['region']) and json_hash[search['region']].keys.include?(search['environment'])
      return json_hash[search['region']][search['environment']][search['namespace']].to_json if search['namespace'] != nil
    end
  end

run! if __FILE__ == $0
end
