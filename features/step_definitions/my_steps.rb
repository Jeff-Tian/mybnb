inputs = {}
When(/^读取用户名和密码$/) do
  inputs = JSON.parse(File.read('input.json'))
end

When(/^打开"(.*?)"$/) do |link|
  visit link % {:houseNumber => inputs["houseNumber"]}
end

When(/^输入用户名和密码$/) do
  fill_in("signin_email", :with => inputs["username"], :match => :prefer_exact)
  fill_in("signin_password", :with => inputs["password"], :match => :prefer_exact)
end

When(/^点击登录按钮$/) do
  click_button('user-login-btn')
end

When(/^等待"([^"]*)"秒$/) do |seconds|
  sleep seconds.to_i
end

When(/^用javascript获取所有图片元素$/) do
  sleep 10
  output = page.execute_script('return (function(){
  var ret = [];
  var images = $(\'img[src^="https://z2.muscache.com/ac"]\');
  for(var i = 0; i < images.length; i++) {
    ret.push(images[i].outerHTML);
  }

  return ret.join("; ");
})();')
  print output

  File.open('./houses/source.txt', 'w') do |f|
    f.puts output
  end
end
