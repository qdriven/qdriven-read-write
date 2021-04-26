---
title: Xmind,Test Cases,and Allure templates for TDD
date: 2019-08-07 21:34:04
tags: [JAVA,PE]
---

# Xmind,TestCases and JUnit5 Allure Template

Learn from the requirements and write test cases are the common daily work of a tester.
Normally write the mind map as a guide of test cases(in internet it is enough), then 
execute the test cases or write testing codes based on the xmind file(mind map).
But do you ever question about this process? It is productive enough? Is there any improvement?

<!-- more -->

Let me give an example: I want to test a DateUtil functionality, it has several features, the mindmap like this:

1. DateUtil Test Cases Mindmap:
![img](/images/productivity/testcase_map.jpg)

2. Then write test codes(your boss required you to write automation codes) using junit and allure:

```java
@Epic("Hutool DateUtil Usage")
@Feature("Hutool DateUtil Simple Usage")
public class HutoolDateUtilsTest {


    @Test
    @DisplayName("DateUtil-Formatter-From Date")
    @Story(value ="Formatter-From Date" )
    public void testFrom_Date(){
        //write testing codes
    }

    @Test
    @DisplayName("DateUtil-Formatter-From DateTime")
    @Story(value ="Formatter-From DateTime" )
    public void testFrom_DateTime(){
        //write testing codes
    }
}
```

[allure](https://docs.qameta.io/allure/#_junit_5) is a tool for unified test report. It is worth to use.
Two conceptions in allure mapping to requirments: 

* EPIC: A big functionality,usally have several small featuers
* Feature: A relative small functionality, which might have one or more user stories
* User Story: a small/independent functionality

Writing code is actually transforming the test cases into codes, and labeling the test codes by different test cases names.

3. Running the tests, the report is like:

![img](/images/productivity/allure_story_feature.jpg)


It is perfect! But don't you think you write test cases twice? In ***xmind***, and in ***code*** like ***@Story*** bla bla bla .....

Why do I write the annotations like @Story,@Epic or @Feature? The answer is that I want to make a fancy report,but I actually did duplicated work, didn't I?  Duplicate work have bad smell. In this case, it looks like you sacrifice your productivity to make report fancy. What if I want both fancy report and productivity? Is it possible to write once?  Scripting Boy thought there should be a way.


## Become a scripting boy to connect these dots

Actaully It is not that hard to find a way to achieve the goal: fancy report and productivity both. 
Let me figure it out:

1. Export to test cases in markdown format through xmind(xmind has java/python sdk to manupilate the xmind file, but it is too complex), export is in xmind menu ***file>export>text***:

![img](/images/productivity/export_md.jpg)

BTW: importing md file to xmind is in ``file>import>text```

The exported markdown file content:

```sh
# DateUtil
## Functions
### isSameDate
### CurrentYear
### CurrentMonth
### CurrentDay
```

2. Parse the markdown test cases, and render parsed test cases into testing code template
It is not hard, there are only three files, and less than 50 lines of codes:

- pom.xml for leveraging existing libs
```java
        <dependency>
            <groupId>org.jtwig</groupId>
            <artifactId>jtwig-core</artifactId>
            <version>5.87.0.RELEASE</version>
        </dependency>
```

- a junit test code template file in class path(resources folder),named ***junit_allure_template.twig***

```java
import io.qameta.allure.Epic;
import io.qameta.allure.Story;
import io.qameta.allure.Feature;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

@Epic("{{context.epic}}")
@Feature("{{context.epic}}")
public class {{context.epic}}Test {

   {% for entry in context.features.entrySet() %}
    {% for feature in entry.value() %}
        @Test
        @DisplayName("{{context.epic}}-{{feature.desc}}")
        @Story(value ="{{feature.desc}}" )
        public void test{{feature.name}}(){
            //write testing codes
        }
    {% endfor %}
   {% endfor %}
}
```

- 50 lines of codes, to read the exported markdown file, and render the template ***junit_allure_template.twig***
 
```java
public class Junit5TestTemplateGenerator {

    public static void generateJunit5TC(String mdFile,String fileName) throws IOException {
        AllureTestModel allureTestModel = new AllureTestModel();
        List<String> mdContent= Resources.readLines(Resources.getResource(mdFile),Charsets.UTF_8);

        String currentFeature="";
        for (String line : mdContent) {
            if(line.startsWith("###")){
                AllureFeature feature = new AllureFeature();
                feature.setDesc(currentFeature+"-"+line.replace("###","").trim());
                feature.setName(line.replace("###","").trim().replace(" ","_"));
                allureTestModel.features.get(currentFeature).add(feature);
            }else if(line.startsWith("##")){
                currentFeature = line.replace("##","").trim();
                allureTestModel.features.putIfAbsent(currentFeature,new ArrayList<>());
            }else if(line.startsWith("#")){
                allureTestModel.setEpic(line.replace("#","").trim());
            }
        }

        JtwigTemplate template = JtwigTemplate.classpathTemplate("junit_allure_template.twig");
        JtwigModel model = JtwigModel.newModel().with("context",allureTestModel);
        template.render(model,new FileOutputStream(new File(fileName+".java")));
    }

    @Data
     public static class AllureTestModel{
        private String epic;
        private Map<String,List<AllureFeature>> features = new HashMap<>();
     }

     @Data
     public static class AllureFeature{
        private String name;
        private String desc;
     }
     public static void main(String[] args) throws IOException {
        Junit5TestTemplateGenerator.generateJunit5TC("DateUtil.md","HutoolDateUtilTest.java");

    }
}
```

And the result is:

```java
@Epic("Hutool DateUtil Usage")
@Feature("Hutool DateUtil Simple Usage")
public class HutoolDateUtilsTest {
    @Test
    @DisplayName("DateUtil-Formatter-From Date")
    @Story(value ="Formatter-From Date" )
    public void testFrom_Date(){
        //write testing codes
    }

    @Test
    @DisplayName("DateUtil-Formatter-From DateTime")
    @Story(value ="Formatter-From DateTime" )
    public void testFrom_DateTime(){
        //write testing codes
    }
    ......
}   
```
which is same as your writing before.

Scripting boy is not kidding you, use a JAVA template lib to make both fancy report and test cases real without 
duplicated work. 

It is not perfect solution which I need to admit. But it works somehow, and save my time anyway. 
It also demostrated that there are plenty opportunities to tester to practice coding skills,
to know a little bit more about other libaries. It is not about rocket science, not about make a fancy product, it is just about practicing day in and day out to make life a little bit easier than before. 

## What's next?

It looks good, not why not write it as a plugin of a modern ide like intellj IDEA. Wait, Wait, I am a scripting boy, try to
make a product?  But Why not? And why not support more templates like testng or other testing framework?  See you next time!


## Reference Code

- [github](https://github.com/evenhumble/tdd-simple)