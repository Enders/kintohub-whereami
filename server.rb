require 'sinatra'
require 'rest-client'
require 'json'
=begin
@api {GET} /{ip} Request localisation of an IP
@apiName WhereAmI
@apiParam {String} ip IPV4 IP.
@apiSuccess {String} zipcode Zipcode
@apiSuccess {String} city Name of the city
@apiSuccess {String} country Name of the country
@apiError (500) {String} error Critical server error
@apiError (400) {String} error Error from ipstack
=end
get '/:ip' do
  begin
    response = RestClient.get("http://api.ipstack.com/#{params['ip']}?access_key=c71f08afcbabf32bc9066cc6be22d157")
    return [400, { error: response.body, status: response.code }.to_json] unless response.code == 200
    data = JSON.parse(response.body)
    if data.dig("zip").nil? && data.dig("city").nil? && data.dig("country_name").nil?
      [400, { error: "Couldn't find any localisation data for #{params['ip']}" }.to_json]
    else
      [200, {
        zipcode: data.dig("zip"),
        city: data.dig("city"),
        country: data.dig("country_name"),
      }.to_json]
    end
  rescue StandardError => exception
    [500, { error: exception.to_s }.to_json]
  end
end
