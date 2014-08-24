-- Таблица пользоватлей (для админки)
create table public.users (
  id	serial,	-- id пользователя
  login	text,	-- логин пользователя
  pass	text,	-- пароль пользователя
  constraint pk_users_id primary key (id),
  constraint uk_users_login unique (login)
);

-- Таблица новостей
create table public.news (
  id		serial,	-- id новости
  title		text,	-- заголовок
  lead		text,	-- краткое содержание
  body		text,	-- текст новости
  updated	timestamp default now(),	-- дата последнего изменения
  is_ready	bool default false,
  constraint pk_news_id primary key (id)
);

-- Таблица тегов
create table public.tags (
  id	serial,	-- id тега
  name	text,	-- тег
  constraint pk_tags_id primary key (id),
  constraint uk_tags_name unique (name)
);

-- Таблица связей новости <-> теги
create table public.news_tags (
  id_news	int,	-- id новости
  id_tag	int,	-- id тега
  constraint pk_news_tags_ids primary key (id_news, id_tag),
  constraint fk_news_tags_id_new foreign key (id_news)
    references public.news (id) on update cascade on delete cascade,
  constraint fk_news_tags_id_tag foreign key (id_tag)
    references public.tags (id) on update cascade on delete cascade
);

-- Заполняем таблицу пользоватлей
insert into public.users
(login, pass) values
('admin', encode(digest('1', 'sha1'), 'hex'));

-- Заполняем таблицу новостей
insert into public.news
(title, lead, body, is_ready) values
('Заголовок 1', 'Новость 1', 'Новость о "Новости 1"', true),
('Заголовок 2', 'Новость 2', 'Новость о "Новости 2"', default),
('Заголовок 3', 'Новость 3', 'Новость о "Новости 3"', true),
('Заголовок 4', 'Новость 4', 'Новость о "Новости 4"', true);

-- Заполняем таблицу тегов
insert into public.tags
(name) values
('Тег1'),
('Тег2'),
('Тег3'),
('Тег4'),
('Тег5'),
('Тег6');

-- Заполняем таблицу связей
insert into public.news_tags
(id_news, id_tag) values
(1, 1),
(1, 3),
(1, 5),
(2, 2),
(2, 4),
(2, 6),
(3, 1),
(3, 2),
(3, 3),
(3, 4),
(4, 5),
(4, 6);
