# Gradle 加速

平常使用Gradle，会发现网络下载速度非常慢，已经影响到使用效率了。不过最后发现可以通过修改镜像源的方式处理

## 修改镜像源

- 在本地项目中build.gradle文件中修改:

```groovy
repositories {
    maven {
        url "http://maven.aliyun.com/nexus/content/groups/public"
    }
}
```

- 全局修改

*** {HOME}/.gradle/init.gradle***文件中修改，如果没有这个文件，自己添加一个.

```groovy
allprojects {
    repositories {
        maven {
            url "http://maven.aliyun.com/nexus/content/groups/public"
        }
    }
}
```

修改完之后，gradle build的速度就明天提升了.