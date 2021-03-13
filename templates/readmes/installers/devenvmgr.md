## REPLACE_APPNAME
  
  DESCRIBE:
  
Requires scripts to be installed: sudo bash -c "$(curl -LSs https://github.com/dfmgr/installer/raw/master/install.sh)" && sudo dfmgr install installer  
  Automatic install/update:  
```shell
devenvmgr install REPLACE_APPNAME
```
OR  
```shell
bash -c "$(curl -LSs https://github.com/devenvmgr/REPLACE_APPNAME/raw/master/install.sh)"
```
  
Manual install:  
```shell
git clone https://github.com/devenvmgr/REPLACE_APPNAME "$HOME/.local/share/CasjaysDev/devenvmgr/REPLACE_APPNAME"
rsync -avhP "$HOME/.local/share/CasjaysDev/devenvmgr/REPLACE_APPNAME/." "MyProject" --exclude=*/.git/*
```
  
Manual update:  
```shell
git -C "$HOME/.local/share/CasjaysDev/devenvmgr/REPLACE_APPNAME" pull
```

