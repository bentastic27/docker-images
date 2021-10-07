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
  ops.json: | # hardcoded ops, add yours here
    [
        {
            "uuid": "32e47981-e1aa-470f-8b16-979a6a657d71",
            "name": "bentastic27",
            "level": 4
        },
    ]
  server.properties: |
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
      - image: bentastic27/minecraft:1.17.1
        name: minecraft
        ports:
        - containerPort: 25565
          hostPort: 25565
          name: minecraft
          protocol: TCP
        volumeMounts:
        - mountPath: /srv
          name: minecraft
      initContainers:
      - command:
        - cp
        - -f
        - /srv/server.jar
        - /srv/eula.txt
        - /config/ops.json
        - /config/server.properties
        - /data/
        image: bentastic27/minecraft:1.17.1
        imagePullPolicy: Always
        name: copy-jarfile
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
          - key: ops.json
            path: ops.json
          - key: server.properties
            path: server.properties
```
