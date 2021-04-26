---
title: 学习ansible module-1
date: 2018-09-13 23:31:21
tags: [ansible,ci-cd]
---

写一个Ansbile Module实际上非常容易，我从看
```https://github.com/SeleniumHQ/ansible-selenium.git``` 这个源码的方式大概可以了解Ansible的一个简单的
插件.

下面分几个内容来看：

- 插件运行代码
- 插件的meta的数据

## Ansible 插件代码

- 首先Ansible 插件的入口函数为main函数

所以先定义一个main函数，以及main函数的运行

```python
def main():
  pass

main()

```

- 实现main函数

主要步骤是：

- module定义，Ansible的module，定义这个AnsibleModule的argument_spec,这个里面用来声明这个插件使用的参数
- module.params，ansible的输入为task的yml文件，这里面定义的内容都会传递到这个params中
- 然后根据不同的state的值去调用不同的任务，所有不同的任务的参数都是module，module用来传递了运行时的上下文
- 实现不同state对应的任务
- 基本上就结束了一个Ansible插件了

```python
    module = AnsibleModule(
        argument_spec=dict(
            role=dict(choices=['standalone', 'hub', 'node'], default='standalone'),
            state=dict(choices=['running', 'stopped', 'restarted'], default='running'),
            version=dict(default='2.53.0'),
            path=dict(default='.'),
            force=dict(default=False, type='bool'),
            args=dict(required=False, default=''),
            java=dict(required=False, default='/usr/bin/java'),
            logfile=dict(required=False, default='./selenium.log'),
            javaargs=dict(required=False, default=[], type='list'),
        ),

        supports_check_mode=False,

        mutually_exclusive=[]
    )

    state = module.params['state']
    role = module.params['role']

    if state == 'running':
        (changed, pid) = start(module)
        finish(module, msg='%s is running' % role, changed=changed, pid=pid)
    elif state == 'stopped':
        changed = stop(module)
        finish(module, msg='%s is stopped' % role, changed=changed)
    elif state == 'restarted':
        (changed, pid) = restart(module)
        finish(module, msg='%s has restarted' % role, changed=changed, pid=pid)
```

start 任务的一个例子：

```python
def start(module):
    """
    Start the Selenium standalone
    :param module:
    :return:
    """

    _, jar_file = download(module)

    changed = False
    role = module.params['role']
    if role != 'standalone':
      role = "-role %s" % role
    else: 
      role = ''

    if not is_running(module): # in another implementation
        changed = True
        args = ''
        java_args = ''
        if module.params['args']:
            for (k, v) in module.params['args'].iteritems():
                args += '-%s=%s ' % (k, v)

        if module.params['javaargs']:
            for arg in module.params['javaargs']:
                java_args += '-%s ' % arg

        java_executable = os.path.abspath(os.path.expandvars(module.params['java']))
        log_file = os.path.abspath(os.path.expandvars(module.params['logfile']))

        cmd = "%s %s -jar %s %s %s >> %s 2>&1 &" % (java_executable,
                                                          java_args,
                                                          jar_file,
                                                          role,
                                                          args,
                                                          log_file)

        os.setsid()

        #print cmd
        rc = os.system(cmd)

        if rc != 0:
            abort(module, 'Running the %s role returned code %s !' % (role, rc))

    pid = get_pid(module)
    if pid:
        return changed, pid
    else:
        abort(module, 'Couldnt fetch the pid of the running %s ! It may have ended abruptly.' % module.params['role'])

```

## Meta 插件的meta的数据

meta信息一般存放在meta目录中，具体写的方式参考源码:
```https://github.com/SeleniumHQ/ansible-selenium.git```

## Ansible MindMap

![img](/images/Ansible.png)