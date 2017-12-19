require 'json'

package = JSON.parse(File.read(File.join(__dir__, '../package.json')))

Pod::Spec.new do |s|
  s.name                = "AppPlatform"
  s.version             = package["version"]
  s.summary             = package["description"]
  s.description         = <<-DESC
  							DSS App Platform components:
                            - App Manager - Handles modules, configurations and navigation.
							- React Native View
                         DESC
  s.homepage            = "https://github.com/libertymutual/dss-framework"
  s.license             = package["license"]
  s.author              = "Liberty Mutual"
  s.source              = { :git => "ssh://git@git.forge.lmig.com:7999/pidss/dss-app-manager.git", :tag => "#{s.version}" }
  s.requires_arc        = true
  s.platform            = :ios, "9.0"
  # s.preserve_paths      = "node_modules", "package.json"
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3' }
  s.cocoapods_version   = ">= 1.2.0"
  s.default_subspecs     = ["AppPlatform", "AppManager"]
  s.dependency           "SwiftLint"

  s.subspec "AppPlatform" do |ss|
    ss.source_files         = "AppPlatform/*.{swift,c,h,m,mm,S}"
  end
  s.subspec "AppManager" do |ss|
    ss.source_files         = "AppManager/*.{swift,c,h,m,mm,S}"
  end

  s.subspec "ReactNativeView" do |ss|
    ss.source_files        = "ReactNativeView/*.{swift,c,h,m,mm,S}"
    ss.dependency "React", "~> 0.50.4"
    ss.dependency "yoga"
    ss.dependency "AppPlatform/AppManager"
  end

  s.subspec "CordovaView" do |ss|
    ss.source_files        = "CordovaView/*.{swift,c,h,m,mm,S}"
    ss.dependency "Cordova", "~> 4.0.1"
    ss.dependency "AppPlatform/AppManager"
    ss.dependency "lmig-webview-engine-plugin"
    ss.dependency "XCGLogger", "~> 6.0.1"
    # ss.dependency "GCDWebServer", "~> 3.0"
  end

  s.subspec "AuthModule" do |ss|
    ss.source_files         = "AuthModule/*.{swift,c,h,m,mm,S}"
    ss.dependency "Alamofire"
    ss.dependency "JWTDecode"
  end

  s.subspec "BiometricModule" do |ss|
    ss.source_files         = "BiometricModule/*.{swift,c,h,m,mm,S}"
    ss.dependency 'KeychainAccess', '~> 3.0'
  end
end
