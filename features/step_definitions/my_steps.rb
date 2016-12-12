inputs = {}

When(/^打开"(.*?)"$/) do |link|
  puts link % {:houseNumber => inputs["houseNumber"]}
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
  output = page.execute_script('return (function(){
  var ret = [];
  var images = $(\'.SlideshowModal__slideshow-preload img[src*="muscache.com/im/pictures"]\');
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


When(/^输入小猪用户名和密码$/) do
  fill_in("input-username", :with => inputs["username"], :match => :prefer_exact)
  fill_in("password", :with => inputs["password"], :match => :prefer_exact)
end

When(/^点击小猪登录按钮$/) do
  click_link('orgBtn')
end

When(/^用javascript获取所有小猪图片元素$/) do
  output = page.execute_script('return (function(){
  var ret = [];
  var images = $("img[data-src]");
  for(var i = 0; i < images.length; i++) {
    ret.push($(images[i]).attr("data-src"));
  }

  return ret.join("; ");
})();')
  print output

  File.open('./houses/source.txt', 'w') do |f|
    f.puts output
  end
end

When(/^读取房源编号$/) do
  inputs = JSON.parse(File.read('input.json'))
end

When(/^页面上应该有一个查看照片按钮$/) do
  expect(page).to have_content('查看照片')
end