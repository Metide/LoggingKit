Pod::Spec.new do |spec|
  spec.name = 'LoggingKit'
  spec.platform = :ios, '9.0'
  spec.ios.deployment_target = '9.0'
  spec.version = '1.0.6'
  spec.authors = { 'Andreatta Massimiliano' => 'massimiliano.andreatta@gmail.com' }
  spec.homepage = 'https://github.com/Metide/LoggingKit'
  spec.summary = 'A Swift wrapper for Logging'
  spec.license = { :type => 'MIT' }
  spec.requires_arc = true
  spec.source = { :git => 'https://github.com/Metide/LoggingKit.git', :tag => "#{spec.version}" }
  spec.framework = 'UIKit', 'Foundation', 'CoreTelephony'
  spec.source_files = "Sources/*.swift"

  spec.dependency 'Alamofire', '4.4.0'
  spec.dependency 'RxSwift', '3.4.1'
  spec.dependency 'KeychainSwift', '8.0.2'
  spec.dependency 'SwiftyJSON', '3.1.4'
end
