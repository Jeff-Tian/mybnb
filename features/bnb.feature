Feature: 批量下载高清无码图片

  Scenario: 登录到编辑图片页面然后批量下载
    * 打开"https://zh.airbnb.com/manage-listing/15276656/photos"
    * 读取用户名和密码
    * 输入用户名和密码
    * 点击登录按钮
    * 等待"15"秒
    * 用javascript获取所有图片元素