#cloud-config

write_files:
- path: /var/www/html/index.html
  permissions: '0644'
  owner: root:root
  content: |
    ---
    <html xmlns="http://www.w3.org/1999/xhtml" >
      <head>
          <title>My Website Home Page</title>
      </head>
      <body>
        <h1>Welcome to my website</h1>
        <Img src='https://dawn-test.s3.eu-west-1.amazonaws.com/jpeg/winetour.jpg' width="400" height="400" />
        <p>Now hosted on Amazon S3!</p>
      </body>
      </html>

runcmd:
  - sudo yum install -y httpd
  - systemctl enable --no-block httpd
  - systemctl start --no-block httpd

