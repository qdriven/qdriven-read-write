---
title: Implement A Integration Testing Libs in two days
date: 2019-07-28 23:58:45
tags: ["api-teting","ep","english","48h"]
---

There is a question over my head several times. is it real hard for tester to write test codes? 
I don't know, but I just want to do a task to evaluate this conclusion.

## Start From The End

I don't prefer the term ***automation testing***, but like the term ***write testing codes***.
Automation testing is almost defined as failure in most of testers's mind(not company, company still think it is valuable).
As I known, many testers(a big portion actually) just think automation testing is a political job which actually has no value at all in reality. 
Most of the automation cases are never used after it passed one time. 
Almost in every testing meet-up, there is always someone talked about test platform,how good it is,how easy to use.
But in reality,almost every test platform user complained the test platform is to hard to use. Why? and what's the gap between those platform and
their users. 

I don't know. But I just believe automation testing will never happen if you never write codes, only doing configuration like coding.
Write scripts should be a basic skill for tester, like eating or drinking. 

And in other hands, setting a high expectation in a short period of time which is way beyond the average tester's coding skill.
There are too much legacy debit out there. High expectation meets even high debit, it can easily crash you. 
The delayed schedule, the unreachable target, and voices like automation testing doesn't work is just around you.
Finally, you will find out automation never from nowhere, it happened when you write codes line by line just. 
And if you re-think about automation, it is quite reasonable. It is just like a product which want to automate business flow. The product is built by 
tons of codes. So does automation testing. And also to pay back the debit, accumulate codes in daily basis in the key. Don't expected to pay back it 
in a short time, just focus accumulating the tests day in and day out, then someday, you will feel a little easy.

 
Back to the topic, What the task is given to myself is that:

1. Write A Simple Integration Libs as a tiny testing framework(just work) in 2-3 days
2. Leverage Existing Libs as more as possible, and don't write too much complex codes
3. Integration library, not a http library. It is open for different component client
4. The test codes could be used in any other place,but not only for testing
5. Not strict, different coding level can use and ramp  up

## Let's getting start

Think about integration testing(not consider UI), it is actually calling different service or api, then get a result to verify.
![img](/images/test-service.jpg)

And if in more complex workflow, it looks like a workflow or api call chain
![img](/images/chained-invoker.jpg)


So I need to abstract these into following conception:

1. ***Executor***: execute the who process no matter how many steps the test case should have
2. ***Client***: every api/service invoker is a client, no matter http,redis,database or whatever tester used in daily 
basis for send a request to get a response 
3. ***Validator***: verify the result
4. ***TestCase***:  test cases with test case data and steps


## Executor - Integration Executor

Integration Executor is used to run the whole test case, and it is the core
of this tiny lib, it targets to connect all the things used when testing.

![img](/images/process.jpg)

Let's do following things to implement it:
1. define the test case data structure
2. implement a generic client
3. implement a extractor to extract data from response
4. implement a validator to validate result
5. implement a context to store and calculate runtime data when execute test cases

## Client

The client implement is for generic purpose, so I just define a callable object
or with a invoke method:
```python
class Client:

    def __init__(self, params, env):
        self.params = params
        self.env = env

    def invoke(self):
        """
        what ever
        :return: ClientResponse
        """
        raise NotImplementedError("abstract class, need an implementation")

    def __call__(self, *args, **kwargs):
        print("client should a callable object or with a invoke method")
        return self.invoke()
``` 

-  and the response for a client also need to be unified and generic:

```python
class ClientResponse():

    def __init__(self, response):
        pass
```

- So basically I defined a generic client which the input is :

1. ```params```: input test data
2. ```env```: target environment

- Output is:

```ClientReponse```: Generic Output Object, which have a status code and response data, data should 
be in json or dict which is easy to handle 


A http client is implement based on python ```requests``` lib:

```python
http_methods = {

    "get": requests.get,
    "post": requests.post,
    "delete": requests.delete,
    "put": requests.put,
    "option": requests.options
}

class HttpClient(Client):
    req_url = ""
    domain = ""
    headers = {
        "accept": "application/json",
        "content-type": "application/json"
    }
    req_body = {}  ## make sure the some variables with default values
    query_params = []
    method = "post"

    def __init__(self, params, env):
        super().__init__(params, env)

    def invoke(self):
        real_req_url = self.__build_request_url()
        self.__build_header()
        self.__build_body()
        http_method = http_methods.get(self.method.lower(), requests.get)
        response = http_method(url=real_req_url, headers=self.headers, data=self.req_body)
        return make_client_response(response)

    def __build_request_url(self):
        if self.env.get_config_by_key(self.domain) is None:
            raise ClientException("domain name should be set in environment or config file")
        else:
            url = self.env.get_config_by_key(self.domain)

        real_req_url = url + self.__make_request_path() + self.__make_query_url()
        return real_req_url

    def __build_header(self):
        if self.params.get("headers", "") != "":
            for h_name, h_value in self.params.get("headers").items():
                self.headers.update({h_name: h_value})

    def __make_request_path(self):
        self.req_url = self.req_url.format(**self.params)
        return self.req_url

    ## todo: set value in a dict,use path
    def __build_body(self):
        for param_name, param_value in self.params.items():
            kv_util.set_value(self.req_body, param_name, param_value)

    def __make_query_url(self):
        query_url = ""
        if len(self.query_params) > 0:
            query_url = query_url + "?"
        # query_temp ="%s=%s&"
        for query_param in self.query_params:
            if self.params.get(query_param, "") != "":
                query_url = query_url + query_param + "=" + self.params.get(query_param, "") + "&"
        return query_url

```

Don't invent any new thing, just use [requests](http://docs.python-requests.org/zh_CN/latest/user/quickstart.html)

## Extractor 

 First of all, why I need an extractor? 
 The extractor is used to get a value from a json or dict by an expression like jsonpath.
 So that we can leverage this tiny tool to get any value in response.
 
 The demo:
 
 ```python
simple_dict_json = {
    "characters": {
        "Lonestar": {
            "id": 55923,
            "role": "renegade",
            "items": [
                "space winnebago",
                "leather jacket"
            ]
        },
        "Barfolomew": {
            "id": 55924,
            "role": "mawg",
            "items": [
                "peanut butter jar",
                "waggy tail"
            ]
        },
        "Dark Helmet": {
            "id": 99999,
            "role": "Good is dumb",
            "items": [
                "Shwartz",
                "helmet"
            ]
        },
        "Skroob": {
            "id": 12345,
            "role": "Spaceballs CEO",
            "items": [
                "luggage"
            ]
        }
    }
}

# encoding: utf-8
class TestDataExtractor:
    def test_list_get_value_by_exp(self):
        result = data_extractor.get_value_by_exp(simple_dict_json, "characters")
        assert len(result) >= 1

    def test_get_value_by_exp(self):
        result = data_extractor.get_value_by_exp(simple_dict_json, "characters.Lonestar.items[0]")
        assert result == "space winnebago"

    def test_get_value_by_exp_not_exist(self):
        result = data_extractor.get_value_by_exp(simple_dict_json, "characters.Lonestar323.items[0]")
        assert result == "space winnebago"
```

just give a path expression, then get the value without going to a json level by level.

Don't invent new thing:  the implementation is relied on following lib:

- jmespath
- dictor

## Validator

Validator is used to validate if an actually result meets the expected result.

Also, refer to the assertPy, I did a function to validate result:

The Demo: 

```python
class TestValidator():

    def test_demos(self):
        result = validator.validate("value","is_equal_to test")
        assert result[0],"fail"
        print(str(result[1]))
```

## Test Case

Test Case is to connect all these things to feed into Integration Runner

The Basic Schema is :

```json
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
                "params": {"url": "{{args}}"},
                "post_action": {},
                "verification": {"url": "is_equal_to http://httpbin.org", "json": "is_none"}
            }
        ]
    }]
}
```

The schema is easy to understand. The ```service``` is for a Python Object, here
HttpBinGet is an api for call HttpBinGet service, and the service is also easy to 
implement.

```python
class HttpBinGet(HttpClient):
    req_url = "/get"
    domain = "domain"
    headers = {
        "accept": "application/json",
        "content-type": "application/json"
    }
    req_body = {}  ## make sure the some variables with default values
    query_params = []
    method = "GET"
```

## Context

Context is used for store and calculate data. It will be used in executor 
in process pre-condition and post action to handler.

What data context stored in key-value manner, for example:

in test case data:

```python
 "post_action": {"url1": "url", "args1": "args"}
```

the post action processor will put url1 as key, the value is the value extracted
by the path "url" from response

and also, the context will used to render data in process pre-condition,
because some input data is in generated in runtime:

```python
"params": {"url": "{{args}}"}
```
{{args}} will be replaced by a value which is from response before. Use python template lib
jinja2 can achieve it.

## Revisit Executor

Now every tiny thing is ready for Executor. And everything is ready.

For Detail please refer the demo.