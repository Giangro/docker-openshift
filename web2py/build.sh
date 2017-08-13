sudo docker stop my_web2py
sudo docker rm my_web2py
sudo docker volume ls -qf dangling=true | xargs -r docker volume rm
sudo docker build -t alex/web2py_alpine:latest -t alex/web2py_alpine:v1.0  .
