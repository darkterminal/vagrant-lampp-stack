![Vagrant LAMPP Stack](https://i.ibb.co/5WTFmm9/repo-cover.png "Repository Cover")

# Vagrant LAMPP
This is a setup environment for web development. The `vagrant box` using `ubuntu/xenial64`.

## Feature
- Git version 2.7.4
- PHP 7.4.16
- MySQL Ver 14.14 Distrib 5.7.33, for Linux (x86_64)
- Apache2 Server version: Apache/2.4.46 (Ubuntu)
- PhpMyAdmin 5.1.0 - English

## System Requirements
- VirtualBox >= 6.1
- Vagrant >= 2.2.14

## Installing
You can use terminal (CMD, PowerShell, Git-Bash)
```
$ git clone git@gitlab.com:darkterminal/vagrant-lampp-stack.git
```
And if you want to change directory name are `clone` you can use this command
```
$ git clone git@gitlab.com:darkterminal/vagrant-lampp-stack.git <your-app-name>
```

## Default Kridensial
- The URLs
	- Apache2 Web Server: `localhost:8181`
	- MySQL Server port: `3306`
		- Username: `root`
		- Password: `root`
	- PhpMyAdmin: `localhost:8181/phpmyadmin`
		- Username: `root`
		- Password: `root`

## Optional Configuration (After Vagrant Up / Vagrant provision)

**Blowfish Secret**

If you facing warning in PhpMyAdmin page about `$cfg['blowfish_secret']`. You can configure with follow this step:
1. Make sure you are inside root directory that contain `Vagrantfile`
	- 1.1 Open terminal (Git-Bash, Cygwin, or Terminal) inside
	- 1.2 type command `vagrant ssh`
	- 1.3 after vagrant has been logged in, type command `sudo nano /usr/share/phpmyadmin/config.inc.php`
	- 1.4 Create Blowfish Secret in `https://hash.online-convert.com/blowfish-generator`
	- 1.5 Paste in `config.inc.php` you just open
        ```
        <?php
        /* vim: set expandtab sw=4 ts=4 sts=4: */
        /**
        * phpMyAdmin sample configuration, you can use it as base for
        * manual configuration. For easier setup you can use setup/
        $cfg['blowfish_secret'] = 'your-blowfish-secrect';
        /**
        ```
	- 1.6 Scroll down the file and add a temp directory config line as shown below:
        ```
        /**
        * End of servers configuration
        */
        * Directories for saving/loading files from server
        */
        $cfg['UploadDir'] = '';
        $cfg['SaveDir'] = '';
        $cfg['TempDir'] = '/var/lib/phpmyadmin/tmp'; // <== Add this line
        /**
        ```
	- 1.7 Save the file and exit
2. When you’re done… run the commands below to great phpMyAdmin Apache2 configuration file.
	- 2.1 type command in terminal `sudo nano /etc/apache2/conf-enabled/phpmyadmin.conf`
    ```
    Alias /phpmyadmin /usr/share/phpmyadmin

    <Directory /usr/share/phpmyadmin>
        Options SymLinksIfOwnerMatch
        DirectoryIndex index.php

        <IfModule mod_php5.c>
            <IfModule mod_mime.c>
                AddType application/x-httpd-php .php
            </IfModule>
            <FilesMatch ".+\.php$">
                SetHandler application/x-httpd-php
            </FilesMatch>

            php_value include_path .
            php_admin_value upload_tmp_dir /var/lib/phpmyadmin/tmp
            php_admin_value open_basedir /usr/share/phpmyadmin/:/etc/phpmyadmin/:/var/lib/phpmyadmin/:/usr/share/php/php-gettext/:/usr/share/php/php-php-gettext/:/usr/share/javascript/:/usr/share/php/tcpdf/:/usr/share/doc/phpmyadmin/:/usr/share/php/phpseclib/
            php_admin_value mbstring.func_overload 0
        </IfModule>
        <IfModule mod_php.c>
            <IfModule mod_mime.c>
                AddType application/x-httpd-php .php
            </IfModule>
            <FilesMatch ".+\.php$">
                SetHandler application/x-httpd-php
            </FilesMatch>

            php_value include_path .
            php_admin_value upload_tmp_dir /var/lib/phpmyadmin/tmp
            php_admin_value open_basedir /usr/share/phpmyadmin/:/etc/phpmyadmin/:/var/lib/phpmyadmin/:/usr/share/php/php-gettext/:/usr/share/php/php-php-gettext/:/usr/share/javascript/:/usr/share/php/tcpdf/:/usr/share/doc/phpmyadmin/:/usr/share/php/phpseclib/
            php_admin_value mbstring.func_overload 0
        </IfModule>

    </Directory>

    # Authorize for setup
    <Directory /usr/share/phpmyadmin/setup>
        <IfModule mod_authz_core.c>
            <IfModule mod_authn_file.c>
                AuthType Basic
                AuthName "phpMyAdmin Setup"
                AuthUserFile /etc/phpmyadmin/htpasswd.setup
            </IfModule>
            Require valid-user
        </IfModule>
    </Directory>

    # Disallow web access to directories that don't need it
    <Directory /usr/share/phpmyadmin/templates>
        Require all denied
    </Directory>
    <Directory /usr/share/phpmyadmin/libraries>
        Require all denied
    </Directory>
    <Directory /usr/share/phpmyadmin/setup/lib>
        Require all denied
    </Directory>
    ```
    - 2.2 Save the file and exit
    - 2.3 Restart your server by typing `sudo service apache2 reload`
