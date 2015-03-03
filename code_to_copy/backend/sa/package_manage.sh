#!/usr/bin/env bash



# Red hat 系列

#查看所有安装的包
rpm -q #系列
    a: # 查看所有installed包
    f: # 查看哪个包装的
    l: # 查看这个installed包装了什么
    pl: # 查看包内的内容, p是provides

# 看是 *哪个repo* 安装的这个包
yum list packagename




# 制作RPM包 BEGIN ===================================

# 最简rpm包
http://manyrootsofallevilrants.blogspot.hk/2012/06/build-simple-rpm-that-packages-single.html

# 安装
yum install yum-utils rpmdevtools
# 建立目录结构
rpmdev-setuptree

# 编辑 XXX.spec， 内容参考附件
在SPECS中编辑
每个阶段都是用shell命令

# 在 SOURCES 中放入源码
坑
    压缩包文件需要带上版本号: 格式是 Name-Version qiyi-xapi-1.0

# 得到RPM包， 在RPMS中
rpmbuild -bb ../SPECS/xapi.spec

# 制作RPM包 END   ===================================






# Debian 系列

echo vsftpd hold | sudo dpkg --set-selections # 设置某个包不参与自动升级, dpkg --get-selections可以看看目前的情况












#==================XXX.spec样式=========================================

Name:          qiyi-xapi
Version:       1.0
Release:        0
Summary:        Qiyi vcut Packages for Enterprise Linux

Group:         System Environment/Base
License:        GPLv2
Source0:        qiyi-xapi.tar.gz
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
BuildArch:      noarch


%description

%prep
%setup -q
rm -rf $RPM_BUILD_ROOT

%build

%install
# installfiles from tar to $RPM_BUILD_ROOT, files in $RPM_BUILD_ROOT will be installed
install -m 0755 -d $RPM_BUILD_ROOT/etc/xapi.d/plugins
for file in plugins/*; do
        install -m 0755 $file $RPM_BUILD_ROOT/etc/xapi.d/plugins/
done

%clean
rm -rf $RPM_BUILD_ROOT

%files
# files to be installed
%defattr(-,root,root,-)
# directories should lead by %dir
/etc/xapi.d/plugins
%doc

%changelog
