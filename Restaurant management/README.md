# Pizzeria Relational Database for Data Analysis

## Project Overview
This project demonstrates how to design and build a relational database using MySQL for a fictional pizzeria business. The database manages key business areas such as customer orders, stock control, and staff data. It showcases important SQL database skills, including normalization, establishing relationships, and running queries to generate insights, making it a great project for a data analyst portfolio.

This project is part of a series, aiming to create a complete back-end system for the business while preparing the foundation for building dashboards to visualize business performance.

## Table of Contents
1. [Project Objectives](#project-objectives)
2. [Technology Stack](#technology-stack)
3. [Database Design](#database-design)
4. [Key Features](#key-features)
5. [Conclusion](#conclusion)
6. [References and resources](#references-and-resources)

## Project Objectives
The main goals of this project are to:
- Build a normalized relational database for a pizzeria's back-end system.
- Log and store essential business data such as customer orders, stock levels, and staff schedules.
- Enable  SQL querying and data analysis to provide insights into business operations.
- Prepare the database to create dashboards that visualize business performance metrics.

## Technology Stack
- **MySQL**: Database management and SQL operations.
- **QuickDBD**: Tool for database diagramming and schema design.
- **CSV**: Format for importing initial data into the database.

## Database Design
The database is structured into three main components:

1. **Orders Data**:
   - **Tables**: Orders, Customers, Delivery Addresses, Items.
   - **Purpose**: Logs customer orders, delivery information, and purchased items.
   
2. **Stock Control**:
   - **Tables**: Ingredients, Recipes, Inventory.
   - **Purpose**: Tracks inventory stock levels, ingredients, and recipes for reordering management.
   
3. **Staff Data**:
   - **Tables**: Staff, Shifts, Rota.
   - **Purpose**: Logs staff working hours and shifts to calculate pizza production and delivery labor costs.

## Key Features
The database follows normalization principles to reduce redundancy and improve efficiency by organizing data into related tables.

## Conclusion
A restaurant sales store manager can utilize this SQL project to conduct detailed data analysis, facilitating informed decision-making and efficient management of the store’s operations as follows:

   - **Sales Analysis:** Identify the best-selling pizzas, assess revenue from different pizza sizes, and evaluate pricing strategies.
   - **Inventory Management:** Track the most common ingredients to be bought according to demand and reduce waste.
   - **Customer Preferences:** Track customer preferences over time.
   - **Operational Efficiency:** Assess peak hours and staff the store appropriately, ensuring operational efficiency and customer satisfaction.
   - **Marketing Insights:** Further analysis can be used to target marketing campaigns, like promotions on specific types of pizzas that are popular or on days when sales are typically lower.

## References and resources
1. [Inspiration](https://www.youtube.com/watch?v=MiAl2mQ718s&list=PLR0triVyTrBX7bTPY2Clm8YS82eyJYaVp)
2. [Database](https://www.kaggle.com/datasets/jaspearson/pizzeria-data-for-4-weeks/code)
3. [Documentation](https://datalemur.com/sql-tutorial/intro-to-sql)
