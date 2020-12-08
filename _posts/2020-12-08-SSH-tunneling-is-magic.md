---
layout: single
sitemap: true
title: "SSH Tunneling is Magic !!"
categories:
  - Blog
tags:
  - CTF
  - SSH
  - Tricks
---



This weekend, I attempted [Metasploit community CTF](https://ctftime.org/event/1200), there was a key takeaway from how to approach this CTF challenges that's why I decided to do this post about it. Lets understand the scenario given.

The CTF portal provided two IP addresses one was a Kali host (Jump Box) to which we can connect using a SSH key. Inside the jump box there was a internal connection to a Ubuntu virtual machine (Target) which are running various challenges on respective ports, basically they are docker containers.

![Scenario of CTF](/assets/postimages/tunneling.png)

To, understand in a better way I added both VM's to hosts file for easy of access ( Humans are bad at remembering IP address, meh !! DNS 🤪 )

**Kali Machine IP :** jump.box (Internet accessible)
**Ubuntu Machine Target:** tar.get (accessible from jump box)

There, were multiple services running on different ports which where mostly web servers running web applications. The goal was to find png images which had naming convention of card deck. The MD5 sum of each image was the flag for the respective challenge. For the first day I was accessing them using curl itself 😅. Than I thought of using a VNC server from jump box to my host but it has limited support so idea dropped. Than I came across a nice method called **SSH tunneling**. 

So, the idea is forwarding the port from Jump box back to my host machine using SSH protocol. There are basically three types of port forwarding.

 - Local port forwarding (-L)
 - Remote port forwarding ( -R)
 - Dynamic application level port forwarding (-D)

 **Local port forwarding**

```bash
ssh -i private_key.pem kali@jump.box -L 6000:127.0.0.1:80 
```
This will forward port ``6000`` from jump box to target port ``80`` we can access port 80 on target from localhost:6000 of our host.

**Remote port forwarding**

```bash
ssh -i private_key.pem kali@jump.box -R 8000:127.0.0.1:22 
```
This will forward port ``8000`` of jump box to target port ``22`` The host here is relative to client not the server.

**Dynamic application level port forwarding**  

I ended up using the Dynamic port forwarding which was best for this use case for the first two refer this excellent post on [ssh.com](https://www.ssh.com/ssh/tunneling/example) 

To start the SSH tunnel I used this command. 

```bash
ssh -i private_key_of_jump_box.pem  kali@jump.box  -D 9090
```
It starts are **SOCKS5** proxy and forwards all ports on tar.get through jump.box back to my host machine using port ```9090``` so we can now access it from browser. 🎉

We can now use this proxy to connect to any open ports on tar.get as far as this ssh shell is alive. 

```
socks5h://127.0.0.1:9090
 ```

Now, we can use this socks proxy in burpsuite as upstream proxy server and set the normal burp proxy in our browser.  

![Burpsuite socks proxy](/assets/postimages/socks_proxy.png)

Now we can open http://tar.get on our local machine. Also with all testing tools as well (i.e : sqlmap, hydra) 

![Target on host machine](/assets/postimages/target_open_ctf.png)

It is very good way to expose internal servers to outside network during CTF's. Even SSH tunneling is used for various purposes in corporate environments also.

Ended up solving some challenges during the CTF. It was a good learning !!

![Scoreboard of metasploit ctf](/assets/postimages/scoreboard_ctf.png)

**Happy Hacking 🙂 !!** 

