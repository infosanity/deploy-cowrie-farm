[honeypot]
hostname = ${hostname}
log_path = var/log/cowrie
download_path = $${honeypot:state_path}/downloads
share_path = share/cowrie
state_path = var/lib/cowrie
etc_path = etc
contents_path = honeyfs
txtcmds_path = txtcmds
ttylog = true
ttylog_path = $${honeypot:state_path}/tty
interactive_timeout = 180
authentication_timeout = 120
backend = shell
timezone = UTC
auth_class = UserDB

[backend_pool]
pool_only = false
recycle_period = 1500
listen_endpoints = tcp:6415:interface=127.0.0.1
save_snapshots = false
snapshot_path = $${honeypot:state_path}/snapshots
config_files_path = $${honeypot:share_path}/pool_configs
network_config = default_network.xml
nw_filter_config = default_filter.xml
guest_config = default_guest.xml
guest_privkey = $${honeypot:state_path}/ubuntu18.04-guest
guest_tag = ubuntu18.04
guest_ssh_port = 22
guest_telnet_port = 23
guest_image_path = /home/cowrie/cowrie-imgs/ubuntu18.04-minimal.qcow2
guest_hypervisor = kvm
guest_memory = 512
guest_qemu_machine = pc-q35-bionic
use_nat = true
nat_public_ip = 192.168.1.40

[proxy]
backend = pool
backend_ssh_host = localhost
backend_ssh_port = 2022
backend_telnet_host = localhost
backend_telnet_port = 2023
pool_max_vms = 5
pool_vm_unused_timeout = 600
pool_share_guests = true
pool = local
pool_host = 192.168.1.40
pool_port = 6415
backend_user = root
backend_pass = root
telnet_spoof_authentication = true
telnet_username_prompt_regex = (\n|^)ubuntu login: .*
telnet_password_prompt_regex = .*Password: .*
telnet_username_in_negotiation_regex = (.*\xff\xfa.*USER\x01)(.*?)(\xff.*)
log_raw = false

[shell]
filesystem = $${honeypot:share_path}/fs.pickle
processes = share/cowrie/cmdoutput.json
arch = linux-x64-lsb
kernel_version = 3.2.0-4-amd64
hardware_platform = x86_64
operating_system = GNU/Linux
ssh_version = OpenSSH_7.9p1, OpenSSL 1.1.1a  20 Nov 2018

[ssh]
enabled = true
rsa_public_key = $${honeypot:state_path}/ssh_host_rsa_key.pub
rsa_private_key = $${honeypot:state_path}/ssh_host_rsa_key
dsa_public_key = $${honeypot:state_path}/ssh_host_dsa_key.pub
dsa_private_key = $${honeypot:state_path}/ssh_host_dsa_key
ecdsa_public_key = $${honeypot:state_path}/ssh_host_ecdsa_key.pub
ecdsa_private_key = $${honeypot:state_path}/ssh_host_ecdsa_key
ed25519_public_key = $${honeypot:state_path}/ssh_host_ed25519_key.pub
ed25519_private_key = $${honeypot:state_path}/ssh_host_ed25519_key
public_key_auth = ssh-rsa,ecdsa-sha2-nistp256,ssh-ed25519
version = SSH-2.0-OpenSSH_6.0p1 Debian-4+deb7u2
ciphers = aes128-ctr,aes192-ctr,aes256-ctr,aes256-cbc,aes192-cbc,aes128-cbc,3des-cbc,blowfish-cbc,cast128-cbc
macs = hmac-sha2-512,hmac-sha2-384,hmac-sha2-56,hmac-sha1,hmac-md5
compression = zlib@openssh.com,zlib,none
listen_endpoints = tcp:2222:interface=0.0.0.0
sftp_enabled = true
forwarding = true
forward_redirect = false
forward_tunnel = false
auth_keyboard_interactive_enabled = false

[output_jsonlog]
enabled = true
logfile = $${honeypot:log_path}/cowrie.json
epoch_timestamp = false

[output_elasticsearch]
enabled = false
host = localhost
port = 9200
index = cowrie

[output_dshield]
enabled = false
userid = userid_here
auth_key = auth_key_here
batch_size = 100

[output_sqlite]
enabled = false
db_file = cowrie.db

[output_cuckoo]
enabled = false
url_base = http://127.0.0.1:8090
user = user
passwd = passwd
force = 0

[output_slack]
enabled = false
channel = channel_that_events_should_be_posted_in
token = slack_token_for_your_bot
debug = false

[output_s3]
enabled = true
#access_key_id = AKIDEXAMPLE
#secret_access_key = wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY
bucket = ${s3_bucket}
region = eu-west-1

[output_reversedns]
enabled = true
timeout = 3

[output_misp]
enabled = false
base_url = https://misp.somedomain.com
api_key = secret_key
verify_cert = true
publish_event = true
debug = false
