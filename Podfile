platform :ios, '11.0'
workspace 'BSD Gradebook iOS.xcworkspace'
inhibit_all_warnings!

target 'EDUPointServices' do
  project 'EDUPointServices/EDUPointServices.xcproj'
  use_frameworks!
  
  pod 'Alamofire', '~> 5.0.0.beta.1'
  pod 'XMLParsing', :git => 'https://github.com/ShawnMoore/XMLParsing.git'
  pod 'PromisesSwift'
  
  target 'EDUPointServicesTests' do
      inherit! :search_paths
  end
  
end

target 'BSD Gradebook iOS' do
  use_frameworks!
  
  pod 'PromisesSwift'

  target 'BSD Gradebook iOSTests' do
    inherit! :search_paths
    # Pods for testing
  end

end
