Pod::Spec.new do |s|
  s.name         = "TLTabBarController"
  s.version      = "0.0.8"
  s.platform     = :ios, "8.0"
  s.summary      = "全能tabBarController，基于原生控件封装"
  s.description  = <<-DESC
    全能tabBarController，主要功能如下：
    1、气泡支持红点（如微信红点）
    2、点击、双击事件 (如微博双击tab刷新列表)
    3、tabBarItem仅图片支持
    4、突出的tabBarItem（如转转发布按钮），支持任意个
    5、切换自定义事件支持（如转转切换到消息tab前调登录）
    6、tabBar顶端线颜色设置、隐藏
    7、完美支持横屏
    8、完美支持“系统设置-辅助功能-按钮形状”模式
                   DESC
  
  s.author       = { "libokun" => "libokun@126.com" }
  s.homepage     = "https://github.com/tbl00c/TLTabBarController"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.source       = { :git => "https://github.com/tbl00c/TLTabBarController.git", :tag => s.version }

  s.requires_arc = true
  s.source_files = "TLTabBarController/**/*.{h,m}"

end
