import ballerina/io;

configurable string verifierToken = ?;
configurable string[] realmIds = ?;

ListenerConfig listenerConfig = {
    verificationToken: verifierToken,
    realmIds: realmIds
};
listener Listener quickBooksListener = new (listenerConfig);

service AccountService on quickBooksListener {
    remote function onAccountCreate(QuickBookEvent event) returns error? {
        io:println("Account created : ", event);
    }
    remote function onAccountUpdate(QuickBookEvent event) returns error? {
        io:println("Account updated : ", event);
    }
    remote function onAccountDelete(QuickBookEvent event) returns error? {
        io:println("Account deleted : ", event);
    }
    remote function onAccountMerge(QuickBookEvent event) returns error? {
        io:println("Account merged : ", event);
    }
}

service BillService on quickBooksListener {
    remote function onBillCreate(QuickBookEvent event) returns error? {
        io:println("Bill created : ", event);
    }
    remote function onBillUpdate(QuickBookEvent event) returns error? {
        io:println("Bill updated : ", event);
    }
    remote function onBillDelete(QuickBookEvent event) returns error? {
        io:println("Bill deleted : ", event);
    }
}

service BillPaymentService on quickBooksListener {
    remote function onBillpaymentCreate(QuickBookEvent event) returns error? {
        io:println("Billpayment created : ", event);
    }
    remote function onBillpaymentUpdate(QuickBookEvent event) returns error? {
        io:println("Billpayment updated : ", event);
    }
    remote function onBillpaymentDelete(QuickBookEvent event) returns error? {
        io:println("Billpayment deleted : ", event);
    }
    remote function onBillpaymentVoid(QuickBookEvent event) returns error? {
        io:println("Billpayment voided : ", event);
    }
}

service BudgetService on quickBooksListener {
    remote function onBudgetCreate(QuickBookEvent event) returns error? {
        io:println("Budget created : ", event);
    }
    remote function onBudgetUpdate(QuickBookEvent event) returns error? {
        io:println("Budget updated : ", event);
    }
}

service ClassService on quickBooksListener {
    remote function onClassCreate(QuickBookEvent event) returns error? {
        io:println("Class created : ", event);
    }
    remote function onClassUpdate(QuickBookEvent event) returns error? {
        io:println("Class updated : ", event);
    }
    remote function onClassDelete(QuickBookEvent event) returns error? {
        io:println("Class deleted : ", event);
    }
}

service CreditMemoService on quickBooksListener {
    remote function onCreditmemoCreate(QuickBookEvent event) returns error? {
        io:println("Creditmemo created : ", event);
    }
    remote function onCreditmemoUpdate(QuickBookEvent event) returns error? {
        io:println("Creditmemo updated : ", event);
    }
    remote function onCreditmemoDelete(QuickBookEvent event) returns error? {
        io:println("Creditmemo deleted : ", event);
    }
    remote function onCreditmemoVoid(QuickBookEvent event) returns error? {
        io:println("Creditmemo voided : ", event);
    }
}

service CurrencyService on quickBooksListener {
    remote function onCurrencyCreate(QuickBookEvent event) returns error? {
        io:println("Currency created : ", event);
    }
    remote function onCurrencyUpdate(QuickBookEvent event) returns error? {
        io:println("Currency updated : ", event);
    }
}

service CustomerService on quickBooksListener {
    remote function onCustomerCreate(QuickBookEvent event) returns error? {
        io:println("Customer created : ", event);
    }
    remote function onCustomerUpdate(QuickBookEvent event) returns error? {
        io:println("Customer updated : ", event);
    }
    remote function onCustomerDelete(QuickBookEvent event) returns error? {
        io:println("Customer deleted : ", event);
    }
    remote function onCustomerMerge(QuickBookEvent event) returns error? {
        io:println("Customer merged : ", event);
    }
}

service DepartmentService on quickBooksListener {
    remote function onDepartmentCreate(QuickBookEvent event) returns error? {
        io:println("Department created : ", event);
    }
    remote function onDepartmentUpdate(QuickBookEvent event) returns error? {
        io:println("Department updated : ", event);
    }
    remote function onDepartmentMerge(QuickBookEvent event) returns error? {
        io:println("Department merged : ", event);
    }
}

service DepositService on quickBooksListener {
    remote function onDepositCreate(QuickBookEvent event) returns error? {
        io:println("Deposit created : ", event);
    }
    remote function onDepositUpdate(QuickBookEvent event) returns error? {
        io:println("Deposit updated : ", event);
    }
    remote function onDepositDelete(QuickBookEvent event) returns error? {
        io:println("Deposit deleted : ", event);
    }
}

service EmployeeService on quickBooksListener {
    remote function onEmployeeCreate(QuickBookEvent event) returns error? {
        io:println("Employee created : ", event);
    }
    remote function onEmployeeUpdate(QuickBookEvent event) returns error? {
        io:println("Employee updated : ", event);
    }
    remote function onEmployeeDelete(QuickBookEvent event) returns error? {
        io:println("Employee deleted : ", event);
    }
    remote function onEmployeeMerge(QuickBookEvent event) returns error? {
        io:println("Employee merged : ", event);
    }
}

service EstimateService on quickBooksListener {
    remote function onEstimateCreate(QuickBookEvent event) returns error? {
        io:println("Estimate created : ", event);
    }
    remote function onEstimateUpdate(QuickBookEvent event) returns error? {
        io:println("Estimate updated : ", event);
    }
    remote function onEstimateDelete(QuickBookEvent event) returns error? {
        io:println("Estimate deleted : ", event);
    }
}

service InvoiceService on quickBooksListener {
    remote function onInvoiceCreate(QuickBookEvent event) returns error? {
        io:println("Invoice created : ", event);
    }
    remote function onInvoiceUpdate(QuickBookEvent event) returns error? {
        io:println("Invoice updated : ", event);
    }
    remote function onInvoiceDelete(QuickBookEvent event) returns error? {
        io:println("Invoice deleted : ", event);
    }
    remote function onInvoiceVoid(QuickBookEvent event) returns error? {
        io:println("Invoice voided : ", event);
    }
}
