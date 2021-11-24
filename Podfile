# Uncomment the next line to define a global platform for your project
 platform :ios, '14.0'

use_frameworks!

workspace 'Game Catalogue'

target 'Game Catalogue' do
  pod 'SwiftLint'
  
  # SDWebImage
  pod 'SDWebImageSwiftUI'

  plugin 'cocoapods-keys', {
    :project => "GameCatalogue",
    :keys => [
      "RawgApiKey",
    ]
  }
end

target 'Core' do
  project 'Core/Core'
end
