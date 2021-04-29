# Quality Indicators

The question is that how to measure code quality? It is a question that very hard to answer even
a testing or quality veteran.

## Something indicators here-Software Metrics

- Code coverage
- Cyclomatic Complexity
- abstraction interpretation/deep flow analysis tools
- Compiler Warning
- Codeing Standards
- Code duplication
- Fan out- dependency Indicators
- Dead Code

## Software Quality Indicators 

- The number of defects found after release
- The severity of these defects
- The effort needed to solve these defects

## Software Quality Attributes

- Functional suitablitity
- Reliabiity
- Performance effiency
- Operability
- Secuiry
- Compatibility
- Maintainablitiy
- Transferability

## Software Metrics

- Compiler Warning
score = min(max(140 - 20 * cyclomatic_complexity, 0), 100)
score = max(100 - 50 * log10(101 – compliance_factor(compiler_warnings)), 0)
score = compliance_factor(coding_standard_violations)
score = min(-30 * log10(code_duplication) + 60, 100)
score = min(max(120 - (8 * internal fan_out + 2 * external fan_out), 0), 100)
score = max((100 - 2 * dead_code), 0)
```score = max(100 - 50 * log10(101 – compliance_factor(compiler_warnings)), 0)``
