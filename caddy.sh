#!/bin/bash

# 更新包列表并安装必要的依赖
sudo apt update
sudo apt install -y curl tar apache2-utils

# 安装 xcaddy 工具
curl -s https://api.github.com/repos/caddyserver/xcaddy/releases/latest | grep browser_download_url | grep linux_amd64 | cut -d '"' -f 4 | xargs curl -o xcaddy.tar.gz
tar -xvf xcaddy.tar.gz
sudo mv xcaddy /usr/local/bin/

# 使用 xcaddy 构建 Caddy 并包含 WebDAV 插件
xcaddy build --with github.com/greenpau/caddy-webdav

# 将新构建的 Caddy 二进制文件移动到系统路径
sudo mv caddy /usr/local/bin/

# 创建 WebDAV 根目录
sudo mkdir -p /var/www/webdav
sudo chown -R www-data:www-data /var/www/webdav
sudo chmod -R 755 /var/www/webdav

# 生成 .htpasswd 文件
echo "admin:Xyw5201314" | sudo tee /etc/caddy/.htpasswd

# 创建 Caddy 配置文件
echo '
dav.999962.xyz {
    root * /var/www/webdav
    file_server

    # 配置 WebDAV
    webdav {
        path /webdav
        # WebDAV 权限
        auth_basic "Restricted"
        auth_basic_user_file /etc/caddy/.htpasswd
    }

    # Basic authentication
    basicauth /webdav {
        admin Xyw5201314
    }
}
' | sudo tee /etc/caddy/Caddyfile

# 重启 Caddy 服务
sudo systemctl restart caddy

# 检查 Caddy 状态
sudo systemctl status caddy
