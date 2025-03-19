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
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.save(budget);
            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
            return false;
        }
    }

    // Get all budgets for a user
    public List<Budget> getBudgetsByUser(User user) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM Budget WHERE user = :user";
            return session.createQuery(hql, Budget.class)
                         .setParameter("user", user)
                         .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}