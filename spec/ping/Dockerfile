FROM alpine
COPY spec/ping/test-client.sh /usr/sbin
COPY bin/silvio-client /usr/bin
CMD /usr/sbin/test-client.sh $TOKEN
