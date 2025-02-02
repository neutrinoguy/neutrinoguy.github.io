---
layout: single
sitemap: true
title: "Nullcon #HackIM CTF 2025 -  Writeup"
categories:
  - Blog
tags:
  - CTF
  - nullcon
  - HackIM
  - web
  - misc
  - writeup
---

[Nullcon Goa #HackIM CTF](https://ctftime.org/event/2642) was organised between 1-2 Feb 2025, during which I passively participated and solved few challenges for for which I would like to share my approach. Overall the [CTF](https://ctf.nullcon.net/) was great with various categories of challenges such as web, pwn, misc, rev, cry etc. 

## Challenge : Profound thought

This challenge was hosted under **misc** category. This was basically a steganography challenge. The challenge description was as mentioned below. 

 ![Profound Though challenge](/assets/postimages/5/chal-1.png)

Once I downloaded the provided image and opened it looked like below. 

![Image provided in challenge](/assets/postimages/5/chal-1-image.png)

### Methodology 

The first thing I did was running strings and exiftool on this image file which did not returned any useful results, visually the image did show anything useful. If we see the image name carefully we read it as "l5b24c11", it looked like leekspeak a encoding method of writing text, on converting text form leetspeak it resulted "**lsb ascii**". On Googling further it shows [LSB (Least Significant Bit) ASCII](http://www.lia.deis.unibo.it/Courses/RetiDiCalcolatori/Progetti98/Fortini/lsb.html) is a method of hiding data in images, this was a interesting lead. Finding further tools to extract text from image results in this nice script [pyLSB](https://github.com/RenanTKN/pylsb). 

On running this script it wrote the output to a file which got us the flag :) 

```bash 
ENO{57394n09r4phy_15_w4y_c00l3r_7h4n_p0rn06r4phy}
```

Got our Interesting Flag 😂

## Challenge : Numberizer

This was web category challenge. Below was the challenge description. 

![Numberizer challenge](/assets/postimages/5/chal-2.png)

On visiting the URL provided it showed below web page. 

![Webpage](/assets/postimages/5/chal-2-webpage.png)

One thing we can see that it accepts 5 numbers but writes 10 numbers can be provided which is fishy. The page also had a link to source code of the challenge at /?source page. 

```php
<?php
ini_set("error_reporting", 0);

if(isset($_GET['source'])) {
    highlight_file(__FILE__);
}

include "flag.php";

$MAX_NUMS = 5;

if(isset($_POST['numbers']) && is_array($_POST['numbers'])) {

    $numbers = array();
    $sum = 0;
    for($i = 0; $i < $MAX_NUMS; $i++) {
        if(!isset($_POST['numbers'][$i]) || strlen($_POST['numbers'][$i])>4 || !is_numeric($_POST['numbers'][$i])) {
            continue;
        }
        $the_number = intval($_POST['numbers'][$i]);
        if($the_number < 0) {
            continue;
        }
        $numbers[] = $the_number;
    }
    $sum = intval(array_sum($numbers));


    if($sum < 0) {
        echo "You win a flag: $FLAG";
    } else {
        echo "You win nothing with number $sum ! :-(";
    }
}
?>

<html>
    <head>
        <title>Numberizer</title>
    </head>
    <body>
        <h1>Numberizer</h1>
        <form action="/" method="post">
            <label for="numbers">Give me at most 10 numbers to sum!</label><br>
            <?php
            for($i = 0; $i < $MAX_NUMS; $i++) {
                echo '<input type="text" name="numbers[]"><br>';
            }
            ?>
            <button type="submit">Submit</button>
        </form>
        <p>To view the source code, <a href="/?source">click here.</a>
    </body>
</html>
```

### Methodology 

The code was written in PHP, I used ChatGPT to help me walkthrough the code. It explained following things. 

 - Code accepts 5 numbers with max size of four. 
 - It checks if number is non negative. 
 - All provided numbers are summed and checks if sum is greater then 0 and print value in output. 
- If sum is not greater then 0 it gives us ``` $FLAG``` 

So, finally the script expects us to provide 5 positive numbers and result should be a negative number in order to get the flag. 

I noticed the code ensure that it converts any negative number to positive integer using ``` intval( ) ``` [function](https://www.php.net/manual/en/function.intval.php) of PHP.  I started playing around the function and searching if potential bypasses are there for this function and indeed there were. 

From reading around the internet, came to know that this function behaves differently on 32 bit and 64 bit system and not all values through it returns positive numbers one such example can be found [here](https://www.php.net/manual/en/function.intval.php#120543). 

Started experimenting with intval() with different inputs like below. 

```php
<?php

$number = 1e4;
$sum = intval($number);
echo $sum;

?>
output: 10000
```

```php

<?php

$number = 9e99;
$sum = intval($number);
echo $sum;

?>

output: 0
```

Interesting, ```9e99``` satisfies all required condition by still returns 0 at output. This could potentially yield different results on 32 bit systems. I tried this for all four fields as value and we got our flag :) 

```bash 
ENO{INTVAL_IS_NOT_ALW4S_P0S1TiV3!} 
```
Thats a wrap, I did went further with other challenges but was not able to solve till final flag. Overall CTF was good learning experience. You can read writeups for other challenges here on [CTFtime](https://ctftime.org/event/2642/tasks/) shared by other teams. 

 Thanks to [ENOFLAG](http://ctftime.org/team/1438) for organising this CTF. Happy Hacking 🙂
