# <center>Uhxx</center>
## <center>Why did I reinvent the wheel without the spokes<center>


1. [Introduction](#introduction)
2. [Setting the scene](#setting the scene)
3. [Before the storm](#before-the-storm)



## Introduction

This manifesto exists to explain why I took a drastic, maybe useless and egomaniacal decision to rewrite a populer library.
Even if I took a lot of time to try others ways I ultimately decided doing so .

I would like to clarify this manifesto doesn't exists to shame in anyway the Nyxx_* libraries maintainers as this work would not exists without them.


## Setting the scene

I remember in 2013 when i first started writing discord bots using discord.js. 
At this time, bot still used standard user accounr and authenticated themselves with an email/password, soon after came the tokens. 

I was still in my software engineering bachelor and honestly writing those bots helped me learn a lot more about Javascript/Ecmascript (and Node.JS) than any courses.

It was at the same time that I learned about a new language created by Google, something based off Java which at the time was my favorite language (no offence C# but ... ) : Dart.

Toying around with Dart **1** in Dart Editor (again the great era of Eclipse based editors !), I was amazed how easy and quick it was to understand the language logic. 
I remember being blow away by the fact I could use it instead of Javascript inside my web pages ! (Again, I was really nood / begginer with Node.JS).

I loved it so much that my two years long portfolio website was writter in HTML/CSS (Hello boostrap 4 !) with some custom logical written in Dart whic, to be honest didn't had as much as effect I would have hoped for.

Anyway life goes on, I worked a lot with PHP, HTML/CSS, Javascript and at night toy around with Node.JS and Electron as I was the time where Electron came out.

Then a few years later, Flutter came out. A cross platform mobile oriented framework supporting native like widget for both Android and iOS.

To say "I was exited" would be an understatement. Anyway, Flutter use Dart ! Great I alreayd know let's get our hand dirty....

And then reality hit me, those were Dart **2** days and **null safety** was around the corner. I still ran the flutter exemple but I knew I would have to relearn how to use Dart.

As the time flew by, I never forgot that a great way to train myself in dart would be to rewrite my discord bot in it. Looking around [https://pub.dev] didn't bring result as good as discord.js so I let myself believe I could write my own framework.

Big mistake of course since at the time I knew nothing about web requests, discord api internals and so on, so when the word `Websocket`came up I let a long sigh out...

Anyway, I trained on simplier projects, writtig API clients for various webistes to play around with `http`package, built a small web server in vanilla dart (no `shelf`) for my company to handle an internal url shortener/ redirector.

At the same time I discovered the grail of dart discord libraries : **Nyxx**.

A lot of time trying examples, reading the documentation and I was pleased to have a bot running in Dart

Not as polished or reactive as my discord.js one but still, I felt I discovered a great library and in time I would have a dozen bots running **Nyxx**.

Then came the storm.


## Before the storm

First, I need to describe that make **Nyxx** this great for me.




