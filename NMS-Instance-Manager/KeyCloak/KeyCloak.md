# KeyCloak Configurations

![Under Construction Green](../../Image/UnderConstructionGreen.svg)

<br><br><br>

***

![Under Construction Yellow](../../Image/UnderConstructionYellow.svg)

<br><br><br>

***

![Under Construction Red](../../Image/UnderConstructionRed.svg)

<br><br><br>

***

KeyCloak References :
- [ ] [KeyCloak Getting Started](https://www.keycloak.org/getting-started/getting-started-zip)
- [ ] [KeyCloak Guides](https://www.keycloak.org/guides#getting-started)
- [ ] [KeyCloak GitHub](https://github.com/keycloak/keycloak-quickstarts)
- [ ] [Lab Sample Integration to NGINX+](https://clouddocs.f5.com/training/community/nginx/html/class9/class9.html)
- [ ] [KeyCloak Admin API version 16.1](https://www.keycloak.org/docs-api/16.1/rest-api/)
- [ ] [KeyCloak Admin API version 21.1.0](https://www.keycloak.org/docs-api/21.1.0/rest-api/)

<br><br><br>

Once you've successfully installed KeyCloak, you need to configure it to integrate with your application or in this repository purpose to your application-gateway (i.e. NGINX+).
The main and high level procedure can be seen in [Lab Sample Integration to NGINX+](https://clouddocs.f5.com/training/community/nginx/html/class9/class9.html), which is done through manual interaction using KeyCloak's GUI, on version 16.1.1 at the time of writing this repository.
However this repository target is to automate these steps using scripts towards KeyCloak Admin API, so no manual interaction needed.
And since at the time of writing this repository, the current version of KeyCloak is version 21.1.0, that's the version the scripts are using.

This section of repository only notes some learning I gathered during building the scripts.
Basically only a collections of commands to reach certain goals, what's working and what's not working.
The notes here follow the main and high level procedure described in [Lab Sample Integration to NGINX+](https://clouddocs.f5.com/training/community/nginx/html/class9/class9.html).

First step on using the KeyCloak Admin API, is to obtain the admin's credential/token, so we can access the rest of the endpoints functions provided by the KeyCloak Admin API.

```
curl --location --request POST http://192.168.123.203:8080/realms/master/protocol/openid-connect/token --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'username=admin' --data-urlencode 'password=admin' --data-urlencode 'grant_type=password' --data-urlencode 'client_id=admin-cli'
```

Example:

```
ubuntu@Client:~$ curl --location --request POST http://192.168.123.203:8080/realms/master/protocol/openid-connect/token --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'username=admin' --data-urlencode 'password=admin' --data-urlencode 'grant_type=password' --data-urlencode 'client_id=admin-cli'
{"access_token":"eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJ2N0FnRklULTkxaVVzQVo4Q195TE1wWHhaREVWdWJhSWMyc2p1YnNfLUZRIn0.eyJleHAiOjE2ODIxNDc1NjksImlhdCI6MTY4MjE0NzUwOSwianRpIjoiYWIwMzRmNmEtMjQ1OS00ODQ1LWFjZjMtZThlODEwNDQ1NWFlIiwiaXNzIjoiaHR0cDovLzE5Mi4xNjguMTIzLjIwMzo4MDgwL3JlYWxtcy9tYXN0ZXIiLCJzdWIiOiI0ZDgyM2U3NS0wY2U1LTRkZjgtYTllMC01MGNjMzc1NGY5MTgiLCJ0eXAiOiJCZWFyZXIiLCJhenAiOiJhZG1pbi1jbGkiLCJzZXNzaW9uX3N0YXRlIjoiMDgxOTQ5NjctNzI3OC00ODBmLTliZTctODQ0OTYyNjhkZWIxIiwiYWNyIjoiMSIsInNjb3BlIjoicHJvZmlsZSBlbWFpbCIsInNpZCI6IjA4MTk0OTY3LTcyNzgtNDgwZi05YmU3LTg0NDk2MjY4ZGViMSIsImVtYWlsX3ZlcmlmaWVkIjpmYWxzZSwicHJlZmVycmVkX3VzZXJuYW1lIjoiYWRtaW4ifQ.KlE3gMtHdm6ptEQJfVTqdmy7amJ7Bh0Z-_W-t8dfJXxo-xeFi1y-Z1l4Egs73rHpTYjbZXiuDPg3-SjFnMwfx8ibSr1_wwg7Bjkl35A_PR-yArGGlUTt1poeGyp4dgdkvvk1lz4n7gxNY77IWY4AEfr60a6ASH7Qe-lo982IwEfrDdYzAvGyiGAUPgiSU8xuaV5QAaGmPn0KdD3HXe57wrjoJDAOTUYejWS9qcAATn9JvnKpd_IKIH-v-zxzU8hs3qxJ7DHfF9yk5zDX7u3UCDhNGyjYdx5D5p0Jhpa8XJ4skxXuosiwgDYc3rKLWZOGtendm3OXkUiF8gsSGVrOKQ","expires_in":60,"refresh_expires_in":1800,"refresh_token":"eyJhbGciOiJIUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmYTMxNWU2ZS1iNjIxLTQ5MjEtYWVjMi0xNjhlZjUwYWZjNzIifQ.eyJleHAiOjE2ODIxNDkzMDksImlhdCI6MTY4MjE0NzUwOSwianRpIjoiN2Y0YTMyZmEtYTkwOS00M2E4LTllZjMtYzNjYTgwNDUxNTgwIiwiaXNzIjoiaHR0cDovLzE5Mi4xNjguMTIzLjIwMzo4MDgwL3JlYWxtcy9tYXN0ZXIiLCJhdWQiOiJodHRwOi8vMTkyLjE2OC4xMjMuMjAzOjgwODAvcmVhbG1zL21hc3RlciIsInN1YiI6IjRkODIzZTc1LTBjZTUtNGRmOC1hOWUwLTUwY2MzNzU0ZjkxOCIsInR5cCI6IlJlZnJlc2giLCJhenAiOiJhZG1pbi1jbGkiLCJzZXNzaW9uX3N0YXRlIjoiMDgxOTQ5NjctNzI3OC00ODBmLTliZTctODQ0OTYyNjhkZWIxIiwic2NvcGUiOiJwcm9maWxlIGVtYWlsIiwic2lkIjoiMDgxOTQ5NjctNzI3OC00ODBmLTliZTctODQ0OTYyNjhkZWIxIn0.e3RZAu1vz3HyNOXBY4QhDt6r7JLcu-AhgLu-ygAuugY","token_type":"Bearer","not-before-policy":0,"session_state":"08194967-7278-480f-9be7-84496268deb1","scope":"profile email"}
ubuntu@Client:~$
```




<br><br><br>

***

Snippet for KeyCloak Installation:

`cd $HOME;sudo curl -k -L -O --retry 333 https://raw.githubusercontent.com/gjwdyk/NGINX-Notes/main/NMS-Instance-Manager/KeyCloak/KeyCloakInstall.sh;sudo chmod 777 $HOME/KeyCloakInstall.sh;/bin/bash $HOME/KeyCloakInstall.sh`



<br><br><br>

***

<br><br><br>
```
╔═╦═════════════════╦═╗
╠═╬═════════════════╬═╣
║ ║ End of Document ║ ║
╠═╬═════════════════╬═╣
╚═╩═════════════════╩═╝
```
<br><br><br>


