---
title: Word Frequency - Use JDK Methods
date: 2018-06-08 01:50:03
tags: ["interview","english"]
---

## What is the problem
 
Be confidence to the JDK, in most case, it is enough to solve problem. Here is a case, an issue to solve:

- There are over 10000 files in a dir
- Try to find out the top 100 most frequency words in these files, estimate 10 millions words out there
- Try to use 

I didn't sovle it in 40 mintues, the failure part is just think too much about the data structure and algorithm. I just did some investigation then, and find out actually JDK methods are enough.

Here is my thought, and I think need to implement my own algorithm to solve, actually I am wrong, JDK is enough

- Read the files
- Put word and count to a concurrent map
- get the top 100 from the map

Because I am a fraid the memory and other resource issue, but later I had my try, it looks like worked if only use JDK methods. Here comes my solution.

## Solution

First of all, I try to create 10000 files with some random string(word),all strings are less than 18 characters, the codes are :

``` java
static String getSaltString() {
    String SALTCHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
    StringBuilder salt = new StringBuilder();
    Random rnd = new Random();
    int strLength = rnd.nextInt(10);
    if(strLength<=2){
      strLength =3;
    }
    while (salt.length() < strLength) { // length of the random string.
      int index = (int) (rnd.nextFloat() * SALTCHARS.length());
      salt.append(SALTCHARS.charAt(index));
    }
    String saltStr = salt.toString();
    return saltStr;
  }
  
  private static List<String> createRandomFile() {
    List<String> result = new ArrayList<>();
    for (int i = 0; i < 1000; i++) {
      List<String> listString = new ArrayList<>();
      for (int j = 0; j < 50; j++) {

        listString.add(getSaltString());
      }
      StringBuilder sb = new StringBuilder();
      for (String s : listString) {
        sb.append(" ").append(s);
      }
      result.add(sb.toString());
    }
    return result;
  }

  private static void createFile(int i, List<String> values) throws IOException {
    Files.write(Paths.get("tmp/" + i), values);
  }

  private static void createFiles(int fileNum) throws IOException {
    for (int i = 0; i < fileNum; i++) {
      createFile(i, createRandomFile());
    }
  }
```

then I tried use to read files and put words into frequency map,and here multiple threads are used

```java

  private static void readAndPutTo(Path path) throws IOException {

    List<String> lines = Files.readAllLines(path);
    for (String line : lines) {
      String[] words = line.split("\\s+");
      for (String word : words) {
        frenquncyMap.put(word, frenquncyMap.getOrDefault(word, 0) + 1);
      }
    }
  }
public static void main(args[]){
ExecutorService es = Executors.newFixedThreadPool(30);
    System.out.println(Files.list(Paths.get("tmp")).count());
    Files.list(Paths.get("tmp")).forEach(
        path -> {
          count.getAndIncrement();
          try {
            readAndPutTo(path);
          } catch (IOException e) {
            e.printStackTrace();
          }
        }
    );
    System.out.println("completed tasks: "+count);
    long end = System.currentTimeMillis();
    System.out.println(end - start);
    es.shutdown();
    System.out.println(es.awaitTermination(120, TimeUnit.SECONDS);
    System.out.println(System.currentTimeMillis() - start);
}
```

Use shutdown() to make sure every tasks are completed, and print the task count to check if all tasks had be invoked.

At last use stream api to list top 100 work frequency.

```java
    List result = frenquncyMap.entrySet().stream()
        .sorted(Map.Entry.comparingByValue())
        .limit(100).collect(Collectors.toList());
    System.out.println(result);
    System.out.println(System.currentTimeMillis() - start);

    Files.delete(Paths.get("tmp/"));
    Files.createDirectories(Paths.get("tmp/"));

```

That's it, let's run and see what happened:

```

```

Later I willl jump into JDK, to understand what the algorithm used in JDK. 