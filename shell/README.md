```
docker build . -t shell
cd into-your-app-folder
docker run --privileged  -it -p 3000:3000 -v `pwd`:/home/workspace  -v /var/run/docker.sock:/var/run/docker.sock -v ~/.ssh/id_ed25519:/home/workspace/.ssh/id_ed25519 ~/.aws:/home/workspace/.aws shell
```
