-- Sample PostgreSQL query (just try it out)
CREATE TABLE friendship(user1_id INT, user2_id INT);
INSERT INTO friendship VALUES(1,2);
INSERT INTO friendship VALUES(1,3);
INSERT INTO friendship VALUES(2,3);
INSERT INTO friendship VALUES(1,4);
INSERT INTO friendship VALUES(2,4);
INSERT INTO friendship VALUES(1,5);
INSERT INTO friendship VALUES(2,5);
INSERT INTO friendship VALUES(1,7);
INSERT INTO friendship VALUES(3,7);
INSERT INTO friendship VALUES(1,6);
INSERT INTO friendship VALUES(2,6);
INSERT INTO friendship VALUES(3,6);
SELECT * FROM friendship;

