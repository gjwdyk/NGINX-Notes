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

References :
- [ ] [KeyCloak Getting Started](https://www.keycloak.org/getting-started/getting-started-zip)
- [ ] [KeyCloak Guides](https://www.keycloak.org/guides#getting-started)
- [ ] [KeyCloak GitHub](https://github.com/keycloak/keycloak-quickstarts)
- [ ] [Lab Sample Integration to NGINX+](https://clouddocs.f5.com/training/community/nginx/html/class9/class9.html)
- [ ] [KeyCloak Admin API version 16.1](https://www.keycloak.org/docs-api/16.1/rest-api/)
- [ ] [KeyCloak Admin API version 21.1.0](https://www.keycloak.org/docs-api/21.1.0/rest-api/)
- [ ] [jq Documentation DevDocs](https://devdocs.io/jq/)
- [ ] [jq Manual (Development Version) GitHub](https://stedolan.github.io/jq/manual/)

<br><br><br>

Once you've successfully installed KeyCloak, you need to configure it to integrate with your application or in this repository purpose to your application-gateway (i.e. NGINX+).
The main and high level procedure can be seen in [Lab Sample Integration to NGINX+](https://clouddocs.f5.com/training/community/nginx/html/class9/class9.html), which is done through manual interaction using KeyCloak's GUI, on version 16.1.1 at the time of writing this repository.
However this repository target is to automate these steps using scripts towards KeyCloak Admin API, so no manual interaction needed.
And since at the time of writing this repository, the current version of KeyCloak is version 21.1.0, that's the version the scripts are using.

This section of repository only notes some learning I gathered during building the scripts.
Basically only a collections of commands to reach certain goals, what's working and what's not working.
The notes here follow the main and high level procedure described in [Lab Sample Integration to NGINX+](https://clouddocs.f5.com/training/community/nginx/html/class9/class9.html).

First step on using the KeyCloak Admin API, is to obtain the admin's token, so we can access the rest of the endpoints/functions provided by the KeyCloak Admin API.
In this example scenario, we assume the KeyCloak-Admin-API's Base-URL is `http://192.168.123.203:8080` ; which is also KeyCloak's Server's IP Address and the default port where KeyCloak's Web-based UI is listening.
You will also need to provide admin's username and admin's password in order to obtain admin's token (in this example case, both admin's username and admin's password are `admin`).
In this example scenario, we use only the default Realm `master`.
Below is the format/syntax to obtain the admin token.

```
curl --location --request POST http://192.168.123.203:8080/realms/master/protocol/openid-connect/token --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'username=admin' --data-urlencode 'password=admin' --data-urlencode 'grant_type=password' --data-urlencode 'client_id=admin-cli'
```

Example execution and result:

```
ubuntu@Client:~$ curl --location --request POST http://192.168.123.203:8080/realms/master/protocol/openid-connect/token --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'username=admin' --data-urlencode 'password=admin' --data-urlencode 'grant_type=password' --data-urlencode 'client_id=admin-cli'
{"access_token":"eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJ2N0FnRklULTkxaVVzQVo4Q195TE1wWHhaREVWdWJhSWMyc2p1YnNfLUZRIn0.eyJleHAiOjE2ODIxNDc1NjksImlhdCI6MTY4MjE0NzUwOSwianRpIjoiYWIwMzRmNmEtMjQ1OS00ODQ1LWFjZjMtZThlODEwNDQ1NWFlIiwiaXNzIjoiaHR0cDovLzE5Mi4xNjguMTIzLjIwMzo4MDgwL3JlYWxtcy9tYXN0ZXIiLCJzdWIiOiI0ZDgyM2U3NS0wY2U1LTRkZjgtYTllMC01MGNjMzc1NGY5MTgiLCJ0eXAiOiJCZWFyZXIiLCJhenAiOiJhZG1pbi1jbGkiLCJzZXNzaW9uX3N0YXRlIjoiMDgxOTQ5NjctNzI3OC00ODBmLTliZTctODQ0OTYyNjhkZWIxIiwiYWNyIjoiMSIsInNjb3BlIjoicHJvZmlsZSBlbWFpbCIsInNpZCI6IjA4MTk0OTY3LTcyNzgtNDgwZi05YmU3LTg0NDk2MjY4ZGViMSIsImVtYWlsX3ZlcmlmaWVkIjpmYWxzZSwicHJlZmVycmVkX3VzZXJuYW1lIjoiYWRtaW4ifQ.KlE3gMtHdm6ptEQJfVTqdmy7amJ7Bh0Z-_W-t8dfJXxo-xeFi1y-Z1l4Egs73rHpTYjbZXiuDPg3-SjFnMwfx8ibSr1_wwg7Bjkl35A_PR-yArGGlUTt1poeGyp4dgdkvvk1lz4n7gxNY77IWY4AEfr60a6ASH7Qe-lo982IwEfrDdYzAvGyiGAUPgiSU8xuaV5QAaGmPn0KdD3HXe57wrjoJDAOTUYejWS9qcAATn9JvnKpd_IKIH-v-zxzU8hs3qxJ7DHfF9yk5zDX7u3UCDhNGyjYdx5D5p0Jhpa8XJ4skxXuosiwgDYc3rKLWZOGtendm3OXkUiF8gsSGVrOKQ","expires_in":60,"refresh_expires_in":1800,"refresh_token":"eyJhbGciOiJIUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmYTMxNWU2ZS1iNjIxLTQ5MjEtYWVjMi0xNjhlZjUwYWZjNzIifQ.eyJleHAiOjE2ODIxNDkzMDksImlhdCI6MTY4MjE0NzUwOSwianRpIjoiN2Y0YTMyZmEtYTkwOS00M2E4LTllZjMtYzNjYTgwNDUxNTgwIiwiaXNzIjoiaHR0cDovLzE5Mi4xNjguMTIzLjIwMzo4MDgwL3JlYWxtcy9tYXN0ZXIiLCJhdWQiOiJodHRwOi8vMTkyLjE2OC4xMjMuMjAzOjgwODAvcmVhbG1zL21hc3RlciIsInN1YiI6IjRkODIzZTc1LTBjZTUtNGRmOC1hOWUwLTUwY2MzNzU0ZjkxOCIsInR5cCI6IlJlZnJlc2giLCJhenAiOiJhZG1pbi1jbGkiLCJzZXNzaW9uX3N0YXRlIjoiMDgxOTQ5NjctNzI3OC00ODBmLTliZTctODQ0OTYyNjhkZWIxIiwic2NvcGUiOiJwcm9maWxlIGVtYWlsIiwic2lkIjoiMDgxOTQ5NjctNzI3OC00ODBmLTliZTctODQ0OTYyNjhkZWIxIn0.e3RZAu1vz3HyNOXBY4QhDt6r7JLcu-AhgLu-ygAuugY","token_type":"Bearer","not-before-policy":0,"session_state":"08194967-7278-480f-9be7-84496268deb1","scope":"profile email"}
ubuntu@Client:~$
```

As you notice, the returned result is a json object, while on the script you need only the token value itself.
To parse and extract only the object(s) and value(s) from a json object or jason map or json array, I use `jq` to help me do that.

```
export KeyCloakToken=$(curl -fksSL --request POST http://192.168.123.203:8080/realms/master/protocol/openid-connect/token --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'username=admin' --data-urlencode 'password=admin' --data-urlencode 'grant_type=password' --data-urlencode 'client_id=admin-cli' | jq -r '.access_token')
echo "KeyCloakToken = $KeyCloakToken"
```

Example execution and result:

```
ubuntu@Client:~$ export KeyCloakToken=$(curl -fksSL --request POST http://192.168.123.203:8080/realms/master/protocol/openid-connect/token --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'username=admin' --data-urlencode 'password=admin' --data-urlencode 'grant_type=password' --data-urlencode 'client_id=admin-cli' | jq -r '.access_token')
ubuntu@Client:~$ echo "KeyCloakToken = $KeyCloakToken"
KeyCloakToken = eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJ2N0FnRklULTkxaVVzQVo4Q195TE1wWHhaREVWdWJhSWMyc2p1YnNfLUZRIn0.eyJleHAiOjE2ODIxNDgwMTYsImlhdCI6MTY4MjE0Nzk1NiwianRpIjoiYjZlZjgyMWEtYTNjZi00ODUzLWIwY2QtYjU4MmE3MWU3ZTk2IiwiaXNzIjoiaHR0cDovLzE5Mi4xNjguMTIzLjIwMzo4MDgwL3JlYWxtcy9tYXN0ZXIiLCJzdWIiOiI0ZDgyM2U3NS0wY2U1LTRkZjgtYTllMC01MGNjMzc1NGY5MTgiLCJ0eXAiOiJCZWFyZXIiLCJhenAiOiJhZG1pbi1jbGkiLCJzZXNzaW9uX3N0YXRlIjoiZGNmZTg5ZjEtNDU0Ny00N2IzLTg0ZDEtNDUwMGVkZmY3M2E3IiwiYWNyIjoiMSIsInNjb3BlIjoicHJvZmlsZSBlbWFpbCIsInNpZCI6ImRjZmU4OWYxLTQ1NDctNDdiMy04NGQxLTQ1MDBlZGZmNzNhNyIsImVtYWlsX3ZlcmlmaWVkIjpmYWxzZSwicHJlZmVycmVkX3VzZXJuYW1lIjoiYWRtaW4ifQ.EvbZbQSf8ylRTl_qDvCrjP9_lG_y9OoroHNhmpbEMf8z0Y-NkfAmZuA-DhJYwRr6Bi2FxgKxTzE47Hma1vrrPZYlrRtMlKzuvDBknSHg9GuxTfASo5NWVyCM6eqkBssUgPZRl_o3G8FP0q88rgVbWrMw76ofda3adzYXy0e7pi7rKddh8aiIzjQevp-9P_14-hHVlR9-vLT56Ovc0lEffsELVJXL1Geew7hMUl_7g-2mejws3SJt_H9LFc-uiXZmXt928bER4othXp5NjvHibx_ln5Sf0brxjjUu5Ror9yutTrGhyCszhucU83iU82Nj73FhhOukKU_pRBiuiYSM7g
ubuntu@Client:~$
```

As you can see on the last example above, we manage to obtain only the token's value and keep the value in a variable to be used later when we access other endpoints/functions of KeyCloak Admin API.
By default, as per my experience, the validity time of the admin's token is not very long, so you may need to execute the above line with every endpoints/functions access.

A note when you are facing some issue or error situation, to help you troubleshoot, you may want more error or warning messages.
Based on [KeyCloak File Logging](https://www.keycloak.org/server/logging#:~:text=Logging%20to%20a%20file%20is%20disabled%20by%20default.%20To%20enable%20it,%20enter%20the%20following%20command), you need to activate file logging first.
The default location of the log file is: file name `keycloak.log` inside the `data/log` directory of your KeyCloak installation folder.
Observing the `keycloak.log` may help you getting further clues of what went wrong.

Also note that between KeyCloak versions, the format/syntax and/or the KeyCloak Admin API structure may have changed.
For example, for the version 16.1.1, the format/syntax to obtain the admin token is as described below.

```
export KeyCloakToken=$(curl -fksSL -X POST "http://localhost:8080/auth/realms/master/protocol/openid-connect/token" -H 'Content-Type: application/x-www-form-urlencoded' -d 'username=admin' -d 'password=admin' -d 'grant_type=password' -d 'client_id=admin-cli' | jq -r '.access_token')
echo "KeyCloakToken = $KeyCloakToken"
```

Notice the URL/endpoint which we need to call, there was additional `auth` in the path.

```
ubuntu@infra:~$ export KeyCloakToken=$(curl -fksSL -X POST "http://localhost:8080/auth/realms/master/protocol/openid-connect/token" -H 'Content-Type: application/x-www-form-urlencoded' -d 'username=admin' -d 'password=admin' -d 'grant_type=password' -d 'client_id=admin-cli' | jq -r '.access_token')
ubuntu@infra:~$ echo "KeyCloakToken = $KeyCloakToken"
KeyCloakToken = eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJCcUdKc28tSjNQb1NCQUdsazVHZnp4TmsyWXN0TDU4ZU5DcUVyQkZoSTh3In0.eyJleHAiOjE2ODIxODA3MzMsImlhdCI6MTY4MjE4MDY3MywianRpIjoiNTI4N2EwZWItYWIxOC00MTgwLTg1ZTAtY2EyNWMzOWRjY2I1IiwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo4MDgwL2F1dGgvcmVhbG1zL21hc3RlciIsInN1YiI6IjZhYTkzYTI5LTFjZTctNDllNC1iYmMwLWU0NGRmZWRmOGFhZSIsInR5cCI6IkJlYXJlciIsImF6cCI6ImFkbWluLWNsaSIsInNlc3Npb25fc3RhdGUiOiI3ZDFhY2YyNy01OWYwLTRkMmYtOGQ4NS01MDQwOWM2NGEzYjYiLCJhY3IiOiIxIiwic2NvcGUiOiJwcm9maWxlIGVtYWlsIiwic2lkIjoiN2QxYWNmMjctNTlmMC00ZDJmLThkODUtNTA0MDljNjRhM2I2IiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJhZG1pbiJ9.XHqna77yFSOrknzLGu-IdKqrFFKsvZ9_cwgdreI8r5RKN7RPaYQesfHlQkWGywNgTvmA0kroC50g3CknRAGNKHkUwVrhmA44QxQo5OdyHIPgnxe43FZNUpjB5zv0-4RzJ2L5KAxdmClZ1QkVrtkqp71IafsFO3N2cvz-0jcFB40mB5S6qVovDWk03IgOzVlVHGE3IKyjYhNRO5zIb6-a4cMREIEy0jc4QKRpKDrWFleAFLw-xWKbAAhqMYLqPLEajLEpb3TSl9TP-BEEGxCGesIy8Kww3fR8xV2tJiaDs1lxEXgabYPBsFkygV7pWiFsOGebGDd91nOkaE5ERXx5sw
ubuntu@infra:~$
```



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


