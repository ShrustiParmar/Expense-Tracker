package com.expense.dao;

import org.hibernate.Session;
import org.hibernate.query.Query;
import com.expense.model.Income;
import com.expense.model.User;
import com.expense.util.HibernateUtil;
import java.util.List;
import org.hibernate.Transaction;

public class IncomeDAO {

	public List<Income> getIncomesByUser(User user) {
		try (Session session = HibernateUtil.getSessionFactory().openSession()) {
			String hql = "FROM Income WHERE user = :user";
			Query<Income> query = session.createQuery(hql, Income.class);
			query.setParameter("user", user);
			return query.list();
		}
	}

	public void addIncome(Income income) {
		Transaction transaction = null;
		try (Session session = HibernateUtil.getSessionFactory().openSession()) {
			transaction = session.beginTransaction();
			session.save(income);
			transaction.commit();
		} catch (Exception e) {
			if (transaction != null)
				transaction.rollback();
			e.printStackTrace();
		}
	}

	public void updateIncome(Income income) {
		Transaction transaction = null;
		try (Session session = HibernateUtil.getSessionFactory().openSession()) {
			transaction = session.beginTransaction();
			session.update(income);
			transaction.commit();
		} catch (Exception e) {
			if (transaction != null)
				transaction.rollback();
			e.printStackTrace();
		}
	}

	public void deleteIncome(int incomeId) {
		Transaction transaction = null;
		try (Session session = HibernateUtil.getSessionFactory().openSession()) {
			Income income = session.get(Income.class, incomeId);
			if (income != null) {
				transaction = session.beginTransaction();
				System.out.println("Deleting income ID: " + incomeId);
				session.delete(income);
				transaction.commit();
				System.out.println("Income deleted from database.");
			} else {
				System.out.println("Income not found with ID: " + incomeId);
			}
		} catch (Exception e) {
			if (transaction != null)
				transaction.rollback();
			e.printStackTrace();
		}
	}

	public Income getIncomeById(int incomeId) {
		try (Session session = HibernateUtil.getSessionFactory().openSession()) {
			return session.get(Income.class, incomeId);
		}
	}

	public List<Income> getAllIncomesByUserId(int userId) {
		try (Session session = HibernateUtil.getSessionFactory().openSession()) {
			Query<Income> query = session.createQuery("FROM Income WHERE user.id = :userId", Income.class);
			query.setParameter("userId", userId);
			return query.list();
		}
	}

	public List<Income> getFilteredAndSortedIncomes(int userId, String filter, String sort, int page, int pageSize) {
		try (Session session = HibernateUtil.getSessionFactory().openSession()) {

			StringBuilder hql = new StringBuilder("FROM Income i WHERE i.user.id = :userId");

			// Add filter condition if provided
			if (filter != null && !filter.isEmpty()) {
				// Try filtering by source (string match)
				hql.append(" AND i.source LIKE :filter");

				// If the filter looks like a date (yyyy-mm-dd format), filter by date
				try {
					// If the filter is a valid date, it will be parsed here
					java.sql.Date parsedDate = java.sql.Date.valueOf(filter);
					hql.append(" OR i.incomeDate = :dateFilter");
				} catch (IllegalArgumentException e) {
					// Ignore the exception if the filter is not a valid date
				}
			}

			// Add sorting
			if (sort != null && !sort.isEmpty()) {
				hql.append(" ORDER BY i.").append(sort);
			} else {
				hql.append(" ORDER BY i.incomeDate DESC");
			}

			// Create the query
			Query<Income> query = session.createQuery(hql.toString(), Income.class);
			query.setParameter("userId", userId);

			// Set the filter parameter for source filtering
			if (filter != null && !filter.isEmpty()) {
				query.setParameter("filter", "%" + filter + "%");

				// If the filter was a valid date, set the date filter
				try {
					java.sql.Date parsedDate = java.sql.Date.valueOf(filter);
					query.setParameter("dateFilter", parsedDate);
				} catch (IllegalArgumentException e) {
					// Ignore the exception if the filter is not a valid date
				}
			}
			// Set filter parameter
			if (filter != null && !filter.isEmpty()) {
				String filterPattern = "%" + filter + "%";
				query.setParameter("filter", filterPattern);
			}

			// Set pagination parameters
			query.setFirstResult((page - 1) * pageSize);
			query.setMaxResults(pageSize);

			// Execute the query
			List<Income> incomes = query.list();
			session.close();

			return incomes;
		}
	}

	// Method to get total income count with an optional filter
	public int getTotalIncomeCount(int userId, String filter) {
		Session session = HibernateUtil.getSessionFactory().openSession();
		try {
			StringBuilder hql = new StringBuilder("SELECT COUNT(i) FROM Income i WHERE i.user.id = :userId");

			// Add filter condition if provided
			if (filter != null && !filter.isEmpty()) {
				// Try filtering by source (string match)
				hql.append(" AND i.source LIKE :filter");

				// If the filter looks like a date (yyyy-mm-dd format), filter by date
				try {
					// If the filter is a valid date, it will be parsed here
					java.sql.Date parsedDate = java.sql.Date.valueOf(filter);
					hql.append(" OR i.incomeDate = :dateFilter");
				} catch (IllegalArgumentException e) {
					// Ignore the exception if the filter is not a valid date
				}
			}

			// Create the query
			Query<Long> query = session.createQuery(hql.toString(), Long.class);
			query.setParameter("userId", userId);

			// Set the filter parameter for source filtering
			if (filter != null && !filter.isEmpty()) {
				query.setParameter("filter", "%" + filter + "%");

				// If the filter was a valid date, set the date filter
				try {
					java.sql.Date parsedDate = java.sql.Date.valueOf(filter);
					query.setParameter("dateFilter", parsedDate);
				} catch (IllegalArgumentException e) {
					// Ignore the exception if the filter is not a valid date
				}
			}

			// Execute the query and get the count
			Long count = query.uniqueResult();

			// Return the count as an int
			return count != null ? count.intValue() : 0;
		} finally {
			session.close();
		}
	}

}
