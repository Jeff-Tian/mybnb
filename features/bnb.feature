Feature: 批量下载高清无码图片

  Scenario: 登录到编辑图片页面然后批量下载
    * 读取房源编号
    * 打开"https://www.airbnbchina.cn/rooms/%{houseNumber}?preview"
    * 等待"3"秒
    * 用javascript获取所有图片元素