# Uncomment the next line to define a global platform for your project

source 'https://github.com/CocoaPods/Specs.git'

source 'https://github.com/Harystep/toolSpec.git'


platform :ios, '11.0'
use_frameworks!
inhibit_all_warnings!

target 'SJHappyPlay' do


  
  pod 'AFNetworking', '4.0.1'
  pod 'SDWebImage', ' 5.15.5'
  pod 'Masonry', '1.1.0'
  
  pod 'MBProgressHUD', '1.2.0'
  pod 'MJRefresh', '3.7.5'
  pod 'MJExtension', '3.4.1'
  
  
  pod 'IQKeyboardManager', '6.5.11'
  
  pod 'FMDB', '2.7.5'
  
  # 富文本
  pod 'YYText', '1.0.7'
  pod 'YYImage', '1.0.4'
  
  pod 'JXCategoryView', '1.6.1'
  pod 'JXPagingView/Pager', '2.1.2'
  
  # 这是lottie OC终极版本
  pod 'lottie-ios', '2.5.3'
  
  pod 'Reachability', '3.2'
  
  #pod 'SJARCPlayer',  '~> 1.0.0'
  
  pod 'SwiftyStoreKit', '0.16.1'
  
  pod 'DZNEmptyDataSet','1.8.1'

  pod 'UMCommon', '~> 7.4.1'
  pod 'UMDevice', '~> 3.1.0'
  
  pod 'pop'
  pod 'CocoaAsyncSocket'
  pod 'ReactiveObjC', '~>3.1.1'
  pod 'MCUIColorUtils'
  pod 'Toast'
  pod 'UICountingLabel'
  pod 'MBProgressHUD'
  pod 'ijkplayer', '~>1.1.3'
  pod 'WsRTC'
  pod 'WMPageController', '~> 2.4.0'
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
      end
    end
  end

end

