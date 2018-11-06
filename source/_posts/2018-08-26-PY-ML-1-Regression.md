---
title: 'PY ML 1: Regression'
mathjax: false
comments: true
author: XS Zhao
categories:
  - Practical Machine Learning with Python
tags:
  - machine learning
image: 'http://hansonzhao007.github.io/blog/images/infinite4.gif'
subtitle: Practical the Machine Learning with Python
abbrlink: 47720
date: 2018-08-26 20:48:53
keywords:
description:
---

# Regression Code
<!-- more -->
<script src="http://code.jquery.com/jquery-2.0.0.js"></script>
{% asset_jupyter /Users/mac/anaconda3/bin/python3 ../../jupyter-demo/regression.ipynb %}

# Pickle and Scaling
we can just save the classifier using the Pickle module

```python
import pickle
with open('linearregression.pickle','wb') as f:
    pickle.dump(clf, f)

pickle_in = open('linearregression.pickle','rb')
clf = pickle.load(pickle_in)
```