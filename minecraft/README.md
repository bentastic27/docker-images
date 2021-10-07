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
        - /data/
        image: bentastic27/minecraft:1.17.1
        imagePullPolicy: Always
        name: copy-jarfile
        volumeMounts:
        - mountPath: /data
          name: minecraft
        workingDir: /data/
      volumes:
      - name: minecraft
        persistentVolumeClaim:
          claimName: minecraft
```
