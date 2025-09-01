```
git clone git@github.com:wuqiang0720/docker-ovs-plugin.git
export GO111MODULE=off
export GOPATH=$HOME/docker-ovs-plugin/Godeps/_workspace
export GOPATH=$HOME/go
cd $GOPATH/src/github.com

# logrus
git clone git@github.com:Sirupsen/logrus.git

# cli
git clone git@github.com:codegangsta/cli.git

# dknet
git clone git@github.com:gopher-net/dknet.git

cp -r ovs/ Godeps/_workspace/src/github.com/gopher-net/docker-ovs-plugin/


go build -o docker-ovs-plugin ./main.go

```
