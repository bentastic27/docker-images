It's worth noting that rcon is enabled by default with "password" as the password. This can be changed by mounting the volume created by the docker command or by changing the relavent lines in the config map for the Kubernetes example.

docker run example:

```
docker run -d --name minecraft \
  -p 25565:25565 \
  -v minecraft:/srv bentastic27/minecraft:latest \
  -e MAX_MEMORY_SIZE=2G \
  bentastic27/minecraft:latest
```

Kubernetes example:

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: minecraft-config
data:
  server.properties: | # be sure to change the rcon password if you want
    allow-flight=false
    allow-nether=true
    broadcast-console-to-ops=true
    broadcast-rcon-to-ops=true
    difficulty=easy
    enable-command-block=false
    enable-jmx-monitoring=false
    enable-query=false
    enable-rcon=true
    enable-status=true
    enforce-whitelist=false
    entity-broadcast-range-percentage=100
    force-gamemode=false
    function-permission-level=2
    gamemode=survival
    hardcore=false
    level-name=world
    max-players=20
    max-tick-time=60000
    max-world-size=29999984
    motd=A Minecraft Server
    network-compression-threshold=256
    online-mode=true
    op-permission-level=4
    player-idle-timeout=0
    prevent-proxy-connections=false
    pvp=true
    query.port=25565
    rate-limit=0
    rcon.password=password
    rcon.port=25575
    require-resource-pack=false
    resource-pack=
    resource-pack-prompt=
    resource-pack-sha1=
    server-ip=
    server-port=25565
    snooper-enabled=true
    spawn-animals=true
    spawn-monsters=true
    spawn-npcs=true
    spawn-protection=16
    sync-chunk-writes=true
    text-filtering-config=
    use-native-transport=true
    view-distance=10
    white-list=false
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: minecraft
  name: minecraft
spec:
  replicas: 1
  selector:
    matchLabels:
      app: minecraft
  template:
    metadata:
      labels:
        app: minecraft
    spec:
      containers:
      - image: bentastic27/minecraft:latest
        name: minecraft
        ports:
        - containerPort: 25565
          hostPort: 25565
          name: minecraft
          protocol: TCP
        env:
        - name: EULA
          value: "true"
        - name: MAX_MEMORY_SIZE
          value: 2G
        - name: INIT_MEMORY_SIZE
          value: 1G
        - name: MCRCON_PASS # change in server.properties configmap as well
          value: password
        volumeMounts:
        - mountPath: /srv
          name: minecraft
      initContainers:
      - command:
        - cp
        - -f
        - /config/server.properties
        - /data/
        image: alpine:3.15.0
        imagePullPolicy: Always
        name: copy-configs
        volumeMounts:
        - mountPath: /data
          name: minecraft
        - mountPath: /config
          name: config
          readOnly: true
      volumes:
      - name: minecraft
        persistentVolumeClaim:
          claimName: minecraft
      - name: config
        configMap:
          name: minecraft-config
          items:
          - key: server.properties
            path: server.properties
```
