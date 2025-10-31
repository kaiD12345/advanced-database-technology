Distributed and Parallel Database Project

This project demonstrates the design, implementation, and performance testing of a distributed database system using Oracle SQL Developer. It covers schema fragmentation, remote access via database links, parallel query execution, and distributed transaction control.

1. Distributed Schema Design and Fragmentation
The database was split into two branches (Branch_A and Branch_B) using horizontal fragmentation based on region. Each branch stores its own products, deliveries, invoices, and payments.

2. Creating and Using Database Links
Database links were created to enable remote access between branches. These links allow distributed joins and queries across nodes.

3. Parallel Query Execution
Parallelism was enabled to speed up large queries. Performance was compared between serial and parallel execution using EXPLAIN PLAN and AUTOTRACE.

4. Two-Phase Commit Simulation (2PC)
A PL/SQL block was used to simulate a transaction that spans both branches. The 2PC protocol ensures that either both sides commit or both roll back, maintaining consistency.

5. Distributed Rollback and Recovery
An "in-doubt" transaction was simulated by interrupting a distributed commit. Recovery steps were demonstrated using Oracle’s pending transaction views and rollback commands.

6. Distributed Concurrency Control
Locking mechanisms were tested to prevent conflicts during concurrent updates. Duplicate rows were deleted and updates were synchronized across branches.

7. Parallel Data Loading / ETL Simulation
Parallel DML was used to simulate an ETL process. This improved performance when inserting and transforming large datasets, especially in the product table.

8. Three-Tier Client-Server Architecture
The system was modeled using three layers:
- Presentation: Web dashboard and forms
- Application: PL/SQL logic and triggers
- Database: BranchDB_A and BranchDB_B with links

9. Distributed Query Optimization
Oracle’s optimizer strategies were explored, including predicate pushdown, join site selection, and parallel remote access. These techniques help reduce data movement and improve query speed.

10. Performance Benchmark and Report
A complex query was run in three modes: centralized, parallel, and distributed. AUTOTRACE showed that parallel execution was fastest, while distributed mode had higher I/O and latency due to remote access.

Conclusion:
Centralized and parallel methods are efficient for large datasets. Distributed queries offer flexibility but require careful optimization to avoid performance issues. Techniques like filtering, hints, and materialized views help improve scalability.

Author: Uwanyirigira Claudine
Reg No: 224020280
Date: 30/10/2025


