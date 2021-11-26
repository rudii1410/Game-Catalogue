# Uncomment the next line to define a global platform for your project
 platform :ios, '12.0'

use_frameworks!

workspace 'Game Catalogue'
project 'Game Catalogue'

pod 'SwiftLint'

target 'Game Catalogue' do
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
