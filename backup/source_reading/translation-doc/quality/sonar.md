# SONAR

- installation
- components of SONAR
* Dashboard
* Components
* Violations Drilldown
* Time Machine: the component focuses on historical data about    Complexity, Coverage, and Rules compliance.
* Clouds: coverage and report
* Design: for example dependency issue
* Hotspots: collects and sorts total violations and measures
* Libraries

## Code Standard
Java Coding convention/
- Naming convention
- Class and variable declaration
- Statements: methods,loops and conditions
- Layout: indentation and white space

Sonar-Way-Findbug is recommended,Checkstyle
SeverityValue*TotalNumberOfViolation=ViolationValue

- Rules compliance Index
how to calculate?

- Variable,parameter and method name
  ^[a-z][a-zA-Z0-9]*$
- multiple variable declarations
- local home naming
- variable lengths: Long Variable and short Variable rules
- Naming, avoid field name matching the method name
- Naming ,suspicious equals method name
- standards rules
  * unused imports
  * unnecessary final modifier
  * unused modifier
  * magic number
  * Final class
  * Missing constructor
  * abstract class without any method
  * Code layout and indentation
- review codes
- Potential bugs violations
  * Dodgy Code rules
  * notifyAll instead of notify   
  * StringBuffer for String appends
  * constructor calls overridable method
  * close resource
  * return zero length array rather than null
  * method ignore return value
  * method does not release lock on all path
  * null pointer dereference
  * suspicious reference comparison
  * misplaced null check
  * impossible cast

  * grogram flow rules
    - do not throw exception in finally
    - finalize does not call super finalize
    - avoiding calling finalize
    - avoid catching NPE
    - Method ignores exceptional return value
    - Switch statement found where default cases is missing
    - missing break in switch
    - avoid catching throwable
- security rules
- The Cyclomatic Complexity metric
- Cohesion and coupling
- Afferent coupling  
- Efferent coupling
- Lack of Cohesion in Methods and the LCOM4 metric
