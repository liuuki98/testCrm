package com.liuuki.crm.workbench.dao;

import com.liuuki.crm.workbench.domain.Customer;

public interface CustomerDao {
    Customer getCustomerByName(String company);

    int saveCustomer(Customer customer);
}
