Pod::Spec.new do |spec|
  spec.name = 'LoggingKit'
  spec.platform = :ios, '9.0'
  spec.version = '1.0.3'
  spec.authors = { 'Andreatta Massimiliano' => 'massimiliano.andreatta@gmail.com' }
  spec.homepage = 'https://github.com/Metide/LoggingKit'
  spec.summary = 'A Swift wrapper for Logging'
  spec.license = { :type => 'MIT' }
  spec.requires_arc = true
  spec.source = { :git => 'https://github.com/Metide/LoggingKit.git', :tag => "#{spec.version}" }
  spec.source_files = 'LoggingKit/*'
  spec.framework = 'UIKit', 'Foundation', 'CoreTelephony'

  spec.dependency 'Alamofire', '4.4.0'
  spec.dependency 'RxSwift'
  spec.dependency 'KeychainSwift'
  spec.dependency 'SwiftyJSON', '3.1.4'
end
