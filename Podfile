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

# region Library Module
target 'Core' do
  project 'Lib/Core/Core'

end

target 'DesignSystem' do
  project 'Lib/DesignSystem/DesignSystem'
  
  pod 'SDWebImageSwiftUI'
end

# region Feature Module
target 'Home' do
  project 'Features/Home/Home'

end

target 'Publisher' do
  project 'Features/Publisher/Publisher'

end

target 'Game' do
  project 'Features/Game/Game'

end

target 'Genre' do
  project 'Features/Genre/Genre'

end