---
title: A monitoring software for evaporator
mathjax: false
comments: true
author: XS Zhao
categories:
  - project
tags:
  - null
image: 'http://hansonzhao007.github.io/blog/images/infinite4.gif'
abbrlink: 35698
date: 2016-09-17 16:12:40
subtitle:
keywords:
description:
---

# Introduction

Accompanied by the development of automation technology, configuration technology, DCS PLC and other industrial control technology advance with each passing day, monitoring configuration software is becoming more and more widespread in the field of industrial control. To improve the productive efficiency of evaporators, and to ensure the safety of the production, this project has designed a control system.

This project uses the Siemens WinCC configuration software to develop a monitoring system, configuring the communication between the upper and the lower computer. Siemens WinCC configuration software is a user-friendly interface software, by which users can edit interface of the operation screen, monitor screen, the alarm screen, real-time trend curves, history trend curve, and print as required.

The system has real-time dynamic display and operation functions. It can monitor the production process of the falling film evaporator system, can achieve remote operation of the on-site equipment, and can show the operation status of the device. It can also draw the pressure-time curve, record the time when operators login, and export alarm records, data records and other records from the database.

This system lowers the operator’s labor strength and improves productive efficiency via setting user permissions and alarm through a user-friendly interface.

# Software
This project was finished in Perth, Australia, and was used to produce condensed carrot juice.

![](index.png)

This project uses PID-controller to control the pressure, flow rate and temperature.

![](facility.png)

![](alarm.png)

![](evaporaters.png)

![](evaporater.jpg)