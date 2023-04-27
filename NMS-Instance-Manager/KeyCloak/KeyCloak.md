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



<br><br><br>

***

## Obtain Admin's Token

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
ubuntu@Client:~$ export KeyCloakToken=$(curl -fksSL -X POST "http://localhost:8080/auth/realms/master/protocol/openid-connect/token" -H 'Content-Type: application/x-www-form-urlencoded' -d 'username=admin' -d 'password=admin' -d 'grant_type=password' -d 'client_id=admin-cli' | jq -r '.access_token')
ubuntu@Client:~$ echo "KeyCloakToken = $KeyCloakToken"
KeyCloakToken = eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJCcUdKc28tSjNQb1NCQUdsazVHZnp4TmsyWXN0TDU4ZU5DcUVyQkZoSTh3In0.eyJleHAiOjE2ODIxODA3MzMsImlhdCI6MTY4MjE4MDY3MywianRpIjoiNTI4N2EwZWItYWIxOC00MTgwLTg1ZTAtY2EyNWMzOWRjY2I1IiwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo4MDgwL2F1dGgvcmVhbG1zL21hc3RlciIsInN1YiI6IjZhYTkzYTI5LTFjZTctNDllNC1iYmMwLWU0NGRmZWRmOGFhZSIsInR5cCI6IkJlYXJlciIsImF6cCI6ImFkbWluLWNsaSIsInNlc3Npb25fc3RhdGUiOiI3ZDFhY2YyNy01OWYwLTRkMmYtOGQ4NS01MDQwOWM2NGEzYjYiLCJhY3IiOiIxIiwic2NvcGUiOiJwcm9maWxlIGVtYWlsIiwic2lkIjoiN2QxYWNmMjctNTlmMC00ZDJmLThkODUtNTA0MDljNjRhM2I2IiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJhZG1pbiJ9.XHqna77yFSOrknzLGu-IdKqrFFKsvZ9_cwgdreI8r5RKN7RPaYQesfHlQkWGywNgTvmA0kroC50g3CknRAGNKHkUwVrhmA44QxQo5OdyHIPgnxe43FZNUpjB5zv0-4RzJ2L5KAxdmClZ1QkVrtkqp71IafsFO3N2cvz-0jcFB40mB5S6qVovDWk03IgOzVlVHGE3IKyjYhNRO5zIb6-a4cMREIEy0jc4QKRpKDrWFleAFLw-xWKbAAhqMYLqPLEajLEpb3TSl9TP-BEEGxCGesIy8Kww3fR8xV2tJiaDs1lxEXgabYPBsFkygV7pWiFsOGebGDd91nOkaE5ERXx5sw
ubuntu@Client:~$
```



<br><br><br>

***

## Create Client

As stated above, you may need to execute the token retrieval command (first line) each time you access any endpoints/functions of KeyCloak Admin API.
Second line is the format/syntax to create a 'Client' within the KeyCloak system.

You need to provide the ClientID (client's name), in this example case it is `operator-client`. And RedirectURIs, in this example case it is `http://192.168.123.102:43210/_codexch`.
Kindly review [Core Concepts and Terms](https://www.keycloak.org/docs/latest/server_admin/#core-concepts-and-terms) for explanation of what term means what, in this section of repository.
Don't forget to add header `Content-Type: application/json` to properly describe the format of the data forwarded to KeyCloak system.

Refer to [Clients Resource](https://www.keycloak.org/docs-api/21.1.0/rest-api/#_clients_resource) and [ClientRepresentation](https://www.keycloak.org/docs-api/21.1.0/rest-api/#_clientrepresentation) for further details of data structure of the json payload which you can send to KeyCloak system.
Also pay attention to the `keycloak.log` file in case you have issue with the command.

```
export KeyCloakToken=$(curl -fksSL --request POST http://192.168.123.203:8080/realms/master/protocol/openid-connect/token --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'username=admin' --data-urlencode 'password=admin' --data-urlencode 'grant_type=password' --data-urlencode 'client_id=admin-cli' | jq -r '.access_token')
curl -fksSL --request POST http://192.168.123.203:8080/admin/realms/master/clients --header "Authorization: Bearer $KeyCloakToken" --header 'Content-Type: application/json' --data '{ "clientId": "operator-client", "protocol": "openid-connect", "publicClient": false, "authorizationServicesEnabled": true, "serviceAccountsEnabled": true, "redirectUris": [ "http://192.168.123.102:43210/_codexch" ] }' | jq
```

As per described in the example execution below, the Client creation command does not return anything. So you can omit the last `| jq` at the end of second line.

```
ubuntu@Client:~$ export KeyCloakToken=$(curl -fksSL --request POST http://192.168.123.203:8080/realms/master/protocol/openid-connect/token --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'username=admin' --data-urlencode 'password=admin' --data-urlencode 'grant_type=password' --data-urlencode 'client_id=admin-cli' | jq -r '.access_token')
ubuntu@Client:~$ curl -fksSL --request POST http://192.168.123.203:8080/admin/realms/master/clients --header "Authorization: Bearer $KeyCloakToken" --header 'Content-Type: application/json' --data '{ "clientId": "operator-client", "protocol": "openid-connect", "publicClient": false, "authorizationServicesEnabled": true, "serviceAccountsEnabled": true, "redirectUris": [ "http://192.168.123.102:43210/_codexch" ] }' | jq
ubuntu@Client:~$
```



<br><br><br>

***

## Obtain ClientID and Client's Secret

The curl command on the second line below actually retrieve all Clients which exist in `master` realm, in form of an array of json objects. Which by default there are several pre-built-in Clients in KeyCloak system.
The `jq '.[] | select(.clientId=="operator-client")'` helps to single out and obtain only one json object where the `clientId` field value is `operator-client`.
The result is further piped to `jq -r '.id'`, where it takes only the value of field named `id`.

To obtain Client's Secret (third line), you can use the ClientID as part of the path (to indicate which Client you're targeting), and then call its 'client-secret' object.
And then obtain only the 'value' field of the 'client-secret' object.

```
export KeyCloakToken=$(curl -fksSL --request POST http://192.168.123.203:8080/realms/master/protocol/openid-connect/token --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'username=admin' --data-urlencode 'password=admin' --data-urlencode 'grant_type=password' --data-urlencode 'client_id=admin-cli' | jq -r '.access_token')
export KeyCloakClientID=$(curl -fksSL --request GET http://192.168.123.203:8080/admin/realms/master/clients/ --header "Authorization: Bearer $KeyCloakToken" | jq '.[] | select(.clientId=="operator-client")' | jq -r '.id')
export KeyCloakClientSecret=$(curl -fksSL --request GET http://192.168.123.203:8080/admin/realms/master/clients/$KeyCloakClientID/client-secret --header "Authorization: Bearer $KeyCloakToken" | jq -r '.value')
echo "KeyCloakClientID = $KeyCloakClientID"
echo "KeyCloakClientSecret = $KeyCloakClientSecret"
```

Alternative for third line, you can also do as described below.
Retrieving only one Client object using the ClientID information, and then extracting a field called 'secret' from that returned Client object.
Reviewing the [ClientRepresentation](https://www.keycloak.org/docs-api/21.1.0/rest-api/#_clientrepresentation) object may result to a lot more clarity into the matter.

```
export KeyCloakToken=$(curl -fksSL --request POST http://192.168.123.203:8080/realms/master/protocol/openid-connect/token --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'username=admin' --data-urlencode 'password=admin' --data-urlencode 'grant_type=password' --data-urlencode 'client_id=admin-cli' | jq -r '.access_token')
export KeyCloakClientID=$(curl -fksSL --request GET http://192.168.123.203:8080/admin/realms/master/clients/ --header "Authorization: Bearer $KeyCloakToken" | jq '.[] | select(.clientId=="operator-client")' | jq -r '.id')
export KeyCloakClientSecret=$(curl -fksSL --request GET http://192.168.123.203:8080/admin/realms/master/clients/$KeyCloakClientID --header "Authorization: Bearer $KeyCloakToken" | jq -r '.secret')
echo "KeyCloakClientID = $KeyCloakClientID"
echo "KeyCloakClientSecret = $KeyCloakClientSecret"
```

Below is an example of the execution and result. Note that the ClientID and Client's Secret values that we obtained are clean, just the value, without any additional quotes surrounding the value.

```
ubuntu@Client:~$ export KeyCloakToken=$(curl -fksSL --request POST http://192.168.123.203:8080/realms/master/protocol/openid-connect/token --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'username=admin' --data-urlencode 'password=admin' --data-urlencode 'grant_type=password' --data-urlencode 'client_id=admin-cli' | jq -r '.access_token')
ubuntu@Client:~$ export KeyCloakClientID=$(curl -fksSL --request GET http://192.168.123.203:8080/admin/realms/master/clients/ --header "Authorization: Bearer $KeyCloakToken" | jq '.[] | select(.clientId=="operator-client")' | jq -r '.id')
ubuntu@Client:~$ export KeyCloakClientSecret=$(curl -fksSL --request GET http://192.168.123.203:8080/admin/realms/master/clients/$KeyCloakClientID/client-secret --header "Authorization: Bearer $KeyCloakToken" | jq -r '.value')
ubuntu@Client:~$ echo "KeyCloakClientID = $KeyCloakClientID"
KeyCloakClientID = 8aa2b7cf-0ca6-41e8-90f5-8ea01e8ffbdc
ubuntu@Client:~$ echo "KeyCloakClientSecret = $KeyCloakClientSecret"
KeyCloakClientSecret = RGnWN7HTyGPN1SZOSHJrF0S7iJO8WlTg
ubuntu@Client:~$
```

There is alternative to obtain only one particular Client when querying the KeyCloak Admin API (i.e. try to skip the ClientID and try to go directly to Client's Secret), such as described in second line below.
However, unfortunately the return value is encapsulated in an array; i.e. the return value is an array containing only one json object of type 'Client'.

```
export KeyCloakToken=$(curl -fksSL --request POST http://192.168.123.203:8080/realms/master/protocol/openid-connect/token --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'username=admin' --data-urlencode 'password=admin' --data-urlencode 'grant_type=password' --data-urlencode 'client_id=admin-cli' | jq -r '.access_token')
curl -fksSL --request GET http://192.168.123.203:8080/admin/realms/master/clients/?clientId=operator-client --header "Authorization: Bearer $KeyCloakToken" | jq '.[] | .secret'
```

The `jq '.[] | .secret'` can process the array and return all values of field `secret` from each element of the array.
So the return/result is a list of values (which in this case contains only one member).
However, list of values will have each element be quoted, as can be seen from the sample execution below.
This quoted value(s) need a further processing to be used in this repository, and therefore not preferred.

```
ubuntu@Client:~$ export KeyCloakToken=$(curl -fksSL --request POST http://192.168.123.203:8080/realms/master/protocol/openid-connect/token --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'username=admin' --data-urlencode 'password=admin' --data-urlencode 'grant_type=password' --data-urlencode 'client_id=admin-cli' | jq -r '.access_token')
ubuntu@Client:~$ curl -fksSL --request GET http://192.168.123.203:8080/admin/realms/master/clients/?clientId=operator-client --header "Authorization: Bearer $KeyCloakToken" | jq '.[] | .secret'
"RGnWN7HTyGPN1SZOSHJrF0S7iJO8WlTg"
ubuntu@Client:~$
```

`jq -r '.secret'` does not work on an array, as described on below example.

```
export KeyCloakToken=$(curl -fksSL --request POST http://192.168.123.203:8080/realms/master/protocol/openid-connect/token --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'username=admin' --data-urlencode 'password=admin' --data-urlencode 'grant_type=password' --data-urlencode 'client_id=admin-cli' | jq -r '.access_token')
curl -fksSL --request GET http://192.168.123.203:8080/admin/realms/master/clients/?clientId=operator-client --header "Authorization: Bearer $KeyCloakToken" | jq -r '.secret'
```

```
ubuntu@Client:~$ export KeyCloakToken=$(curl -fksSL --request POST http://192.168.123.203:8080/realms/master/protocol/openid-connect/token --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'username=admin' --data-urlencode 'password=admin' --data-urlencode 'grant_type=password' --data-urlencode 'client_id=admin-cli' | jq -r '.access_token')
ubuntu@Client:~$ curl -fksSL --request GET http://192.168.123.203:8080/admin/realms/master/clients/?clientId=operator-client --header "Authorization: Bearer $KeyCloakToken" | jq -r '.secret'
jq: error (at <stdin>:0): Cannot index array with string "secret"
ubuntu@Client:~$
```



<br><br><br>

***

## Create Client-Role

There are two types of roles in KeyCloak, Client Role and Realm Role.
In this example, we deal only with Client Role.

To create a Client Role, you will need to provide the Role's name (in this example, it is `operator-role`), and the ClientID information (which we obtained through the section above).

```
export KeyCloakToken=$(curl -fksSL --request POST http://192.168.123.203:8080/realms/master/protocol/openid-connect/token --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'username=admin' --data-urlencode 'password=admin' --data-urlencode 'grant_type=password' --data-urlencode 'client_id=admin-cli' | jq -r '.access_token')
export KeyCloakClientID=$(curl -fksSL --request GET http://192.168.123.203:8080/admin/realms/master/clients/ --header "Authorization: Bearer $KeyCloakToken" | jq '.[] | select(.clientId=="operator-client")' | jq -r '.id')
curl -fksSL --request POST http://192.168.123.203:8080/admin/realms/master/clients/$KeyCloakClientID/roles --header "Authorization: Bearer $KeyCloakToken" --header 'Content-Type: application/json' --data '{ "name": "operator-role" }' | jq
```

The example execution. The Client Role creation command does not return anything.

```
ubuntu@Client:~$ export KeyCloakToken=$(curl -fksSL --request POST http://192.168.123.203:8080/realms/master/protocol/openid-connect/token --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'username=admin' --data-urlencode 'password=admin' --data-urlencode 'grant_type=password' --data-urlencode 'client_id=admin-cli' | jq -r '.access_token')
ubuntu@Client:~$ export KeyCloakClientID=$(curl -fksSL --request GET http://192.168.123.203:8080/admin/realms/master/clients/ --header "Authorization: Bearer $KeyCloakToken" | jq '.[] | select(.clientId=="operator-client")' | jq -r '.id')
ubuntu@Client:~$ curl -fksSL --request POST http://192.168.123.203:8080/admin/realms/master/clients/$KeyCloakClientID/roles --header "Authorization: Bearer $KeyCloakToken" --header 'Content-Type: application/json' --data '{ "name": "operator-role" }' | jq
ubuntu@Client:~$
```



<br><br><br>

***

## Obtain Client-Role's ID

Obtaining Client-Role's ID (third line command below) require the admin's token (first line below), ClientID information (second line below) and the Client-Role's name.
Similar to obtaining Client's secret, the curl command on the third line below returns multiple Role objects (including pre-built-in Realm Role objects).
`jq '.[] | select(.name=="operator-role")'` helps to single out and return only one Role object where the `name` field value is `operator-role`.
The result is further piped through `jq -r '.id'` where only the value of field `id` of the single-out object is returned; which is the Role's ID we want.

```
export KeyCloakToken=$(curl -fksSL --request POST http://192.168.123.203:8080/realms/master/protocol/openid-connect/token --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'username=admin' --data-urlencode 'password=admin' --data-urlencode 'grant_type=password' --data-urlencode 'client_id=admin-cli' | jq -r '.access_token')
export KeyCloakClientID=$(curl -fksSL --request GET http://192.168.123.203:8080/admin/realms/master/clients/ --header "Authorization: Bearer $KeyCloakToken" | jq '.[] | select(.clientId=="operator-client")' | jq -r '.id')
export KeyCloakRoleID=$(curl -fksSL --request GET http://192.168.123.203:8080/admin/realms/master/clients/$KeyCloakClientID/roles --header "Authorization: Bearer $KeyCloakToken" | jq '.[] | select(.name=="operator-role")' | jq -r '.id')
echo "KeyCloakRoleID = $KeyCloakRoleID"
```

Below is an example of the execution and result. Note that the Role's ID value that we obtained is clean, just the value, without any additional quotes surrounding the value.

```
ubuntu@Client:~$ export KeyCloakToken=$(curl -fksSL --request POST http://192.168.123.203:8080/realms/master/protocol/openid-connect/token --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'username=admin' --data-urlencode 'password=admin' --data-urlencode 'grant_type=password' --data-urlencode 'client_id=admin-cli' | jq -r '.access_token')
ubuntu@Client:~$ export KeyCloakClientID=$(curl -fksSL --request GET http://192.168.123.203:8080/admin/realms/master/clients/ --header "Authorization: Bearer $KeyCloakToken" | jq '.[] | select(.clientId=="operator-client")' | jq -r '.id')
ubuntu@Client:~$ export KeyCloakRoleID=$(curl -fksSL --request GET http://192.168.123.203:8080/admin/realms/master/clients/$KeyCloakClientID/roles --header "Authorization: Bearer $KeyCloakToken" | jq '.[] | select(.name=="operator-role")' | jq -r '.id')
ubuntu@Client:~$ echo "KeyCloakRoleID = $KeyCloakRoleID"
KeyCloakRoleID = dc2518b1-e8c9-4f6b-8a1d-cc6929024dca
ubuntu@Client:~$
```



<br><br><br>

***

## Create User

To create a User object in KeyCloak, you need to provide username (in this example case `operator`) and password (in this example case `P@55w0rd`).

```
export KeyCloakToken=$(curl -fksSL --request POST http://192.168.123.203:8080/realms/master/protocol/openid-connect/token --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'username=admin' --data-urlencode 'password=admin' --data-urlencode 'grant_type=password' --data-urlencode 'client_id=admin-cli' | jq -r '.access_token')
curl -fksSL --request POST http://192.168.123.203:8080/admin/realms/master/users --header "Authorization: Bearer $KeyCloakToken" --header 'Content-Type: application/json' --data '{ "username": "operator", "credentials": [ { "type": "password", "value": "P@55w0rd", "temporary": false } ] }' | jq
```

```
ubuntu@Client:~$ export KeyCloakToken=$(curl -fksSL --request POST http://192.168.123.203:8080/realms/master/protocol/openid-connect/token --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'username=admin' --data-urlencode 'password=admin' --data-urlencode 'grant_type=password' --data-urlencode 'client_id=admin-cli' | jq -r '.access_token')
ubuntu@Client:~$ curl -fksSL --request POST http://192.168.123.203:8080/admin/realms/master/users --header "Authorization: Bearer $KeyCloakToken" --header 'Content-Type: application/json' --data '{ "username": "operator", "credentials": [ { "type": "password", "value": "P@55w0rd", "temporary": false } ] }' | jq
ubuntu@Client:~$
```



<br><br><br>

***

## Obtain User's ID

Similar to the previous sections, the curl command returns all the User objects in form of an array.
`jq '.[] | select(.username=="operator")'` helps to select only one User object with the pre-conditon we specify.
Then we extract the `id` of that object.

```
export KeyCloakToken=$(curl -fksSL --request POST http://192.168.123.203:8080/realms/master/protocol/openid-connect/token --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'username=admin' --data-urlencode 'password=admin' --data-urlencode 'grant_type=password' --data-urlencode 'client_id=admin-cli' | jq -r '.access_token')
export KeyCloakUserID=$(curl -fksSL --request GET http://192.168.123.203:8080/admin/realms/master/users --header "Authorization: Bearer $KeyCloakToken" | jq '.[] | select(.username=="operator")' | jq -r '.id')
echo "KeyCloakUserID = $KeyCloakUserID"
```

```
ubuntu@Client:~$ export KeyCloakToken=$(curl -fksSL --request POST http://192.168.123.203:8080/realms/master/protocol/openid-connect/token --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'username=admin' --data-urlencode 'password=admin' --data-urlencode 'grant_type=password' --data-urlencode 'client_id=admin-cli' | jq -r '.access_token')
ubuntu@Client:~$ export KeyCloakUserID=$(curl -fksSL --request GET http://192.168.123.203:8080/admin/realms/master/users --header "Authorization: Bearer $KeyCloakToken" | jq '.[] | select(.username=="operator")' | jq -r '.id')
ubuntu@Client:~$ echo "KeyCloakUserID = $KeyCloakUserID"
KeyCloakUserID = 8dbeeea1-8e47-4cef-80e9-2c5f8298d45d
ubuntu@Client:~$
```



<br><br><br>

***

## Create Client-Role Mapping

To create Role Mapping, we'll need: admin's token, ClientID, User's ID, Role's name and Role's ID (review the value used below against the value obtained in the section examples above).
But before executing the below commands, you may want to execute the below "see the result of the Role Mapping" first, just to ensure there is/are difference(s) before and after.

```
export KeyCloakToken=$(curl -fksSL --request POST http://192.168.123.203:8080/realms/master/protocol/openid-connect/token --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'username=admin' --data-urlencode 'password=admin' --data-urlencode 'grant_type=password' --data-urlencode 'client_id=admin-cli' | jq -r '.access_token')
export KeyCloakClientID=$(curl -fksSL --request GET http://192.168.123.203:8080/admin/realms/master/clients/ --header "Authorization: Bearer $KeyCloakToken" | jq '.[] | select(.clientId=="operator-client")' | jq -r '.id')
export KeyCloakUserID=$(curl -fksSL --request GET http://192.168.123.203:8080/admin/realms/master/users --header "Authorization: Bearer $KeyCloakToken" | jq '.[] | select(.username=="operator")' | jq -r '.id')
curl -fksSL --request POST http://192.168.123.203:8080/admin/realms/master/users/$KeyCloakUserID/role-mappings/clients/$KeyCloakClientID --header "Authorization: Bearer $KeyCloakToken" --header 'Content-Type: application/json' --data '[ { "id": "dc2518b1-e8c9-4f6b-8a1d-cc6929024dca", "name": "operator-role" } ]' | jq
```

```
ubuntu@Client:~$ export KeyCloakToken=$(curl -fksSL --request POST http://192.168.123.203:8080/realms/master/protocol/openid-connect/token --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'username=admin' --data-urlencode 'password=admin' --data-urlencode 'grant_type=password' --data-urlencode 'client_id=admin-cli' | jq -r '.access_token')
ubuntu@Client:~$ export KeyCloakClientID=$(curl -fksSL --request GET http://192.168.123.203:8080/admin/realms/master/clients/ --header "Authorization: Bearer $KeyCloakToken" | jq '.[] | select(.clientId=="operator-client")' | jq -r '.id')
ubuntu@Client:~$ export KeyCloakUserID=$(curl -fksSL --request GET http://192.168.123.203:8080/admin/realms/master/users --header "Authorization: Bearer $KeyCloakToken" | jq '.[] | select(.username=="operator")' | jq -r '.id')
ubuntu@Client:~$ curl -fksSL --request POST http://192.168.123.203:8080/admin/realms/master/users/$KeyCloakUserID/role-mappings/clients/$KeyCloakClientID --header "Authorization: Bearer $KeyCloakToken" --header 'Content-Type: application/json' --data '[ { "id": "dc2518b1-e8c9-4f6b-8a1d-cc6929024dca", "name": "operator-role" } ]' | jq
ubuntu@Client:~$
```

To see the result of the Role Mapping, just do the GET without payload data instead of POST.

```
export KeyCloakToken=$(curl -fksSL --request POST http://192.168.123.203:8080/realms/master/protocol/openid-connect/token --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'username=admin' --data-urlencode 'password=admin' --data-urlencode 'grant_type=password' --data-urlencode 'client_id=admin-cli' | jq -r '.access_token')
export KeyCloakClientID=$(curl -fksSL --request GET http://192.168.123.203:8080/admin/realms/master/clients/ --header "Authorization: Bearer $KeyCloakToken" | jq '.[] | select(.clientId=="operator-client")' | jq -r '.id')
export KeyCloakUserID=$(curl -fksSL --request GET http://192.168.123.203:8080/admin/realms/master/users --header "Authorization: Bearer $KeyCloakToken" | jq '.[] | select(.username=="operator")' | jq -r '.id')
curl -fksSL --request GET http://192.168.123.203:8080/admin/realms/master/users/$KeyCloakUserID/role-mappings/clients/$KeyCloakClientID --header "Authorization: Bearer $KeyCloakToken" | jq
```

```
ubuntu@Client:~$ export KeyCloakToken=$(curl -fksSL --request POST http://192.168.123.203:8080/realms/master/protocol/openid-connect/token --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'username=admin' --data-urlencode 'password=admin' --data-urlencode 'grant_type=password' --data-urlencode 'client_id=admin-cli' | jq -r '.access_token')
ubuntu@Client:~$ export KeyCloakClientID=$(curl -fksSL --request GET http://192.168.123.203:8080/admin/realms/master/clients/ --header "Authorization: Bearer $KeyCloakToken" | jq '.[] | select(.clientId=="operator-client")' | jq -r '.id')
ubuntu@Client:~$ export KeyCloakUserID=$(curl -fksSL --request GET http://192.168.123.203:8080/admin/realms/master/users --header "Authorization: Bearer $KeyCloakToken" | jq '.[] | select(.username=="operator")' | jq -r '.id')
ubuntu@Client:~$ curl -fksSL --request GET http://192.168.123.203:8080/admin/realms/master/users/$KeyCloakUserID/role-mappings/clients/$KeyCloakClientID --header "Authorization: Bearer $KeyCloakToken" | jq
[
  {
    "id": "dc2518b1-e8c9-4f6b-8a1d-cc6929024dca",
    "name": "operator-role",
    "composite": false,
    "clientRole": true,
    "containerId": "8aa2b7cf-0ca6-41e8-90f5-8ea01e8ffbdc"
  }
]
ubuntu@Client:~$
```



<br><br><br>

***

## Summarize and Parameterize the commands

```
# System and Realm Parameters
export KeyCloakHostPort="192.168.123.203:8080"
export KeyCloakAPIBaseURL="http://$KeyCloakHostPort"
export KeyCloakRealmName="master"
export KeyCloakAdminUserName="admin"
export KeyCloakAdminPassword="admin"

# Client, Role and User Parameters
export KeyCloakClientName="operator-client"
export ServiceHostPort="192.168.123.102:43210"
export KeyCloakRedirectURI="http://$ServiceHostPort/_codexch"
export KeyCloakRoleName="operator-role"
export KeyCloakMemberUserName="operator"
export KeyCloakMemberPassword="operator"

# Obtain Token
export KeyCloakToken=$(curl -fksSL --request POST $KeyCloakAPIBaseURL/realms/$KeyCloakRealmName/protocol/openid-connect/token --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode "username=$KeyCloakAdminUserName" --data-urlencode "password=$KeyCloakAdminPassword" --data-urlencode 'grant_type=password' --data-urlencode 'client_id=admin-cli' | jq -r '.access_token')
echo "KeyCloakToken = $KeyCloakToken"
# Create Client
curl -fksSL --request POST $KeyCloakAPIBaseURL/admin/realms/$KeyCloakRealmName/clients --header "Authorization: Bearer $KeyCloakToken" --header 'Content-Type: application/json' --data "{ \"clientId\": \"$KeyCloakClientName\", \"protocol\": \"openid-connect\", \"publicClient\": false, \"authorizationServicesEnabled\": true, \"serviceAccountsEnabled\": true, \"redirectUris\": [ \"$KeyCloakRedirectURI\" ] }" | jq
# Obtain Client ID
export KeyCloakClientID=$(curl -fksSL --request GET $KeyCloakAPIBaseURL/admin/realms/$KeyCloakRealmName/clients/ --header "Authorization: Bearer $KeyCloakToken" | jq ".[] | select(.clientId==\"$KeyCloakClientName\")" | jq -r '.id')
echo "KeyCloakClientID = $KeyCloakClientID"
# Obtain Client Secret
export KeyCloakClientSecret=$(curl -fksSL --request GET $KeyCloakAPIBaseURL/admin/realms/$KeyCloakRealmName/clients/$KeyCloakClientID/client-secret --header "Authorization: Bearer $KeyCloakToken" | jq -r '.value')
echo "KeyCloakClientSecret = $KeyCloakClientSecret"
# Create Role
curl -fksSL --request POST $KeyCloakAPIBaseURL/admin/realms/$KeyCloakRealmName/clients/$KeyCloakClientID/roles --header "Authorization: Bearer $KeyCloakToken" --header 'Content-Type: application/json' --data "{ \"name\": \"$KeyCloakRoleName\" }" | jq
# Obtain Role ID
export KeyCloakRoleID=$(curl -fksSL --request GET $KeyCloakAPIBaseURL/admin/realms/$KeyCloakRealmName/clients/$KeyCloakClientID/roles --header "Authorization: Bearer $KeyCloakToken" | jq ".[] | select(.name==\"$KeyCloakRoleName\")" | jq -r '.id')
echo "KeyCloakRoleID = $KeyCloakRoleID"
# Create User
curl -fksSL --request POST $KeyCloakAPIBaseURL/admin/realms/$KeyCloakRealmName/users --header "Authorization: Bearer $KeyCloakToken" --header 'Content-Type: application/json' --data "{ \"username\": \"$KeyCloakMemberUserName\", \"credentials\": [ { \"type\": \"password\", \"value\": \"$KeyCloakMemberPassword\", \"temporary\": false } ] }" | jq
# Obtain User ID
export KeyCloakUserID=$(curl -fksSL --request GET $KeyCloakAPIBaseURL/admin/realms/$KeyCloakRealmName/users --header "Authorization: Bearer $KeyCloakToken" | jq ".[] | select(.username==\"$KeyCloakMemberUserName\")" | jq -r '.id')
echo "KeyCloakUserID = $KeyCloakUserID"
# Create Client-Role Mapping
curl -fksSL --request POST $KeyCloakAPIBaseURL/admin/realms/$KeyCloakRealmName/users/$KeyCloakUserID/role-mappings/clients/$KeyCloakClientID --header "Authorization: Bearer $KeyCloakToken" --header 'Content-Type: application/json' --data "[ { \"id\": \"$KeyCloakRoleID\", \"name\": \"$KeyCloakRoleName\" } ]" | jq
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


