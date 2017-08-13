sudo docker stop my_alpine
sudo docker rm my_alpine
sudo docker volume ls -qf dangling=true | xargs -r docker volume rm
sudo docker build -t alex/my_alpine:latest -t alex/my_alpine:v1.0  .
