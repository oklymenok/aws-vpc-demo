# Certificate Creation

* Clone Easy RSA Git Repo
```
  git clone https://github.com/OpenVPN/easy-rsa.git
``` 
* Initialize Public Key Infrastructure (PKI)
```
./easyrsa init-pki
init-pki complete; you may now create a CA or requests.
Your newly created PKI dir is: /Users/${USER}/easy-rsa/easyrsa3/pki 
Build Certificate Authority

./easyrsa build-ca nopass

# Output
Using SSL: openssl LibreSSL 2.8.3
Generating RSA private key, 2048 bit long modulus
....................................................+++
...................................+++
e is 65537 (0x10001)
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Common Name (eg: your user, host, or server name) [Easy-RSA CA]:clientvpndemo.com
```
* CA creation complete and you may now import and sign cert requests. Your new CA certificate file for publishing is at: 
```
/Users/${USER}/easy-rsa/easyrsa3/pki/ca.crt
``` 
* Build Server Certificate
```
./easyrsa build-server-full clientvpndemo.com nopass
Using SSL: openssl LibreSSL 2.8.3
Generating a 2048 bit RSA private key
..............+++
............+++
writing new private key to '/Users/${USER}/easy-rsa/easyrsa3/pki/easy-rsa-8826.owtURY/tmp.5Jx9BY'
-----
Using configuration from /Users/${USER}/easy-rsa/easyrsa3/pki/easy-rsa-8826.owtURY/tmp.M8pVaP
Check that the request matches the signature
Signature ok
The Subject's Distinguished Name is as follows
commonName            :ASN.1 12:'clientvpndemo.com'
Certificate is to be certified until Jul  5 10:27:28 2022 GMT (825 days)

Write out database with 1 new entries
Data Base Updated 
```
* Build Client Certificate
```
./easyrsa build-client-full user.clientvpndemo.com nopass
Using SSL: openssl LibreSSL 2.8.3
Generating a 2048 bit RSA private key
.......................+++
...............................................................................................................................+++
writing new private key to '/Users/${USER}/easy-rsa/easyrsa3/pki/easy-rsa-9028.BEyiiC/tmp.OQB63G'
-----
Using configuration from /Users/${USER}/easy-rsa/easyrsa3/pki/easy-rsa-9028.BEyiiC/tmp.DZoDDK
Check that the request matches the signature
Signature ok
The Subject's Distinguished Name is as follows
commonName            :ASN.1 12:'user.clientvpndemo.com'
Certificate is to be certified until Jul  5 10:30:45 2022 GMT (825 days)

Write out database with 1 new entries
Data Base Updated
```
* Copy required certificates in to a single folder (optional) and upload to AWS Certificate Manager (ACM)
```
mkdir acm
cp pki/ca.crt acm
cp pki/issued/clientvpndemo.com.crt acm
cp pki/issued/pdomala.clientvpndemo.com.crt acm
cp pki/private/clientvpndemo.com.key acm
cp pki/private/pdomala.clientvpndemo.com.key acm
cd acm

aws acm import-certificate --certificate fileb://clientvpndemo.com.crt --private-key fileb://clientvpndemo.com.key --certificate-chain fileb://ca.crt --region ap-southeast-2
aws acm import-certificate --certificate fileb://pdomala.clientvpndemo.com.crt --private-key fileb://pdomala.clientvpndemo.com.key
```
* Start the VPN:
```
openvpn --config downloaded-client-config.ovpn --pull-filter ignore redirect-gateway
Sun Jun 26 23:47:09 2022 OpenVPN 2.4.7 aarch64-redhat-linux-gnu [Fedora EPEL patched] [SSL (OpenSSL)] [LZO] [LZ4] [EPOLL] [PKCS11] [MH/PKTINFO] [AEAD] built on Feb 20 2019
Sun Jun 26 23:47:09 2022 library versions: OpenSSL 1.0.2k-fips  26 Jan 2017, LZO 2.06
Sun Jun 26 23:47:09 2022 TCP/UDP: Preserving recently used remote address: [AF_INET]34.235.196.224:443
Sun Jun 26 23:47:09 2022 Socket Buffers: R=[212992->212992] S=[212992->212992]
Sun Jun 26 23:47:09 2022 UDP link local: (not bound)
Sun Jun 26 23:47:09 2022 UDP link remote: [AF_INET]34.235.196.224:443
Sun Jun 26 23:47:09 2022 TLS: Initial packet from [AF_INET]34.235.196.224:443, sid=8d52d1d5 d6c03c2e
Sun Jun 26 23:47:09 2022 VERIFY OK: depth=1, CN=clientvpndemo.com
Sun Jun 26 23:47:09 2022 VERIFY KU OK
Sun Jun 26 23:47:09 2022 Validating certificate extended key usage
Sun Jun 26 23:47:09 2022 ++ Certificate has EKU (str) TLS Web Server Authentication, expects TLS Web Server Authentication
Sun Jun 26 23:47:09 2022 VERIFY EKU OK
Sun Jun 26 23:47:09 2022 VERIFY OK: depth=0, CN=clientvpndemo.com
Sun Jun 26 23:47:09 2022 Control Channel: TLSv1.2, cipher TLSv1/SSLv3 ECDHE-RSA-AES256-GCM-SHA384, 2048 bit RSA
Sun Jun 26 23:47:09 2022 [clientvpndemo.com] Peer Connection Initiated with [AF_INET]34.235.196.224:443
Sun Jun 26 23:47:10 2022 SENT CONTROL [clientvpndemo.com]: 'PUSH_REQUEST' (status=1)
Sun Jun 26 23:47:10 2022 PUSH: Received control message: 'PUSH_REPLY,redirect-gateway def1 bypass-dhcp,block-outside-dns,dhcp-option DOMAIN-ROUTE .,route-gateway 172.16.1.33,topology subnet,ping 1,ping-restart 20,ifconfig 172.16.1.34 255.255.255.224,peer-id 0,cipher AES-256-GCM'
Sun Jun 26 23:47:10 2022 Pushed option removed by filter: 'redirect-gateway def1 bypass-dhcp'
Sun Jun 26 23:47:10 2022 Options error: Unrecognized option or missing or extra parameter(s) in [PUSH-OPTIONS]:2: block-outside-dns (2.4.7)
Sun Jun 26 23:47:10 2022 OPTIONS IMPORT: timers and/or timeouts modified
Sun Jun 26 23:47:10 2022 OPTIONS IMPORT: --ifconfig/up options modified
Sun Jun 26 23:47:10 2022 OPTIONS IMPORT: route-related options modified
Sun Jun 26 23:47:10 2022 OPTIONS IMPORT: --ip-win32 and/or --dhcp-option options modified
Sun Jun 26 23:47:10 2022 OPTIONS IMPORT: peer-id set
Sun Jun 26 23:47:10 2022 OPTIONS IMPORT: adjusting link_mtu to 1624
Sun Jun 26 23:47:10 2022 OPTIONS IMPORT: data channel crypto options modified
Sun Jun 26 23:47:10 2022 Outgoing Data Channel: Cipher 'AES-256-GCM' initialized with 256 bit key
Sun Jun 26 23:47:10 2022 Incoming Data Channel: Cipher 'AES-256-GCM' initialized with 256 bit key
Sun Jun 26 23:47:10 2022 TUN/TAP device tun0 opened
Sun Jun 26 23:47:10 2022 TUN/TAP TX queue length set to 100
Sun Jun 26 23:47:10 2022 /sbin/ip link set dev tun0 up mtu 1500
Sun Jun 26 23:47:10 2022 /sbin/ip addr add dev tun0 172.16.1.34/27 broadcast 172.16.1.63
Sun Jun 26 23:47:10 2022 WARNING: this configuration may cache passwords in memory -- use the auth-nocache option to prevent this
Sun Jun 26 23:47:10 2022 Initialization Sequence Completed
```
* Use gw from the output ( server push options ) and setup route to your VMs network ( assuming it's 10.0.0.0/24):
```
ip ro add 10.0.0.0/24 via 172.16.1.33
```
