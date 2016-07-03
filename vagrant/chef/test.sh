cd ~
curl -L https://www.opscode.com/chef/install.sh | bash
chef-solo -v

wget http://github.com/opscode/chef-repo/tarball/master
tar -zxf master
mv chef-chef-repo* chef-repo
rm master

cd chef-repo/
mkdir .chef
echo '"cookbook_path [ '/root/chef-repo/cookbooks' ]"' >> .chef/knife.rb

knife cookbook create phpapp

cd cookbooks/phpapp

cd ..

knife cookbook site download apache2
tar zxf apache2*
rm apache2*.tar.gz

knife cookbook site download apt
tar zxf apt*
rm apt*.tar.gz

knife cookbook site download iptables
tar zxf iptables*
rm iptables*.tar.gz

knife cookbook site download logrotate
tar zxf logrotate*
rm logrotate*.tar.gz

knife cookbook site download pacman
tar zxf pacman*
rm pacman*.tar.gz

cd phpapp

echo 'depends "apache2"' >> ~/chef-repo/cookbooks/metadata.rb

echo 'include_recipe "apache2"' >> ~/chef-repo/cookbooks/apache2/recipes/default.rb
echo 'apache_site "default" do' >> ~/chef-repo/cookbooks/apache2/recipes/default.rb
echo '  enable true' >> ~/chef-repo/cookbooks/apache2/recipes/default.rb
echo 'end' >> ~/chef-repo/cookbooks/apache2/recipes/default.rb

cd ../..

echo 'file_cache_path "/root/chef-solo"' >> ~/chef-repo/solo.rb
echo 'cookbook_path "/root/chef-repo/cookbooks"' >> ~/chef-repo/solo.rb

echo '{' >> ~/chef-repo/web.json
echo '  "run_list": [ "recipe[apt]", "recipe[phpapp]" ]' >> ~/chef-repo/web.json
echo '}' >> ~/chef-repo/web.json

chef-solo -c solo.rb -j web.json
