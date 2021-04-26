---
title: Defensive Programming
date: 2019-02-20 23:58:45
tags: ["anti-bug","java"]
---

# Defensive Programming - reuse the validation

What does Defensive Programming mean? Let's look at some sampels:

```java
public class Report {
    public void export(File file) {
        if (file == null) {
            throw new IllegalArgumentException(
                    "File is NULL; can't export."
            );
        }
        if (file.exists()) {
            throw new IllegalArgumentException(
                    "File already exists."
            );
        }
        // Export the report to the file
    }
}
```

In this case, there are several validation for the input paramter to make sure the input is in a right manner. It is the sense of defensive programing. Be sure, don't grant the input parameter. 

But actually it is quite boilet code for input parameter validation. 

For example, if we define a Report Interface:

```java
public interface Report {
  void export(File file);
}
```

And we have several different Reports to implement this interface, do we need to do the validate in every implementation? The answer is it depends, we can implement a DefaultReport, to decorate different report as example.

```java

public class DefaultReport implements Report {
    @Override
    public void export(File file) {
        if (file == null) {
            throw new IllegalArgumentException(
                    "File is NULL; can't export."
            );
        }
        if (file.exists()) {
            throw new IllegalArgumentException(
                    "File already exists."
            );
        }
        // Export the report to the file
    }
}

```

```java

public class NoWriteOverReport implements Report {
    private final Report origin;

    NoWriteOverReport(Report rep) {
        this.origin = rep;
    }

    @Override
    public void export(File file) {
        if (file.exists()) {
            throw new IllegalArgumentException(
                    "File already exists."
            );
        }
        this.origin.export(file);
    }

    public static void main(String[] args) {
        Report report = new NoWriteOverReport(
                new DefaultReport()
        );
        File file = new File(".");
        report.export(file);
    }
}

```

So we can reuse the default report valitor now. 