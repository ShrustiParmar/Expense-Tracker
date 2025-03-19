package com.expense.dao;

import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;
import org.mindrot.jbcrypt.BCrypt;

import com.expense.model.User;
import com.expense.util.HibernateUtil;

public class UserDAO {
	
	 public boolean registerUser(User user) {
	        Transaction transaction = null;
	        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
	            transaction = session.beginTransaction();
	            session.save(user);
	            transaction.commit();
	            return true;
	        } catch (Exception e) {
	            if (transaction != null && transaction.isActive()) {
	                transaction.rollback();
	            }
	            e.printStackTrace();
	            return false;
	        }
	    }
	 
	 public User validateUser(String email, String password) {
		    try (Session session = HibernateUtil.getSessionFactory().openSession()) {
		        Query<User> query = session.createQuery("FROM User WHERE username = :email", User.class);
		        query.setParameter("email", email);

		        User user = query.uniqueResult();

		        if (user != null && BCrypt.checkpw(password, user.getPassword())) {
		            return user; // Successful login
		        }
		    } catch (Exception e) {
		        e.printStackTrace();
		    }
		    return null; // Login failed
		}
}
