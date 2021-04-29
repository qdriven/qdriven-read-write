# YUML Syntax

- comments and directives
- class diagram


## Comments and Directives

- type: //{type:class}
- direction: // {direction:leftToRight}
- generate: // {generate:true}

## Class diagram

cheetsheet for class diagram

```sh
Class         [Customer]
Directional   [Customer]->[Order]
Bidirectional [Customer]<->[Order]
Aggregation   [Customer]+-[Order] or [Customer]<>-[Order]
Composition   [Customer]++-[Order]
Inheritance   [Customer]^[Cool Customer], [Customer]^[Uncool Customer]
Dependencies  [Customer]uses-.->[PaymentStrategy]
Cardinality   [Customer]<1-1..2>[Address]
Labels        [Person]customer-billingAddress[Address]
Notes         [Address]-[note: Value Object]
Full Class    [Customer|Forename;Surname;Email|Save()]
Color splash  [Customer{bg:orange}]<>1->*[Order{bg:green}]

```

## Association classes

```sh
[Invoice]<*-*>[Products][Invoice Item]
```

## Use-cases diagram

```sh
Use Case           (Login)
Actor              [Customer]
<<Extend>>         (Login)<(Forgot Password)
<<Include>>        (Register)>(Confirm Email)
Actor Inheritance  [Admin]^[User]
Note	           [Admin]-(note: Most privilidged user)
```

## Activity diagram

```sh
Start	           (start)
End                (end)
Activity           (Find Products)
Flow	           (start)->(Find Products)
Multiple Assoc.    (start)->(Find Products)->(end)
Decisions          (start)-><d1>
Decisions w/Label  (start)-><d1>logged in->(Show Dashboard)   and   <d1>not logged in->(Show Login Page)
Parallel           (Action 1)->|a|   and   (Action 2)->|a|

```

## State diagram

```sh
Start	         (start)
End              (end)
Activity         (Find Products)
Flow	         (start)->(Find Products)
Multiple Assoc.  (start)->(Find Products)->(end)
Complex case     (Simulator running)[Pause]->(Simulator paused|do/wait)[Unpause]->(Simulator running)
Note             (state)-(note: a note here)
```

## Deployment diagram

```sh
Node           [node1]
Association    [node1]-[node2]
Labeled Assoc. [node1]label-[node2]
Note           [node1]-[note: a note here]
```

## Sequence diagram

```sh
Object       [Patron]
Message      [Patron]order food>[Waiter]
Response     [Waiter]serve wine.>[Patron]
Note         [Actor]-[note: a note message]
Asynchronous [Patron]order food>>[Waiter]
```

## Package diagram

```sh
Package        [package1]
Association    [package1]->[package2]
Labeled assoc  [package1]label->[package2]
Note           [package1]-[note: a note here]

````

## Others

- Color codes: form #RRGGBB, X11 color coding
- checkout [yuml.me](http://yuml.me)

## Tools

[yuml-diagram](https://github.com/jaime-olivares/yuml-diagram)

```sh
npm install yuml-diagram
```
