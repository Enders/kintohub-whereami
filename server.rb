require 'sinatra'
require 'rest-client'
require 'json'

get '/' do
  begin
    response = JSON.parse(
      RestClient.get("http://api.ipstack.com/#{request.ip}?access_key=c71f08afcbabf32bc9066cc6be22d157")
    )
    [200, <<~EOS
      <html>
        <head>
          <title>Where Am I?</title>
        </head>
        <body>
          <h1>There you go!</h1>
          <p>Your ip: #{request.ip}</p>
          <p>
            <img src="#{response.dig("location", "country_flag")}">
            <span>#{response["city"]}, #{response["zip"]}, #{response["country_name"]}</span>
          </p>
        </body>
      </html>
    EOS
    ]
  rescue StandardError => exception
    [500, <<~EOS
      <html>
        <head>
          <title>Where Am I?</title>
        </head>
        <body>
          <h1>An error occured.</h1>
          <p>Woops. Try again later!</p>
          <p>Error: #{exception.to_s}</p>
        </body>
      </html>
    EOS
    ]
  end
end
