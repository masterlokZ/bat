# 安装 Caddy
curl -s https://getcaddy.com | bash -s personal

# 创建 WebDAV 目录并设置权限
sudo mkdir -p /var/www/webdav
sudo chmod 777 /var/www/webdav

# 修改 Caddyfile 配置
echo '
dav.999962.xyz {
    root * /var/www/webdav
    file_server

    # WebDAV 配置
    @webdav {
        path /
    }
    handle @webdav {
        webdav {
            allow_methods PROPFIND OPTIONS GET HEAD POST PUT DELETE
        }
    }

    # 配置基本认证
    basicauth / docker Xyw5201314
}
' | sudo tee /etc/caddy/Caddyfile

# 启动 Caddy 服务并设置开机自启
sudo systemctl start caddy
sudo systemctl enable caddy
