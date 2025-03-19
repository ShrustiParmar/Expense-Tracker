-- Create database
CREATE DATABASE IF NOT EXISTS expense_tracker;
USE expense_tracker;
 
-- Users Table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    username VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL 
);
 
-- Expenses Table
CREATE TABLE expenses (
    expense_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    category ENUM('Food', 'Transport', 'Entertainment', 'Others') NOT NULL,
    expense_date DATE NOT NULL,
    notes TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);
 
-- Income Table
CREATE TABLE income (
    income_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    source VARCHAR(255) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    income_date DATE NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);
 
-- Budgets Table
CREATE TABLE budgets (
    budget_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    category ENUM('Food', 'Transport', 'Entertainment', 'Others') NOT NULL,
    monthly_budget DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);
 
-- Insert dummy users
INSERT INTO users (name, username, password) 
VALUES 
('Alice Johnson', 'admin', 'admin'),
('Bob Smith', 'admin1', 'admin1');
 
-- Insert dummy expenses
INSERT INTO expenses (user_id, amount, category, expense_date, notes) 
VALUES 
(1, 25.50, 'Food', '2025-03-10', 'Lunch at a restaurant'),
(2, 10.00, 'Transport', '2025-03-09', 'Bus fare');
 
-- Insert dummy income
INSERT INTO income (user_id, source, amount, income_date) 
VALUES 
(1, 'Salary', 3000.00, '2025-03-01'),
(2, 'Freelance', 1500.00, '2025-03-05');
 
-- Insert dummy budgets
INSERT INTO budgets (user_id, category, monthly_budget) 
VALUES 
(1, 'Food', 500.00),
(2, 'Transport', 200.00);