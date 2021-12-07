# Uncomment the next line to define a global platform for your project
 platform :ios, '14.0'

source 'https://github.com/rudii1410/GameCatalogue_Core'

use_frameworks!

# Framework version
$sdwebimageswiftui_version              = '2.0.2'

workspace 'Game Catalogue'

target 'Game Catalogue' do
  pod 'SDWebImageSwiftUI', $sdwebimageswiftui_version
  pod 'GameCatalogue_Core'

  plugin 'cocoapods-keys', {
    :project => "GameCatalogue",
    :keys => [
      "RawgApiKey",
    ]
  }
end

target 'Common' do
  project 'Common/Common.xcodeproj'

  pod 'SDWebImageSwiftUI', $sdwebimageswiftui_version
  pod 'GameCatalogue_Core'
end

# region Library Module

target 'DesignSystem' do
  project 'Lib/DesignSystem/DesignSystem.xcodeproj'
  
  pod 'SDWebImageSwiftUI', $sdwebimageswiftui_version
end

# region Feature Module
target 'Home' do
  project 'Features/Home/Home.xcodeproj'

  pod 'SDWebImageSwiftUI', $sdwebimageswiftui_version
  pod 'GameCatalogue_Core'
end

target 'Publisher' do
  project 'Features/Publisher/Publisher.xcodeproj'

  pod 'SDWebImageSwiftUI', $sdwebimageswiftui_version
  pod 'GameCatalogue_Core'
end

target 'Game' do
  project 'Features/Game/Game.xcodeproj'

  pod 'SDWebImageSwiftUI', $sdwebimageswiftui_version
  pod 'GameCatalogue_Core'
end

target 'Genre' do
  project 'Features/Genre/Genre.xcodeproj'

  pod 'SDWebImageSwiftUI', $sdwebimageswiftui_version
  pod 'GameCatalogue_Core'
end
