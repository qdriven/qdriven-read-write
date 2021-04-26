---
title: jLoan Calculation 
date: 2018-08-13 22:35:32
tags:
    - tips
    - python
---

## Loan Calculation Example

- Loan Rule Defintion
- Installment Calculation
- Overdue Calculation
- IRR Calculation

## Loan Rule Definition

![img](/images/loan/loan_definition.jpg)

## Installments Calculation

- repayment-Principal: ROUND(10000/3,2)
- repayment-interest: ROUND(10000*2%,2)

![img](/images/loan/normal_installment.jpg)

## Advanced Repayment calculation

Overall Payment = Current Term Repayment + Remain Principal+ default penalty(10000*1%)

![img](/images/loan/advanced_repayment.jpg)

## Overdue Repayment calculation

For example: 

Last Term: 4-1 is the repayment day, but actually repayment is occurred in 4-10, then it is default. And the default fee is over your imagination.

- Term1 Default Penalty: ROUND(3333.33*(0.02/30)*1.5*(60+9),2)
- Term2 Default Penalty: ROUND(3333.33*(0.02/30)*1.5*(30+9),2)
- Term3 Default Penalty: ROUND(3333.34*(0.02/30)*1.5*(0+9),2)

![img](/images/loan/overdue_repayment.jpg)

Don't be default, man!!

## IRR Calculation

![img](/images/loan/IRR.jpg)

