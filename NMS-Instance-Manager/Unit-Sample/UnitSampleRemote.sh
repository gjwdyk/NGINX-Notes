#!/bin/bash -xe

cd $HOME

let counter=0;while ( (sudo lsof /var/cache/apt/archives/lock) || (sudo lsof /var/lib/apt/lists/lock) || (sudo lsof /var/lib/dpkg/lock*) || ((`(ps aux -A | grep -i -c "apt")` > 1)) );do let counter++;echo "$counter";if (sudo lsof /var/cache/apt/archives/lock);then printf "$counter sudo lsof /var/cache/apt/archives/lock\n`sudo lsof /var/cache/apt/archives/lock`\n";fi;if (sudo lsof /var/lib/apt/lists/lock);then printf "$counter sudo lsof /var/lib/apt/lists/lock\n`sudo lsof /var/lib/apt/lists/lock`\n";fi;if (sudo lsof /var/lib/dpkg/lock*);then printf "$counter sudo lsof /var/lib/dpkg/lock*\n`sudo lsof /var/lib/dpkg/lock*`\n";fi;if ((`(ps aux -A | grep -i -c "apt")` > 1));then printf "$counter ps aux -A | grep -i \"apt\"\n`ps aux -A | grep -i \"apt\"`\n";fi;sleep 1s;done
sudo apt-get install -y python3-pip
let counter=0;while ( (sudo lsof /var/cache/apt/archives/lock) || (sudo lsof /var/lib/apt/lists/lock) || (sudo lsof /var/lib/dpkg/lock*) || ((`(ps aux -A | grep -i -c "apt")` > 1)) );do let counter++;echo "$counter";if (sudo lsof /var/cache/apt/archives/lock);then printf "$counter sudo lsof /var/cache/apt/archives/lock\n`sudo lsof /var/cache/apt/archives/lock`\n";fi;if (sudo lsof /var/lib/apt/lists/lock);then printf "$counter sudo lsof /var/lib/apt/lists/lock\n`sudo lsof /var/lib/apt/lists/lock`\n";fi;if (sudo lsof /var/lib/dpkg/lock*);then printf "$counter sudo lsof /var/lib/dpkg/lock*\n`sudo lsof /var/lib/dpkg/lock*`\n";fi;if ((`(ps aux -A | grep -i -c "apt")` > 1));then printf "$counter ps aux -A | grep -i \"apt\"\n`ps aux -A | grep -i \"apt\"`\n";fi;sleep 1s;done
sudo pip install --retries 333 flask
let counter=0;while ( (sudo lsof /var/cache/apt/archives/lock) || (sudo lsof /var/lib/apt/lists/lock) || (sudo lsof /var/lib/dpkg/lock*) || ((`(ps aux -A | grep -i -c "apt")` > 1)) );do let counter++;echo "$counter";if (sudo lsof /var/cache/apt/archives/lock);then printf "$counter sudo lsof /var/cache/apt/archives/lock\n`sudo lsof /var/cache/apt/archives/lock`\n";fi;if (sudo lsof /var/lib/apt/lists/lock);then printf "$counter sudo lsof /var/lib/apt/lists/lock\n`sudo lsof /var/lib/apt/lists/lock`\n";fi;if (sudo lsof /var/lib/dpkg/lock*);then printf "$counter sudo lsof /var/lib/dpkg/lock*\n`sudo lsof /var/lib/dpkg/lock*`\n";fi;if ((`(ps aux -A | grep -i -c "apt")` > 1));then printf "$counter ps aux -A | grep -i \"apt\"\n`ps aux -A | grep -i \"apt\"`\n";fi;sleep 1s;done
sudo pip install --retries 333 flasgger
let counter=0;while ( (sudo lsof /var/cache/apt/archives/lock) || (sudo lsof /var/lib/apt/lists/lock) || (sudo lsof /var/lib/dpkg/lock*) || ((`(ps aux -A | grep -i -c "apt")` > 1)) );do let counter++;echo "$counter";if (sudo lsof /var/cache/apt/archives/lock);then printf "$counter sudo lsof /var/cache/apt/archives/lock\n`sudo lsof /var/cache/apt/archives/lock`\n";fi;if (sudo lsof /var/lib/apt/lists/lock);then printf "$counter sudo lsof /var/lib/apt/lists/lock\n`sudo lsof /var/lib/apt/lists/lock`\n";fi;if (sudo lsof /var/lib/dpkg/lock*);then printf "$counter sudo lsof /var/lib/dpkg/lock*\n`sudo lsof /var/lib/dpkg/lock*`\n";fi;if ((`(ps aux -A | grep -i -c "apt")` > 1));then printf "$counter ps aux -A | grep -i \"apt\"\n`ps aux -A | grep -i \"apt\"`\n";fi;sleep 1s;done
sudo pip install --retries 333 gitpython

sudo mkdir -p /www
sudo git clone -b main https://github.com/gjwdyk/git-pull-api /www/git-pull-api
# sudo git clone -b main https://github.com/codecowboydotio/git-pull-api /www/git-pull-api

sudo curl -X PUT --data '{ "type": "python", "path": "/www/git-pull-api/", "module": "wsgi", "callable": "app", "environment": { "version": "2.0", "git_repo": "https://github.com/gjwdyk/git-pull-api" } }' http://localhost:43210/config/applications/python/
sudo curl -X PUT --data '{ "pass": "applications/python" }' http://localhost:43210/config/listeners/*:12345/



sudo chmod 777 /www
sudo curl -X POST http://localhost:12345/pull -d '{"repo": "https://github.com/gjwdyk/pacman-unit", "dest": "/www/pacman-unit", "branch": "main"}'
# sudo git clone -b main https://github.com/gjwdyk/pacman-unit /www/pacman-unit
# sudo git clone -b main https://github.com/codecowboydotio/pacman-unit /www/pacman-unit

sudo curl -X PUT --data '{}' http://localhost:43210/config/routes/
sudo curl -X PUT --data '[ { "action": {"share": "/www/pacman-unit/$uri" } } ]' http://localhost:43210/config/routes/pacman/
sudo curl -X PUT --data '{ "pass": "routes/pacman" }' http://localhost:43210/config/listeners/*:8080/



sudo mkdir -p /www/Java
sudo chmod 777 /www/Java

sudo curl -k -L --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/Unit-Sample/Java/sample.war --output /www/Java/sample.war
sudo curl -X PUT --data '{ "type": "java", "webapp": "/www/Java/sample.war", "environment": { "version": "3.0", "git_repo": "https://github.com/gjwdyk/NGINX-Notes/tree/main/NMS-Instance-Manager/Unit-Sample/Java" } }' http://localhost:43210/config/applications/javahelloworld1/
sudo curl -X PUT --data '{ "pass": "applications/javahelloworld1" }' http://localhost:43210/config/listeners/*:8101/

sudo curl -k -L --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/Unit-Sample/Java/SampleWebApp.war --output /www/Java/SampleWebApp.war
sudo curl -X PUT --data '{ "type": "java", "webapp": "/www/Java/SampleWebApp.war", "environment": { "version": "3.0", "git_repo": "https://github.com/gjwdyk/NGINX-Notes/tree/main/NMS-Instance-Manager/Unit-Sample/Java" } }' http://localhost:43210/config/applications/javahelloworld2/
sudo curl -X PUT --data '{ "pass": "applications/javahelloworld2" }' http://localhost:43210/config/listeners/*:8102/

sudo curl -k -L --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/Unit-Sample/Java/helloworld.war --output /www/Java/helloworld.war
sudo curl -X PUT --data '{ "type": "java", "webapp": "/www/Java/helloworld.war", "environment": { "version": "3.0", "git_repo": "https://github.com/gjwdyk/NGINX-Notes/tree/main/NMS-Instance-Manager/Unit-Sample/Java" } }' http://localhost:43210/config/applications/javahelloworld3/
sudo curl -X PUT --data '{ "pass": "applications/javahelloworld3" }' http://localhost:43210/config/listeners/*:8103/



sudo chmod 777 /usr/share/doc/unit-go/examples/go-app/
GOPATH=/usr/share/gocode go build -o /usr/share/doc/unit-go/examples/go-app/go-app /usr/share/doc/unit-go/examples/go-app/let-my-people.go
sudo curl -X PUT --data '{ "type": "external", "executable": "/usr/share/doc/unit-go/examples/go-app/go-app" }' http://localhost:43210/config/applications/example_go/
sudo curl -X PUT --data '{ "pass": "applications/example_go" }' http://localhost:43210/config/listeners/*:8600/



#╔══════════╗
#║   Test   ║
#╚══════════╝

journalctl -u unit.service -b --no-pager
sudo cat /var/log/unit.log

sudo curl -X GET http://localhost:43210/



#╔═╦═════════════════╦═╗
#║ ║                 ║ ║
#╠═╬═════════════════╬═╣
#║ ║ End of Document ║ ║
#╠═╬═════════════════╬═╣
#║ ║                 ║ ║
#╚═╩═════════════════╩═╝


