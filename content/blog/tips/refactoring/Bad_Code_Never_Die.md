# Bad Code Never Die

坏代码到处都是，好代码其实也不少，了解坏在哪里，好在哪里才是最重要的.

## Start it

Simplicity over common logic.

A simple code to get has next or not as follow.These codes are following our logic thinking competely.It is good.

```java
public boolean hasNext(){
  if(db.next()) {
     return true;   
   } else {
     return false;
   }
}
```

But if we think twice, maybe there is a more abstract way, actually just use following codes:

```java

public boolean hasNext(){
  return db.next()
}
```

db.next() already represents the result whether hasNext or not. So sometimes abstract is simplicity.

## What is the if/else really used for?

```java
  if(0==retCode){
    sendMessage("000","Success",returnCode);
  }else{
    sendMessage("000","Fail",returnCode);
  }
```

The only difference is the Succecss or Fail message when call sendMessage, so actually if/else is only for message(Success or Fail),not for sendMessage.So:

```java
String msg = 0==retCode?"Success":"Fail";
sendMessage("000",msg,returnCode);
```
And what if the difference is not only Success or Fail, also returnCode......; if so, it doesn't change if/else's scope at all, it is for the what message to send but not for
send message. so the codes might be :

```java
ResMsg msg = 0==retCode?new ResMsg("123","Success",OK):new ResMsg("234","Fail",Fail);
sendMessage(msg);
```

## Extract Method

There are a few checking for a.class, but why not putting all these type into a list, then for-loop this list? it is more readable.

```java

if(a.class==String.class
  ||a.class==Boolean.class
  ||a.class==SelfDefined.class
  ||a.class==Float.class
  ......){
  return true;
}

return false;
```

Changed to Following codes:

```java
List<Class> checkedClasses = Lists.newArrayList(String.class,Boolean.class,.....)
for(checkedClass in checkedClasses){
  if a.class.equals(checkedClass){
    return true;
  }
}

return false;
```

Why is it good?
- it is more readable
- it is abstraction
- if add more checking class, just change the checkedClasses list, it is easy for plugin or hook

sometimes, using map to replace some if/else logic is good too. The reason is quite similar.

Extract Method is a refactor methodology. It is quite useful.

## Naming

Naming is everything, if there is variable named a,b, after a while, everyone would be lost even the writer.
Name like XString,YString, it doesn't make your look like a hacker, but a unprofessional developer.

## 不允许出现多层缩进

A simple rule, but useful. Consider not use too many if else. maybe one if/else is enough.

## SimpleDateFormat

SimpleDateFormat is not thread safe, so it is wrong when use it as a static variable in a class.

```java
class Sample {
  private static final DateFormat format = new SimpleDateFormat("yyyy.MM.dd");

  public String getCurrentDateText() {
    return format.format(new Date());
  }
}
```
