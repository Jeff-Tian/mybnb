Feature: 批量下载高清无码图片

  Scenario: 登录到编辑图片页面然后批量下载
    * 读取用户名和密码
    * 打开"http://www.xiaozhu.com/xzweb.php?op=Pub_Preview&roomId=%{houseNumber}&roomType=1"
    * 输入小猪用户名和密码
    * 点击小猪登录按钮
    * 等待"10"秒
    * 用javascript获取所有小猪图片元素