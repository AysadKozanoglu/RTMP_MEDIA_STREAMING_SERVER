#! /bin/bash
#
# coded by Aysad Kozanoglu
#
# email: aysadx@gmail.com
# web  : http://onweb.pe.hu
#
# auto installer script for 
# nginx rtmp live hls streaming server 
#
#

clear

nginxpath="/usr/local/nginx"
tmppath="/tmp/rtmp_install"

echo"nginx rtmp hls live streaming Server Installation"
echo "           by Aysad Kozanoglu"
echo"================================================="
echo "" 
echo "updating sourcelist.."

apt-get update  > /dev/null 2>&1
apt-get install build-essential libpcre3 libpcre3-dev git zlib1g-dev zlib1g -y  > /dev/null 2>&1

rm -rf $tmppath > dev/null 2>&1
mkdir $tmppath  > /dev/null 2>&1
cd $tmppath

echo "getting needed sources with cloning..."

git clone git://github.com/AysadKozanoglu/nginx-rtmp-module.git
git clone git://github.com/AysadKozanoglu/RTMP_MEDIA_STREAMING_SERVER.git
wget -q http://nginx.org/download/nginx-1.10.1.tar.gz
wget -q https://www.openssl.org/source/old/0.9.x/openssl-0.9.8zf.tar.gz

tar zxf openssl-0.9.8zf.tar.gz
tar zxf nginx-1.10.1.tar.gz
echo "configure make "

chmod a+x $tmppath/nginx/configure

cd $tmppath/nginx-1.10.1/
echo "installing rtmp hls server. it can take more than one minute. please wait until done... "
                                                #--user=rtmp-user --group=rtmp-user
./configure --add-module=$tmppath/nginx-rtmp-module --with-openssl=$tmppath/openssl-0.9.8zf && make  && make install

mkdir $nginxpath/html/rtmp-hls
cp $tmppath/RTMP_MEDIA_STREAMING_SERVER/conf/nginx.txt  /etc/init.d/nginx && chmod a+x /etc/init.d/nginx

/usr/sbin/update-rc.d -f nginx defaults

cp $tmppath/RTMP_MEDIA_STREAMING_SERVER/www/stat.xsl $nginxpath/html/stat.xsl
cp $tmppath/RTMP_MEDIA_STREAMING_SERVER/conf/nginx.conf $nginxpath/conf/nginx.conf

#chown -R rtmp-user:rtmp-user $nginxpath/html/*

echo ""
netstat -tulpn | grep nginx 
ps auxf | grep ngin
echo ""
/etc/init.d/nginx start

echo ""
echo "--DONE--"
echo ""

