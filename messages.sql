CREATE TABLE messages (
  id INTEGER PRIMARY KEY,
  message VARCHAR(255) NOT NULL,
  user_id INTEGER,

  FOREIGN KEY(user_id) REFERENCES user(id)
);

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  place_id INTEGER,

  FOREIGN KEY(place_id) REFERENCES user(id)
);

CREATE TABLE places (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

INSERT INTO
  places (id, name)
VALUES
  (1, "Empty Field"), (2, "Desert Island");

INSERT INTO
  users (id, fname, lname, place_id)
VALUES
  (1, "Eliot", "Bradshaw", 1),
  (2, "Kat", "Bowles", 2),
  (3, "Alan", "Partridge", 2),
  (4, "Salvador", "Dali", NULL);

INSERT INTO
  messages (id, message, user_id)
VALUES
  (1, "What's up everybody?", 1),
  (2, "Just relaxing over here.", 2),
  (3, "I am relaxing also, aha.", 3),
  (4, "So surreal, I'm also here.", 3),
  (5, "Interesting.", 1);
