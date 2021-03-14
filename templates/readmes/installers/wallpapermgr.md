## GEN_SCRIPT_REPLACE_APPNAME
  
  DESCRIBE:
  
Requires scripts to be installed: sudo bash -c "$(curl -LSs https://github.com/wallpapermgr/installer/raw/master/install.sh)" && sudo wallpapermgr install installer
Automatic install/update:  
```shell
wallpapermgr install GEN_SCRIPT_REPLACE_APPNAME
```
OR  
```shell
bash -c "$(curl -LSs https://github.com/wallpapermgr/GEN_SCRIPT_REPLACE_APPNAME/raw/master/install.sh)"
```
  
Manual install:  
```shell
git clone https://github.com/wallpapermgr/GEN_SCRIPT_REPLACE_APPNAME "$HOME/.local/share/CasjaysDev/wallpapermgr/GEN_SCRIPT_REPLACE_APPNAME"
rsync -avhP "$HOME/.local/share/CasjaysDev/wallpapermgr/GEN_SCRIPT_REPLACE_APPNAME/images/." "$HOME/.local/share/wallpapers/GEN_SCRIPT_REPLACE_APPNAME" --delete
```
  
Manual update:    
```shell
git -C "$HOME/.local/share/CasjaysDev/wallpapermgr/GEN_SCRIPT_REPLACE_APPNAME" pull
rsync -avhP "$HOME/.local/share/CasjaysDev/wallpapermgr/GEN_SCRIPT_REPLACE_APPNAME/images/." "$HOME/.local/share/wallpapers/GEN_SCRIPT_REPLACE_APPNAME" --delete
```
