---
title: Rule Based Risk Engine Part 3 - The Easiest Mock, The highest ROI
date: 2019-04-28 23:58:45
tags: ["api-teting","ep","english"]
---

# Rule Based Risk Engine Part 3 - The Easiest Mock, The highest ROI

Actually it is not about how to test Rule Based Risk Engine, it is about how to use simple codes to improve the 
daily productivities. 

The Risk Engine is in the middle of the whole system, The upstream and downstream modules leverage
the result of the Risk Engine by API call in their own business flow. When other modules's tester want to execute their test cases,
they often wanted to get the different risk engine results on demand. That means I needed to support them for their cases
as I am the owner of risk engine. Everyday, I was interrupted serveral times. It really bothered me a lot. I can't refuse, but 
need to find a solution. Then the easiest mock came. 

## Mock- Get What You Set!

It is quite simple but it is worth to write because it represents the value of codes which a tester can implement. I implemented a new WebService in our repo, and used a Map to store what the client set for mocking 
purpose. Then next API call against the setting URL, the response is what the client Set even without any deployment or restart.

How can I achieve this? The most important thing is that we used the configuration center - [Apollo](https://github.com/ctripcorp/apollo). But does this mean in real case? You never need to restart the server for changing application properties. It makes things easier. The whole process was that:

1. Setup Mock by calling: ```http://domain/mock/A/setup```
2. Change the Risk Engine Url to ```http://domain/mock/A/getMock``` in Apollo Portal 
3. Deploy the changes
4. Other modules' QA now can control the Risk Engine Response for any cases.
   And even more, this actually can be  applied to any other Http service to decouple modules,free my time, and keep me focusing

Here is the simple codes.It only takes 10 minutes to complete, but it saved me a lot of time in daily basis.

- GenericMockStore for store Mock

```java
@Component
@Profile("test")
public class GenericMockMemStore {

    private ConcurrentHashMap<String, Object> mockStore = new ConcurrentHashMap<>();

    public void saveMock(String key, Object value) {
        this.mockStore.put(key, value);
    }

    public Object getMock(String key) {
        return this.mockStore.get(key);
    }

}
```

- GenericMock Service

```java
@RestController
@RequestMapping("/mock")
@Profile("test")
public class GenericMockController {

    @Autowire
    private GenericMockMemStore mockMemStore;

    @RequestMapping("/{productName}/setup")
    @PostMapping
    public MockSetupResponse setupMock(@RequestBody GenericMockResponse setupResponse,
                                       @PathVariable String productName,
                                       HttpServletRequest request){

        mockMemStore.saveMock(productName,setupResponse);
        return MockSetupResponse.success();
    }

    @RequestMapping(value = "/{productName}/getMock",method = {RequestMethod.GET,
                                                                RequestMethod.POST,RequestMethod.PUT})
    public Object getMock(@PathVariable String productName,
                                       HttpServletRequest request){

       return  mockMemStore.getMock(productName);
    }
}

```

Here is an explaination for these codes:

1. Two APIs:
   * ```POST /mock/{productName}/setup```  for setup mock for the ```productName``` you set
   * ```/mock/{productName}/getMock``` get the mock reponse which set previously
2. ```GenericMockMemStore```: Store the mocks by key: productName in memory

Like I said before, the automation testing is not about automation, but about writing codes for testing,and productivity.
Automation is a conception, not an action. It is too big to accomplish. But Writing codes is actionable, and you can see what 
you accomplished and what you improved immediately.

And also know the infrastructure more, you will find the solution is in the upstream or low level.
This is a tip I used when I tested this project. Luckly it worked. But still it is not a perfect solution, there are qeustions over here:

1. Is there any pain point to improve?
2. How to make it happen?
3. Don't write any code, use exisitng tools like YAPI, can we achieve the same?

Maybe you can find your answer, or stay tuned, I will write a post later.

Finally It is honor to make these codes in the develop official repos.





