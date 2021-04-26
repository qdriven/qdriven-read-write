---
title: Integration-Runner Test Case Demo
date: 2019-07-28 23:58:45
tags: ["api-teting","ep","english","48h"]
---

Last chapter introduce how to build a test framework in two days,
In this chapter, let's do demos:

- A Api TestCase
- Api Chain Test Case
- Pre-Condition And Verification Render to use context data


## A Api TestCase

[httpbin get api]:(http://httpbin.org/#/HTTP_Methods/get_get) 

Here are two cases: 

1. after call HttpBin API, check the url field in response is http://httpbin.org

```python
"verification": {"url": "is_equal_to http://httpbin.org"}
```
2.  after call HttpBin API, check the headers.Accept field in response is application/json1

The overall cases is:

```python 
{
    "test_cases": [{
        "name": "getapi-tc-1",
        "tc_id": "tc-get-1",
        "steps": [
            {
                "name": "http get api",
                "precondition": {},
                "service": HttpBinGet,
                "params": {},
                "verification": {"url": "is_equal_to http://httpbin.org"}
            }
        ]}
    ,{
        "name": "getapi-tc-21",
        "tc_id": "tc-get-2",
        "steps": [
            {
                "name": "http get api",
                "precondition": {},
                "service": HttpBinGet,
                "params": {},
                "verification": {"headers.Accept": "is_equal_to application/json1"}
            }
        ]}

    ]
}

```

and the demo codes are:

```python
@allure.epic("testing http bin test cases")
class TestHttpBinTestCase:

    @allure.feature("testing http bin get")
    def test_httpbin_get(self):
        runner = IntegrationExecutor(httpbinget_testcases)
        result = runner.run()
        assert result.get_tc_result() == "pass"
```

## Api Chain Test Case

test cases:

```python
{ 
    "test_cases": [{
        "name": "tc description",
        "tc_id": "testCaseId",
        "steps": [
            {
                "name": "http get api",
                "precondition": {},
                "service": HttpBinGet,
                "params": {},
                "post_action": {"url": "url", "args": "args"},
                "verification": {"url": "is_equal_to http://httpbin.org"}
            },
            {
                "name": "http post api",
                "precondition": {},
                "service": HttpBinPOST,
                "params": {},
                "post_action": {},
                "verification": {"url": "is_equal_to http://httpbin.org"}
            }
        ]
    }]
}
```

```python 
@allure.epic("testing http bin test cases")
class TestHttpBinTestCase:

    @allure.feature("testing http bin get/post")
    def test_httpbin_tc(self):
        runner = IntegrationExecutor(httpbin_testcases)
        result = runner.run()
        assert result.get_tc_result() == "pass"
```

the test cases code is almost same.


## Pre-Condition And Verification Render to use context data

This case is more complex, use pre-condition, post-action, and verficiation to checkout
how the context processing.

We have two Api:

- ```/json``` api to get a json, in this api's response, there is a ```author``` field,
value is "Yours Truly"
- ```/cookies/set``` api is to query a value by query parameter freeform

So assume there is a workflow in real business:
1. call `````/json````` to get author
2. then use the author name to query(call ```/cookie./set```) some author properties 

The author name might be changed over time in different environment, so I have to call 
the api first in step 1, then getting the author name as the second api's input, finally call the second 
api then verify the result .

So the example test cases is:

- Case 1: Use Context and Render Input and Verifications
![img](/images/complex_case.jpg)

- Case2: Use jinja2 built-in filter to handle parameters in test cases

![img](/images/jinja2_filter.jpg)

and again, there is no re-invention, just use the exiting jinja2 template