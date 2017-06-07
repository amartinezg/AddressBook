Swagger::Docs::Config.base_api_controller = ActionController::API

Swagger::Docs::Config.register_apis({
  "1.0" => {
    :api_file_path => "public/apidocs",
    :base_path => "http://addresbook.amartinez.co/",
    :clean_directory => true,
    :base_api_controller => ActionController::API,
    :attributes => {
      :info => {
        "title" => "AdressBook STRV",
        "contact" => "amartinez0000@gmail.com",
        "license" => "Apache 2.0",
        "licenseUrl" => "http://www.apache.org/licenses/LICENSE-2.0.html"
      }
    }
  }
})