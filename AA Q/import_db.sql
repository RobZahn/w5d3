DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;
PRAGMA foreign_keys = ON;

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL
);

CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    body TEXT NOT NULL,
    associated_author_id INTEGER NOT NULL,

    FOREIGN KEY (associated_author_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    follower_id INTEGER NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (follower_id) REFERENCES users(id)
);

CREATE TABLE replies (
    id INTEGER PRIMARY KEY NOT NULL,
    question_id INTEGER NOT NULL,
    writer INTEGER NOT NULL,
    body TEXT NOT NULL,
    parent_reply INTEGER,

    FOREIGN KEY(question_id) REFERENCES questions(id),
    FOREIGN KEY (writer) REFERENCES users (id),
    FOREIGN KEY (parent_reply) REFERENCES replies(id)
);

CREATE TABLE question_likes (
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);
--------------------------------------------------------------------------------
INSERT INTO
    users(full_name)
VALUES
    ('Test User'),
    ('follower');
----------
INSERT INTO
  questions(title, body, associated_author_id)
VALUES
    ('Test Question', 'This is a test', (SELECT id FROM users WHERE full_name = 'Test User'));
----------
INSERT INTO
  question_follows(question_id, follower_id)
VALUES
    ((SELECT id FROM questions WHERE title = 'Test Question'),
    (SELECT id FROM users WHERE full_name = 'follower'));
----------
INSERT INTO 
    replies(question_id, writer, body)
VALUES

    ((SELECT id FROM questions WHERE title = 'Test Question'),
     (SELECT id FROM users WHERE full_name = 'Test User'), 
     'This is my question, can anybody answer?');
-----------
INSERT INTO 
    replies
    (question_id, writer, body, parent_reply)
VALUES
    ((SELECT id FROM questions WHERE title = 'Test Question'),
    (SELECT id FROM users WHERE full_name = 'follower'),
    'I have an answer!',
    (SELECT id From replies WHERE replies.body = 'This is my question, can anybody answer?'));
----------
INSERT INTO
    question_likes(question_id, user_id)
VALUES
    ((SELECT id FROM questions WHERE title = 'Test Question'),
    (SELECT id FROM users WHERE full_name = 'follower'));