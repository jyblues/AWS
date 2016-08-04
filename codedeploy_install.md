# bundle install 시 아래 에러시 해결 방법

```
$ bundle install
/usr/share/ruby/vendor_ruby/2.0/rubygems/core_ext/kernel_require.rb:55:in`require ': can not load such file - io / console (LoadError)
	from /usr/share/ruby/vendor_ruby/2.0/rubygems/core_ext/kernel_require.rb:55:in`require '
	from /home/ec2-user/.gem/ruby/2.0/gems/bundler-1.10.6/lib/bundler/vendor/thor/lib/thor/shell/basic.rb:2:in`<top (required) > '
	from /usr/share/ruby/vendor_ruby/2.0/rubygems/core_ext/kernel_require.rb:55:in`require '
	from /usr/share/ruby/vendor_ruby/2.0/rubygems/core_ext/kernel_require.rb:55:in`require '
	from /home/ec2-user/.gem/ruby/2.0/gems/bundler-1.10.6/lib/bundler/vendor/thor/lib/thor/shell/color.rb:1:in`<top (required) > '
	from /home/ec2-user/.gem/ruby/2.0/gems/bundler-1.10.6/lib/bundler/vendor/thor/lib/thor/shell.rb:17:in`shell '
	from /home/ec2-user/.gem/ruby/2.0/gems/bundler-1.10.6/lib/bundler/ui/shell.rb:14:in`initialize '
	from /home/ec2-user/.gem/ruby/2.0/gems/bundler-1.10.6/lib/bundler/cli.rb:12:in`new '
	from /home/ec2-user/.gem/ruby/2.0/gems/bundler-1.10.6/lib/bundler/cli.rb:12:in`rescue in start '
	from /home/ec2-user/.gem/ruby/2.0/gems/bundler-1.10.6/lib/bundler/cli.rb:10:in`start '
	from /home/ec2-user/.gem/ruby/2.0/gems/bundler-1.10.6/bin/bundle:20:in`block in <top (required)> '
	from /home/ec2-user/.gem/ruby/2.0/gems/bundler-1.10.6/lib/bundler/friendly_errors.rb:7:in`with_friendly_errors '
	from /home/ec2-user/.gem/ruby/2.0/gems/bundler-1.10.6/bin/bundle:18:in`<top (required)> '
	from / home / ec2-user / bin / bundle : 23 : in`load '
	from / home / ec2-user / bin / bundle : 23 : in`<main> '
```


	
# aws-codedeploy-agent 설치

```
git clone https://github.com/aws/aws-codedeploy-agent.git
gem install bundler
cd aws-codedeploy-agent
bundle install
rake clean && rake
```
