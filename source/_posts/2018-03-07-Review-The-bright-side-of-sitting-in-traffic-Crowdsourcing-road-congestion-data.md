---
title: "Review:The bright side of sitting in traffic: Crowdsourcing road congestion data"
mathjax: false
comments: true
author: XS Zhao
categories:
  - review
tags:
  - google map
image: 'http://hansonzhao007.github.io/blog/images/infinite3.gif'
date: 2018-03-07 10:25:23
subtitle:
---
[This blog](https://googleblog.blogspot.com/2009/08/bright-side-of-sitting-in-traffic.html) is written on Aug. 25, 2009, it discusses how to use cell phone GPS signal to identify crowded road in the U.S.
> If you use Google Maps for mobile with GPS enabled on your phone, that's exactly what you can do. When you choose to enable Google Maps with My Location, your phone sends anonymous bits of data back to Google describing how fast you're moving. When we combine your speed with the speed of other phones on the road, across thousands of phones moving around a city at any given time, we can get a pretty good picture of live traffic conditions. We continuously combine this data and send it back to you for free in the Google Maps `traffic layers`.

The more users participant in this process, the more precise the report is. And this system was online to cover all U.S. highways and arterials in that week.
<!-- more -->
An issue that is addressed in the blog is `privacy`. People may not want to share their location and their destination data with others.
> We understand that many people would be concerned about telling the world how fast their car was moving if they also had to tell the world where they were going, so we built privacy protections in from the start. We only use anonymous speed and location information to calculate traffic conditions, and only do so when you have chosen to enable location services on your phone.

Google solve the `privacy` issue by using `anonymous speed and location` information. Also they `aggregate` the data to make it safer:
> When a lot of people are reporting data from the same area, we `combine their data together` to make it hard to tell one phone from another.

Google says they delete the `start and end point` of every trip. So I guess these data could only be stored in the cell phone temporarily.
> Even though the vehicle carrying a phone is anonymous, we don't want anybody to be able to find out where that anonymous vehicle came from or where it went — so we find the start and end points of every trip and permanently delete that data so that even Google ceases to have access to it.
