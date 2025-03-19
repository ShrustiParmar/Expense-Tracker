package com.expense.dao;

import com.expense.model.Budget;
import com.expense.model.User;
import com.expense.util.HibernateUtil;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;

public class BudgetDAO {

    // Add a new budget
    public boolean addBudget(Budget budget) {
        Transaction transaction = null;
        Session session = null;
        try {
            // Open a session
            session = HibernateUtil.getSessionFactory().openSession();

            // Begin a transaction
            transaction = session.beginTransaction();

            // Save the budget object
            session.save(budget);

            // Commit the transaction
            transaction.commit();

            return true;
        } catch (Exception e) {
            // Rollback the transaction in case of an exception
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            // Close the session
            if (session != null) {
                session.close();
            }
        }
    }

    // Get all budgets for a user
    public List<Budget> getBudgetsByUser(User user) {
        Session session = null;
        try {
            // Open a session
            session = HibernateUtil.getSessionFactory().openSession();

            // Create and execute the query
            String hql = "FROM Budget WHERE user = :user";
            return session.createQuery(hql, Budget.class)
                         .setParameter("user", user)
                         .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            // Close the session
            if (session != null) {
                session.close();
            }
        }
    }
}