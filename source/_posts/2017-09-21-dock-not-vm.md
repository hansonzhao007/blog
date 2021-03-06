---
title: Docker is not VM
mathjax: true
categories:
  - Technology
tags:
  - docker
abbrlink: 16725
date: 2017-09-21 20:10:00
---

I spend a good portion of my time at Docker talking to community members with varying degrees of familiarity with Docker and I sense a common theme: people’s natural response when first working with Docker is to try and frame it in terms of virtual machines. I can’t count the number of times I have heard Docker containers described as “lightweight VMs”.

I get it because I did the exact same thing when I first started working with Docker. It’s easy to connect those dots as both technologies share some characteristics. Both are designed to provide an isolated environment in which to run an application. Additionally, in both cases that environment is represented as a binary artifact that can be moved between hosts. There may be other similarities, but to me these are the two biggies.

<!-- more -->
The key is that the underlying architecture is fundamentally different between the two. The analogy I use (because if you know me, you know I love analogies) is comparing houses (VMs) to apartment buildings (containers).

Houses (the VMs) are fully self-contained and offer protection from unwanted guests. They also each possess their own infrastructure – plumbing, heating, electrical, etc. Furthermore, in the vast majority of cases houses are all going to have at a minimum a bedroom, living area, bathroom, and kitchen. I’ve yet to ever find a “studio house” – even if I buy the smallest house I may end up buying more than I need because that’s just how houses are built.  (for the pedantic out there, yes I’m ignoring the new trend in micro houses because they break my analogy)

Apartments (the containers) also offer protection from unwanted guests, but they are built around shared infrastructure. The apartment building (Docker Host) shares plumbing, heating, electrical, etc. Additionally apartments are offered in all kinds of different sizes – studio to multi-bedroom penthouse. You’re only renting exactly what you need. Finally, just like houses, apartments have front doors that lock to keep out unwanted guests.

With containers, you share the underlying resources of the Docker host and you build an image that is exactly what you need to run your application. You start with the basics and you add what you need. VMs are built in the opposite direction. You are going to start with a full operating system and, depending on your application, might be strip out the things you don’t want.

I’m sure many of you are saying “yeah, we get that. They’re different”. But even as we say this, we still try and adapt our current thoughts and processes around VMs and apply them to containers.

- “How do I backup a container?”
- “What’s my patch management strategy for my running containers?”
- “Where does the application server run?”

To me the light bulb moment came when I realized that Docker is not a virtualization technology, it’s an application delivery technology. In a VM-centered world, the unit of abstraction is a monolithic VM that stores not only application code, but often its stateful data. A VM takes everything that used to sit on a physical server and just packs it into a single binary so it can be moved around.  But it is still the same thing.  With containers the abstraction is the application; or more accurately a service that helps to make up the application.

With containers, typically many services (each represented as a single container) comprise an application. Applications are now able to be deconstructed into much smaller components which fundamentally changes the way they are managed in production.

So, how do you backup your container, you don’t. Your data doesn’t live in the container, it lives in a named volume that is shared between 1-N containers that you define. You backup the data volume, and forget about the container. Optimally your containers are completely stateless and immutable.

Certainly patches will still be part of your world, but they aren’t applied to running containers. In reality if you patched a running container, and then spun up new ones based on an unpatched image, you’re gonna have a bad time. Ideally you would update your Docker image, stop your running containers, and fire up new ones. Because a container can be spun up in a fraction off a second, it’s just much cheaper to go this route.

Your application server translates into a service run inside of a container. Certainly there may be cases where your microservices-based application will need to connect to a non-containerized service, but for the most part standalone servers where you execute your code give way to one or more containers that provide the same functionality with much less overhead (and offer up much better horizontal scaling).

“But, VMs have traditionally been about lift and shift. What do I do with my existing apps?”

I often have people ask me how to run huge monolithic apps in a container. There are many valid strategies for migrating to a microservices architecture that start with moving an existing monolithic application from a VM into a container but that should be thought of as the first step on a journey, not an end goal.

As you consider how your organization can leverage Docker, try and move away from a VM-focused mindset and realize that Docker is way more than just “a lightweight VM.” It’s an application-centric way to  deliver high-performing, scalable applications on the infrastructure of your choosing.

Check out these resources to start learning more about Docker and containers:

- [Watch an Intro to Docker webinar](https://docker.wistia.com/medias/fqwm0x9tgz)
- [Sign up for a free 30 day trial](https://hub.docker.com/enterprise/trial/)
- [Read the Containers as a Service white paper](http://www.docker.com/sites/default/files/caaSwhitepaper_V6_0.pdf)

# reference
[CONTAINERS ARE NOT VMS](https://blog.docker.com/2016/03/containers-are-not-vms/)
