## GEN_SCRIPT_REPLACE_APPNAME
  
  DESCRIBE:
  
Requires scripts to be installed: sudo bash -c "$(curl -LSs https://github.com/thememgr/installer/raw/master/install.sh)" && sudo thememgr install installer  
Automatic install/update:    
```shell
thememgr install GEN_SCRIPT_REPLACE_APPNAME
```
OR  
```shell
bash -c "$(curl -LSs https://github.com/thememgr/GEN_SCRIPT_REPLACE_APPNAME/raw/master/install.sh)"
```
  
Manual install:  
```shell
git clone https://github.com/thememgr/GEN_SCRIPT_REPLACE_APPNAME "$HOME/.local/share/CasjaysDev/thememgr/GEN_SCRIPT_REPLACE_APPNAME"
rsync -avhP "$HOME/.local/share/CasjaysDev/thememgr/GEN_SCRIPT_REPLACE_APPNAME/theme/." "$HOME/.local/share/themes/GEN_SCRIPT_REPLACE_APPNAME" --delete
```
  
Manual update:  
```shell
git -C "$HOME/.local/share/CasjaysDev/thememgr/GEN_SCRIPT_REPLACE_APPNAME" pull
rsync -avhP "$HOME/.local/share/CasjaysDev/thememgr/GEN_SCRIPT_REPLACE_APPNAME/theme/." "$HOME/.local/share/themes/GEN_SCRIPT_REPLACE_APPNAME" --delete
```
