# MecSuite
🔧 Various pieces of software for mechanic shop managers

## Tech Stack
Flutter - For tablet/manager application (majorly android) and also offering a desktop environment (for the receipt and car history); Also maybe a client application to check repairs
Go/NodeJS - For a backend server


## Important: New tech stack
Tauri - for the manager app
Flutter - for the client app (mobile and web)

## Parts
admin - For the manager application (maybe a PWA so it can be used on any device, and since the app is being ran on the server, wifi direct will make it accessible on the local network, aka the work place) (the problem: the app is being ran on the server as a PWA, so anyone can access it via the ip, the flutter app would run on the device, so only people with the app can access it)
server - For the backend server
client - For the client application (flutter app so it can be for android and ios and web)

## UI Stack
https://pub.dev/packages/yaru
https://docs.flutter.dev/ui/widgets/material
https://docs.flutter.dev/ui/widgets/cupertino
https://pub.dev/packages/fluent_ui
https://github.com/GroovinChip/macos_ui
https://flutter.moon.io/
https://fluttergems.dev/packages/elevarm_ui/
https://fluttergems.dev/packages/optimus/

## Others
https://fluttergems.dev/

## GoLang hot reload
```sh
go install github.com/pilu/fresh@latest
cd server
fresh
```

## Start Windows mongodb
```sh
# As admin run:
net start MongoDB
```