Pod::Spec.new do |s|

  s.name               = "app-cordova-template"
  s.version            = "0.0.1"
  s.summary            = "Cordova template project for iOS."

  s.description        = <<-DESC "Cordova project for native iOS app."
                         DESC
  s.license            = { :type => "Commercial" }
  s.homepage           = "https://github.com/libertymutual/dss-framework"
  s.author             = { "Liberty Mutual" => "" }
  s.source             = { :path => "." }
  s.resources          = ["www", "config.xml"]

end
