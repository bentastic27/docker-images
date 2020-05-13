#!/bin/bash

# Change this if you want
COMMENT="Auto updating @ `date`"

if [ -z "$ZONEID" ] || [ -z "$RECORDSET" ] || [ -z "$TTL" ] || [ -z "$TYPE" ]; then
  echo "plz set \$ZONEID, \$RECORDSET, \$TTL and \$TYPE"
  exit 1
fi

# Get the external IP address from OpenDNS (more reliable than other providers)
IP=`dig +short myip.opendns.com @resolver1.opendns.com`
CURRENT_RECORD=`dig +short ${RECORDSET} @resolver1.opendns.com`

function valid_ip()
{
    local  ip=$1
    local  stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}

if ! valid_ip $IP; then
    echo "Invalid IP address: $IP"
    exit 1
fi

if ! valid_ip $CURRENT_RECORD; then
    echo "Invalid IP address on current record: $CURRENT_RECORD"
    exit 1
fi

# Check if the IP has changed
if [ "$IP" = "$CURRENT_RECORD"]; then
    # code if found
    echo "IP is still $IP. Exiting"
    exit 0
else
    echo "IP has changed to $IP"
    # Fill a temp file with valid JSON
    TMPFILE=$(mktemp /tmp/temporary-file.XXXXXXXX)
    cat > ${TMPFILE} << EOF
    {
      "Comment":"$COMMENT",
      "Changes":[
        {
          "Action":"UPSERT",
          "ResourceRecordSet":{
            "ResourceRecords":[
              {
                "Value":"$IP"
              }
            ],
            "Name":"$RECORDSET",
            "Type":"$TYPE",
            "TTL":$TTL
          }
        }
      ]
    }
EOF

    # Update the Hosted Zone record
    aws route53 change-resource-record-sets \
        --hosted-zone-id $ZONEID \
        --change-batch file://"$TMPFILE"
    echo "IP Changed in Route53"

    # Clean up
    rm $TMPFILE
fi
