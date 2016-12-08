Feature: 批量下载高清无码图片

  Scenario: 登录到编辑图片页面然后批量下载
    * 读取房源编号
    * 打开"http://sh.xiaozhu.com/fangzi/%{houseNumber}.html"
    * 等待"10"秒
    * 用javascript获取所有小猪图片元素