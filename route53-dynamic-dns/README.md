A docker image to update a record set in Route53 to your public IP address. Useful for dynamic DNS for home servers.

This image requires a policy like the following:

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "route53:ChangeResourceRecordSets"
            ],
            "Resource": "arn:aws:route53:::hostedzone/somezoneidhere"
        }
    ]
}
```

Put your AWS credentials file at `/root/.aws/credentials` in the image. To run from docker, run like this:

```
docker run --rm -e ZONEID=somezoneid -e RECORDSET=example.com-e TTL=300 -e TYPE=A -v /home/someuser/.aws:/root/.aws bentastic27/route53-dynamic-dns
```

For Kubernetes, create your secret like this:

```
kubectl create secret generic aws-credentials --from-file=$HOME/.aws/credentials
```
