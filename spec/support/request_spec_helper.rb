module RequestSpecHelper
  include Warden::Test::Helpers

  def json
    JSON.parse(response.body)
  end

  def api_authentication(user)
    post('/auth/sign_in', params: {email: user.email, password: user.password})
    {
      "access-token": response.headers["access-token"],
      "token-type": "Bearer",
      "client": response.headers["client"],
      "expiry": response.headers["expiry"],
      "uid": response.headers["uid"]
    }
  end

  def firebase_valid_response
    {"-KlxNNEaAPS4G6xVxijL"=>
      { "address"=>"Cl 47 45 28", 
        "country"=>"Colombia", 
        "last_name"=>"Gutierrez", 
        "name"=>"Stella", 
        "organization_id"=>"2520e0e1-2f6e-4543-8ad8-0cab1cf9e670"
      }
    }
  end

end
