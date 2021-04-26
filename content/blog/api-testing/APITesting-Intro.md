---
title: Build API Testing Framework-1 - Learn Http Api
date: 2019-04-20 23:58:45
tags: ["api-teting","ep","english"]
---
##  Build API Testing Framework-1 - Learn Http Api

API now, in most cases, it is a HTTP API which over http protocol. It is hard to explain without a example, so let's start with a HelloWorld API sample.
The main purposes of these apis are to do the CRUD(Create/Read/Update/Delete) against the resouce ```HelloWorld```.
Here are HTTP Methods mapping to CRUD:

|HTTP Method|CRUD|Resource|Response|
|-----------|----|--------|--------|
|GET|Read|/HelloWorld/{id}|200:success/404: not found|
|POST|Create|/HelloWorld|200:success/404: not found|
|Update|Update|/HelloWorld/{id}|200:success/404: not found|
|Delete|Delete|/HelloWorld/{id}|200:success/404: not found|

It is easy to implement a sets of APIs against resource HelloWorld based on SpringBoot, here comes demo codes:

```java
@RestController
public class HelloWorldController {

    @GetMapping("/HelloWorld/{id}")
    public BaseResponse getHelloWorld(@PathVariable Long id) {
        return BaseResponse.OK().data(HelloWorldDTO.builder().id(id).msg("Hello World").build());

    }


    @PostMapping("/HelloWorld")
    public BaseResponse<HelloWorldDTO> createHelloWorld(@RequestBody HelloWorldDTO requestBody) {
        return BaseResponse.OK().data(requestBody);
    }

    @PutMapping("/HelloWorld/{id}")
    public BaseResponse<HelloWorldDTO> updateHelloWorld(@PathVariable Long id, @RequestBody HelloWorldDTO updateData) {

        return BaseResponse.OK().data(updateData);
    }

    @DeleteMapping("/HelloWorld/{id}")
    public BaseResponse<HelloWorldDTO> deleteHelloWorld(@PathVariable Long id) {
        return BaseResponse.OK().data(HelloWorldDTO.builder().id(id).msg("deleted!").build());
    }
}
```

Start the web server, actaully there are 4 apis with different HTTP methods, GET/DELETE/POST/PUT, use postman to check what happened:

![img](https://raw.githubusercontent.com/evenhumble/hustle-player/maste/img/postman-get.jpg)
![img](https://raw.githubusercontent.com/evenhumble/hustle-player/maste/img/postman-post.jpg)

It represents how the api work, and how to use postman to invoke the http api to get a result.

So the api testing is simple, a client send a http request, then get the http response to check if the response is correct. 

![img](https://raw.githubusercontent.com/evenhumble/hustle-player/maste/img/api_response.png)

In this case, if you want to start a api automation testing, what kind of codes need to write? In this case, it is very simple:

1. A clint to invoke http api: Client
2. Data builder to build input data: InputData
3. Verify the response: OutputData

the code example generated bu postman(java and OkHttpClient) is :

```sh
OkHttpClient client = new OkHttpClient();

MediaType mediaType = MediaType.parse("application/json");
RequestBody body = RequestBody.create(mediaType, "{\"msg\":123}");
Request request = new Request.Builder()
  .url("http://localhost:9090/HelloWorld")
  .post(body)
  .addHeader("Content-Type", "application/json")
  .addHeader("cache-control", "no-cache")
  .addHeader("Postman-Token", "ac6e83d3-8446-4ae7-81ea-59316ca5cce7")
  .build();

Response response = client.newCall(request).execute();
```

Copy these codes, and run in maven project, your first API automation code is completed.


By the way, there are several questions for HTTP API:

- What is Idempotent Methods? GET/HEAD/PUT/DELETE are declared idemponten
- What Option method used for? 
- Is http api stateless? What does the stateless mean? All the information is in the request.

In Next Chapter, let's write code and go through these cases.