-- SQLite는 연결할 때마다 외래 키 기능을 켜야 한다. (SQLite 전용 설정)
PRAGMA foreign_keys = ON;

-- 다시 실행할 수 있도록 자식 테이블부터 삭제한다.
DROP TABLE IF EXISTS review;
DROP TABLE IF EXISTS movie;
DROP TABLE IF EXISTS member;
DROP TABLE IF EXISTS genre;

CREATE TABLE genre (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE member (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    joined_at TEXT NOT NULL
);

CREATE TABLE movie (
    id INTEGER PRIMARY KEY,
    genre_id INTEGER NOT NULL,
    title TEXT NOT NULL UNIQUE,
    release_year INTEGER NOT NULL,
    running_time INTEGER NOT NULL,
    FOREIGN KEY (genre_id) REFERENCES genre(id)
);

CREATE TABLE review (
    id INTEGER PRIMARY KEY,
    member_id INTEGER NOT NULL,
    movie_id INTEGER NOT NULL,
    rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT NOT NULL,
    created_at TEXT NOT NULL,
    FOREIGN KEY (member_id) REFERENCES member(id),
    FOREIGN KEY (movie_id) REFERENCES movie(id)
);
