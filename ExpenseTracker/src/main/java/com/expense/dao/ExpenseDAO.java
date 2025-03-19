package com.expense.dao;

import com.expense.model.Expense;
import com.expense.model.User;
import com.expense.model.Category;
import com.expense.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.query.Query;
import java.util.List;

public class ExpenseDAO {

    // Add a new expense
    public void addExpense(Expense expense) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            session.beginTransaction();
            session.save(expense);
            session.getTransaction().commit();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Update an existing expense
    public void updateExpense(Expense expense) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            session.beginTransaction();
            session.update(expense);
            session.getTransaction().commit();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Delete an expense by ID
    public void deleteExpense(int expenseId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            session.beginTransaction();
            Expense expense = session.get(Expense.class, expenseId);
            if (expense != null) {
                session.delete(expense);
            }
            session.getTransaction().commit();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Get an expense by ID
    public Expense getExpenseById(int expenseId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Expense.class, expenseId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // Get all expenses for a user
    public List<Expense> getExpensesByUser(User user) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM Expense WHERE user = :user";
            Query<Expense> query = session.createQuery(hql, Expense.class);
            query.setParameter("user", user);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // Get all expenses for a user with pagination, filtering, and sorting
    public List<Expense> getFilteredAndSortedExpenses(int userId, String filter, String sort, int page, int pageSize) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM Expense WHERE user.userId = :userId";

            if (filter != null && !filter.isEmpty()) {
                hql += " AND category = :filter";
            }

            if (sort != null && !sort.isEmpty()) {
                hql += " ORDER BY " + sort;
            }

            Query<Expense> query = session.createQuery(hql, Expense.class);
            query.setParameter("userId", userId);

            if (filter != null && !filter.isEmpty()) {
                query.setParameter("filter", Category.valueOf(filter));
            }

            query.setFirstResult((page - 1) * pageSize);
            query.setMaxResults(pageSize);

            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // Get the total number of expenses for a user (for pagination)
    public int getTotalExpenseCount(int userId, String filter) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT COUNT(*) FROM Expense WHERE user.userId = :userId";

            if (filter != null && !filter.isEmpty()) {
                hql += " AND category = :filter";
            }

            Query<Long> query = session.createQuery(hql, Long.class);
            query.setParameter("userId", userId);

            if (filter != null && !filter.isEmpty()) {
                query.setParameter("filter", Category.valueOf(filter));
            }

            return query.uniqueResult().intValue();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
    
 // Get total expenses for a specific category for a user
    public double getTotalExpensesByCategory(int userId, String category) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT SUM(amount) FROM Expense WHERE user.userId = :userId AND category = :category";
            Query<Double> query = session.createQuery(hql, Double.class);
            query.setParameter("userId", userId);
            query.setParameter("category", category);
            Double totalExpenses = query.uniqueResult();
            return totalExpenses != null ? totalExpenses : 0.0;
        } catch (Exception e) {
            e.printStackTrace();
            return 0.0;
        }
    }
}