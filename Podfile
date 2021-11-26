# Uncomment the next line to define a global platform for your project
 platform :ios, '14.0'

use_frameworks!

workspace 'Game Catalogue'
project 'Game Catalogue'

pod 'SwiftLint'

target 'Game Catalogue' do
  pod 'SDWebImageSwiftUI'

  plugin 'cocoapods-keys', {
    :project => "GameCatalogue",
    :keys => [
      "RawgApiKey",
    ]
  }

end

target 'Core' do
  project 'Lib/Core/Core'

end

target 'DesignSystem' do
  project 'Lib/DesignSystem/DesignSystem'
  
  pod 'SDWebImageSwiftUI'
end