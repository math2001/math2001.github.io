---
title: Lessons Learned From Being a Slack Open Source Maintainer for 2 Years
slug: lessons-learned-from-being-a-slack-open-source-maintainer-for-2-years
date: 2020-01-05T20:17:48+11:00
tags: [oss, maintainer]
draft: true
---

First, face the reality. My plugin(s) aren't going to get 100% of attention all of the time. It's open source, I don't get any money from it, I have other priorities, sometimes I don't have time/motivation. And I've seen maintainer burn out. Sometimes I want to create things. So, how can we write open source software that last *without a maintainer*?


The responsibilities of an open source maintainer includes that of making sure that his project doesn't depend on him.


### Write code that survices *when unmaintained*

I want to write grown-up software. That is, my programs shouldn't need me to look after them constantly.

writing code to be maintainable *when unmaintained*. That means, it should be easy for people to debug => have a debug flag that can be turned on. That's just to make it really easy for people to start maintaining your code (send occasional PRs). Of course, it's never going to be perfect (you still have to merge that PR), but it's already a lot better.

### Keep documentation as small as possible

Every once of effort you put in this project just takes away from your resource bank. Documentating a project can be draining. You're doing a disservice to your users by burning yourself out not using the most efficient process to document your project.


- keep docs as small as possible
- keep your docs as close to the code as possible (go does that really well for example)
- avoid duplicates

For example, you write a Sublime Text plugin, which has different settings. The setting's documentation should *in your settings file*. It's the convention, and it's efficient. So do that. DO NOT copy/duplicate that in your readme. Instead, your README should point to the settings file.

Some plugins just don't need to be updated.	

I haven't figured it out completely, but I'm just trying to find some rules that I can just apply to make my life easier.