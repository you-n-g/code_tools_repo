# pip
python setup.py build -f #的输出结果最后 的 PIL 1.1.7 SETUP SUMMARY 注意看看依赖是否都满足

# MySQL-python
MySQL-python 的安装需要依赖 libmysqld-dev libmysqlclient-dev...


# PIL
PIL 的安装如果要使用字体，编译的时候必须带入libfreetype
此库在 ubuntu 下叫 libfreetype6-dev
我编译的时候是通过在 setup.py 加入下行解决的。
FREETYPE_ROOT = "/usr/lib/i386-linux-gnu/"

# 快速部署一台ubuntu 服务器
# 1)
# 一般机器初始安装的软件 (一般要先update一下)
sudo apt-get install bash-completion dialog memcached python-memcache mercurial build-essential nginx php6-cgi  spawn-fcgi python-django python-imaging python-flup rcconf python-mysqldb screen vim  mysql-server phpmyadmin uwsgi-plugin-python unzip
# 可选  postfix mailutils
# 2)
# 配置rc.local
# 3)
# 配置vimrc
# 4) 
# 配置phpmyadmin, 配置一下mysql的编码问题