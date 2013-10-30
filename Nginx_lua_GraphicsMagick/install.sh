yum install readline readline-devel

wget http://www.lua.org/ftp/lua-5.1.4.tar.gz
cd lua-5.1.4
make linux && make install;

git clone https://github.com/chaoslawful/lua-nginx-module.git

git clone https://github.com/simpl/ngx_devel_kit.git


# add lua socket module
wget http://luarocks.org/releases/luarocks-2.1.0.tar.gz
cd luarocks-2.1.0
./configure
make && make install;

luarocks istall luasocket

wget http://nginx.org/download/nginx-1.4.3.tar.gz

# install gm
#GraphicsMagick-1.3.18
#./configure  '--prefix=/usr/local/GraphicsMagick/' '--enable-openmp-slow' '--enable-shared'


# /root/lua/lua-nginx-module
# /root/lua/ngx_devel_kit


