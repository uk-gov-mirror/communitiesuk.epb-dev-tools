require "sinatra"
require "json"
require "base64"

set :bind, "0.0.0.0"
set :port, 4000
set :server, "webrick"

# in-memory store (dev only)
STORE = {}

post "/" do
  case env["HTTP_X_AMZ_TARGET"]
  when "TrentService.Encrypt"
    body = JSON.parse(request.body.read)
    plaintext = body["Plaintext"]

    id = "kms-#{rand(100000)}"
    STORE[id] = plaintext

    content_type :json
    {
      CiphertextBlob: Base64.strict_encode64(id)
    }.to_json

  when "TrentService.Decrypt"
    body = JSON.parse(request.body.read)
    id = Base64.strict_decode64(body["CiphertextBlob"])

    content_type :json
    {
      Plaintext: STORE[id]
    }.to_json
  end
end
