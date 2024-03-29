-- Лабораторная работа №3, дисциплина "Базы данных", СПбГУАП, весенний семестр 2019

-- Включение форсирования ограничений ссылочной целостности
PRAGMA foreign_keys = ON;

-- Очистка схемы данных
-- DROP TABLE IF EXISTS Table1 ...
-- ваш код здесь!
DROP TABLE IF EXISTS ОценкаФильма;
DROP TABLE IF EXISTS ПолучениеНаградыФильм;
DROP TABLE IF EXISTS ПолучениеНаградыАктер;
DROP TABLE IF EXISTS НаградаФильм;
DROP TABLE IF EXISTS НаградаАктер;
DROP TABLE IF EXISTS ВидНаградыАктер;
DROP TABLE IF EXISTS ВидНаградыФильм;
DROP TABLE IF EXISTS ОценкаРецензии;
DROP TABLE IF EXISTS ФильмУактера;
DROP TABLE IF EXISTS Актер;
DROP TABLE IF EXISTS Рецензия;
DROP TABLE IF EXISTS Фильм;
DROP TABLE IF EXISTS Жанр;
DROP TABLE IF EXISTS Пользователь;
-- Создание схемы данных
-- CREATE TABLE Table1 ...
-- ваш код здесь!
CREATE TABLE Пользователь(
   Логин VARCHAR(20) PRIMARY KEY,
   Пол VARCHAR(1) NOT NULL,
   ДатаРегистрации DATE NOT NULL CHECK(ДатаРегистрации BETWEEN DATE('now','-15 years') and DATE('now')));
   
CREATE TABLE Фильм(
   НазваниеФильма VARCHAR(40),
   ДатаВыхода DATE,
   Режиссер VARCHAR(20) NOT NULL,
   Сценарист VARCHAR(20) NOT NULL,
   Сюжет LONGTEXT NOT NULL, 
   НазваниеЖанра VARCHAR(20) NOT NULL,
   PRIMARY KEY (НазваниеФильма,ДатаВыхода));
   
CREATE TABLE Жанр (
   НазваниеЖанра VARCHAR(20) PRIMARY KEY);  
   
CREATE TABLE Актер (
   idАктера INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
   Фамилия VARCHAR(30) NOT NULL,
   Имя VARCHAR(20) NOT NULL,
   Отчество VARCHAR(30),
   ДатаРождения DATE NOT NULL CHECK(ДатаРождения BETWEEN DATE('now','-119 years') and DATE('now')),
   ДатаСмерти DATE CHECK(ДатаСмерти>=ДатаРождения));
   
CREATE TABLE ВидНаградыАктер (
   НазваниеНаградыАктер VARCHAR(40) PRIMARY KEY);
   
CREATE TABLE ВидНаградыФильм (
   НазваниеНаградыФильм VARCHAR(40) PRIMARY KEY);
   
CREATE TABLE ОценкаФильма(
   Логин VARCHAT(20) REFERENCES Пользователь(Логин),
   НазваниеФильма VARCHAR(40),
   ДатаВыхода DATE,
   Балл INTEGER NOT NULL CHECK(Балл BETWEEN 1 AND 10),
   ДатаОценки DATE NOT NULL CHECK(ДатаОценки BETWEEN DATE('now','-15 years') and DATE('now')),
   FOREIGN KEY (НазваниеФильма,ДатаВыхода) REFERENCES Фильм(НазваниеФильма,ДатаВыхода),
   PRIMARY KEY (Логин,НазваниеФильма,ДатаВыхода));

CREATE TABLE НаградаФильм (
   НазваниеНаградыФильм VARCHAR(40) REFERENCES ВидНаградыФильм(НазваниеНаградыФильм),
   ВидНаградыФильм VARCHAT(20),
   PRIMARY KEY (НазваниеНаградыФильм,ВидНаградыФильм));
   
CREATE TABLE НаградаАктер (
   НазваниеНаградыАктер VARCHAR(40) REFERENCES ВидНаградыАктер(НазваниеНаградыАктер),
   ВидНаградыАктер VARCHAT(20),
   PRIMARY KEY (НазваниеНаградыАктер,ВидНаградыАктер));
   
CREATE TABLE ПолучениеНаградыФильм(
   Год DATE,
   НазваниеНаградыФильм VARCHAR(40),
   НазваниеФильма VARCHAR(40) NOT NULL,
   ДатаВыхода DATE NOT NULL,
   ВидНаградыФильм VARCHAR(20),
   FOREIGN KEY (НазваниеФильма,ДатаВыхода) REFERENCES Фильм(НазваниеФильма,ДатаВыхода),
   FOREIGN KEY (НазваниеНаградыФильм,ВидНаградыФильм) REFERENCES НаградаФильм(НазваниеНаградыФильм,ВидНаградыФильм),
   PRIMARY KEY (Год,НазваниеНаградыФильм,ВидНаградыФильм));
   
CREATE TABLE ПолучениеНаградыАктер(
   Год DATE,
   НазваниеНаградыАктер VARCHAR(40),
   idАктера INTEGER NOT NULL REFERENCES Актер(idАктера),
   ВидНаградыАктер VARCHAR(20),
   FOREIGN KEY (НазваниеНаградыАктер,ВидНаградыАктер) REFERENCES НаградаАктер(НазваниеНаградыАктер,ВидНаградыАктер),
   PRIMARY KEY (Год,НазваниеНаградыАктер,ВидНаградыАктер));
   
CREATE TABLE ФильмУактера(
   idАктера INTEGER, 
   НазваниеФильма VARCHAR(40),
   ДатаВыхода DATE,
   FOREIGN KEY (idАктера) REFERENCES Актер(idАктера),
   FOREIGN KEY (НазваниеФильма,ДатаВыхода) REFERENCES Фильм(НазваниеФильма,ДатаВыхода),
   PRIMARY KEY (idАктера,НазваниеФильма,ДатаВыхода));
   
CREATE TABLE Рецензия(
   idРецензии INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
   Текст LONGTEXT NOT NULL,
   ДатаРецензии DATE NOT NULL,
   Логин VARCHAR(20) NOT NULL REFERENCES Пользователь(Логин),
   НазваниеФильма VARCHAR(40) NOT NULL,
   ДатаВыхода DATE NOT NULL,
   FOREIGN KEY (НазваниеФильма,ДатаВыхода) REFERENCES Фильм(НазваниеФильма,ДатаВыхода));
   
CREATE TABLE ОценкаРецензии(
   idРецензии INTEGER,
   Логин VARCHAR(20),
   ДатаОценки DATE NOT NULL CHECK(ДатаОценки BETWEEN DATE('now','-15 years') and DATE('now')),
   Балл INTEGER NOT NULL CHECK(Балл BETWEEN 1 AND 5),
   FOREIGN KEY (idРецензии) REFERENCES Рецензия(idРецензии),
   FOREIGN KEY (Логин) REFERENCES Пользователь(Логин),
   PRIMARY KEY (idРецензии,Логин));
-- Заполнение данными
-- INSERT INTO Table1 ...
-- ваш код здесь!
INSERT INTO Пользователь VALUES ('45677w','М','2014-03-22');
INSERT INTO Пользователь VALUES ('anonimusss','Ж','2006-11-09');
INSERT INTO Пользователь VALUES ('bobik','М','2019-03-05');
INSERT INTO Пользователь VALUES ('b4r4b4n','М','2015-03-16');
INSERT INTO Пользователь VALUES ('vlalkex','М','2018-07-05');
INSERT INTO Пользователь VALUES ('refr','М','2018-04-11');
INSERT INTO Пользователь VALUES ('ladyhelen','Ж','2014-06-16');

INSERT INTO Фильм VALUES ('72 метра','2005-09-02','Владимир Хотиенко','Валерий Залотуха','Капитан-лейтенанты','Боевик');
INSERT INTO Фильм VALUES ('Богемская Рапсодия','2018-10-23','Брайан Сингер','Энтони МакКартен','Чествование группы Queen, их музыки и их выдающегося вокалиста Фредди Меркьюри, который бросил вызов стереотипам и победил условности, чтобы стать одним из самых любимых артистов на планете.','Биография');
INSERT INTO Фильм VALUES ('Брат','1997-05-17','Алексей Балабанов','Алексей Балабанов','Демобилизованный из армии, Данила Багров вернулся в родной городок. Но скучная жизнь российской провинции не устраивала его, и он решился податься в Петербург, где, по слухам, уже несколько лет процветает его старший брат. Данила нашел брата. Но все оказалось не так просто — брат был наемным убийцей…','Боевик');
INSERT INTO Фильм VALUES ('Темные времена','2017-09-01','Джо Райт','Энтони МакКартен','История о первом и решающем шаге Уинстона Черчилля на посту премьер-министра Великобритании, получившего власть при чрезвычайных обстоятельствах. Успехи нацистской армии взбудоражили британское сообщество, но вопреки давлению и страху других политиков Черчилль отказывается идти на соглашение с Гитлером.','Исторический фильм');
INSERT INTO Фильм VALUES ('Кислота','2018-10-04','Алексей Горчилин','Валерий Печейкин','Саша и Петя живут безбашенной жизнью музыкантов современной техно-Москвы: громкие вечеринки, взлеты и падения, колесо нестабильных отношений с окружающими и собой. Они — поколение двадцатилетних, которые часто слышали слова «любовь», «семья» и «возможности», но хорошо усвоили лишь чувство разъедающего изнутри одиночества. Но вдруг в их жизни происходит событие, которое заставляет обоих честно взглянуть на себя.','Драма');
INSERT INTO Фильм VALUES ('Номер 44','2015-04-15','Даниэль Эспиноса','Ричард Прайс','СССР, начало 50-х годов. Офицер МГБ Лев Демидов начинает расследовать серию убийств детей, но проблема в том, что это идёт вразрез с утверждением «у нас убийств нет» самого товарища Сталина.','Триллер');

INSERT INTO Жанр VALUES ('Биография');
INSERT INTO Жанр VALUES ('Боевик');
INSERT INTO Жанр VALUES ('Драма');
INSERT INTO Жанр VALUES ('Историчекий фильм');
INSERT INTO Жанр VALUES ('Триллер');
INSERT INTO Жанр VALUES ('Фантастика');
INSERT INTO Жанр VALUES ('Фэнтези');

INSERT INTO Актер VALUES (NULL,'Петров','Александр','Андреевич','1989-01-25',NULL);
INSERT INTO Актер VALUES (NULL,'Малек','Рами',NULL,'1981-05-12',NULL);
INSERT INTO Актер VALUES (NULL,'Олдман','Гари',NULL,'1958-03-21',NULL);
INSERT INTO Актер VALUES (NULL,'Ларсон','Бри',NULL,'1989-10-01',NULL);
INSERT INTO Актер VALUES (NULL,'Бодров','Сергей','Сергеевич','1971-12-27','2002-09-20');
INSERT INTO Актер VALUES (NULL,'Харди','Том',NULL,'1977-09-15',NULL);
INSERT INTO Актер VALUES (NULL,'Краско','Андрей','Иванович','1957-08-10','2006-07-04');
INSERT INTO Актер VALUES (NULL,'Перри','Люк',NULL,'1966-10-11','2019-03-04');
INSERT INTO Актер VALUES (NULL,'Хэнкс','Том',NULL,'1956-07-09',NULL);
INSERT INTO Актер VALUES (NULL,'Авдеев','Филипп','Вадимович','1991-11-10',NULL);

INSERT INTO ВидНаградыАктер VALUES ('Восходящая звезда');
INSERT INTO ВидНаградыАктер VALUES ('Лучшая женская роль');
INSERT INTO ВидНаградыАктер VALUES ('Лучшая мужская роль');
INSERT INTO ВидНаградыАктер VALUES ('Лучшая мужская роль второго плана');
INSERT INTO ВидНаградыАктер VALUES ('Лучшая мужская роль(Драма)');
INSERT INTO ВидНаградыАктер VALUES ('Лучший актер');
INSERT INTO ВидНаградыАктер VALUES ('Лучший актерский состав');
INSERT INTO ВидНаградыАктер VALUES ('Лучший зарубежный актер');
INSERT INTO ВидНаградыАктер VALUES ('Премия Филипа Морриса');

INSERT INTO ВидНаградыФильм VALUES ('Главный приз');
INSERT INTO ВидНаградыФильм VALUES ('Лучшая музыка');
INSERT INTO ВидНаградыФильм VALUES ('Лучший грим и прически');
INSERT INTO ВидНаградыФильм VALUES ('Лучший Грим/прически');
INSERT INTO ВидНаградыФильм VALUES ('Лучший дебют');
INSERT INTO ВидНаградыФильм VALUES ('Лучший звук');

INSERT INTO ОценкаФильма VALUES ('45677w','72 метра','2005-09-02',8,'2014-03-25');
INSERT INTO ОценкаФильма VALUES ('anonimusss','Брат','1997-05-17',7,'2009-02-18');
INSERT INTO ОценкаФильма VALUES ('bobik','Темные времена','2017-09-01',6,'2019-03-06');
INSERT INTO ОценкаФильма VALUES ('b4r4b4n','Богемская Рапсодия','2018-10-23',2,'2018-10-24');
INSERT INTO ОценкаФильма VALUES ('vlalkex','Богемская Рапсодия','2018-10-23',5,'2018-11-24');
INSERT INTO ОценкаФильма VALUES ('refr','Кислота','2018-10-04',4,'2018-11-10');
INSERT INTO ОценкаФильма VALUES ('ladyhelen','Номер 44','2015-04-15',10,'2015-07-25');

INSERT INTO НаградаФильм VALUES ('Главный приз','Кинотавр');
INSERT INTO НаградаФильм VALUES ('Лучшая музыка','Золотой орел');
INSERT INTO НаградаФильм VALUES ('Лучший грим и прически','Оскар');
INSERT INTO НаградаФильм VALUES ('Лучший Грим/прически','Британская академия');
INSERT INTO НаградаФильм VALUES ('Лучший дебют','Кинотавр');
INSERT INTO НаградаФильм VALUES ('Лучший звук','Оскар');

INSERT INTO НаградаАктер VALUES ('Восходящая звезда','Британская академия');
INSERT INTO НаградаАктер VALUES ('Лучшая женская роль','Оскар');
INSERT INTO НаградаАктер VALUES ('Лучшая мужская роль','Кинотавр');
INSERT INTO НаградаАктер VALUES ('Лучшая мужская роль','Ника');
INSERT INTO НаградаАктер VALUES ('Лучшая мужская роль','Оскар');
INSERT INTO НаградаАктер VALUES ('Лучшая мужская роль второго плана','Ника');
INSERT INTO НаградаАктер VALUES ('Лучшая мужская роль(Драма)','Золотой Глобус');
INSERT INTO НаградаАктер VALUES ('Лучший актер','Сатурн');
INSERT INTO НаградаАктер VALUES ('Лучший актерский состав','Премия Гильдии актеров');
INSERT INTO НаградаАктер VALUES ('Лучший зарубежный актер','Жорж');
INSERT INTO НаградаАктер VALUES ('Премия Филипа Морриса','Карловы Вары');

INSERT INTO ПолучениеНаградыФильм VALUES ('1997','Главный приз','Брат','1997-05-17','Кинотавр');
INSERT INTO ПолучениеНаградыФильм VALUES ('2005','Лучшая музыка','72 метра','2005-09-02','Золотой орел');
INSERT INTO ПолучениеНаградыФильм VALUES ('2018','Лучший грим и прически','Темные времена','2017-09-01','Оскар');
INSERT INTO ПолучениеНаградыФильм VALUES ('2018','Лучший Грим/прически','Темные времена','2017-09-01','Британская академия');
INSERT INTO ПолучениеНаградыФильм VALUES ('2018','Лучший дебют','Кислота','2018-10-04','Кинотавр');
INSERT INTO ПолучениеНаградыФильм VALUES ('2019','Лучший звук','Богемская Рапсодия','2018-10-23','Оскар');

INSERT INTO ПолучениеНаградыАктер VALUES ('1990','Лучший актер',9,'Сатурн');
INSERT INTO ПолучениеНаградыАктер VALUES ('2011','Восходящая звезда',6,'Британская академия');
INSERT INTO ПолучениеНаградыАктер VALUES ('2016','Лучшая женская роль',4,'Оскар');
INSERT INTO ПолучениеНаградыАктер VALUES ('2018','Лучшая мужская роль',3,'Оскар');
INSERT INTO ПолучениеНаградыАктер VALUES ('2019','Лучшая мужская роль',2,'Оскар');
INSERT INTO ПолучениеНаградыАктер VALUES ('1995','Лучшая мужская роль',9,'Оскар');
INSERT INTO ПолучениеНаградыАктер VALUES ('1993','Лучший актер',3,'Сатурн');
INSERT INTO ПолучениеНаградыАктер VALUES ('1996','Лучший актерский состав',9,'Премия Гильдии актеров');

INSERT INTO ФильмУактера VALUES (10,'Кислота','2018-10-04');
INSERT INTO ФильмУактера VALUES (2,'Богемская Рапсодия','2018-10-23');
INSERT INTO ФильмУактера VALUES (3,'Номер 44','2015-04-15');
INSERT INTO ФильмУактера VALUES (6,'Номер 44','2015-04-15');
INSERT INTO ФильмУактера VALUES (5,'Брат','1997-05-17');
INSERT INTO ФильмУактера VALUES (7,'72 метра','2005-09-02');

INSERT INTO Рецензия VALUES (NULL,'Фильм, просмотренный несколько раз достаточно давно, вызвал достаточно противоречивые чувства. Прочитав всего А. Покровского ещё задолго до начала съёмок фильма пребывал в недоумении:как можно было всё собрать в кучу при этом практически убрав тонкий юмор горячо любимого и уважаемого мною писателя?','2014-03-25','45677w','72 метра','2005-09-02');
INSERT INTO Рецензия VALUES (NULL,'Это просто ужасно, все факты перевраны, исполнитель главной роли не дотягивает до своего персонажа ни по внешности, ни по обаянию, ни по харизматичности. Все ведутся на музыку, которая гениальна. Но если ее убрать, останется очень пошленькая история.','2018-11-12','b4r4b4n','Богемская Рапсодия','2018-10-23');
INSERT INTO Рецензия VALUES (NULL,'Фильм заставил задуматься о том, что палка всё-таки о двух концах. С одной стороны — проблемы родителей, с другой стороны — проблемы детей. Одно порождает другое, и жизнь замыкается в порочный круг, вырваться из которого очень сложно. Мы живём рядом, но друг друга не видим и не знаем, потому что ищем себя. И зачастую ищем себя совсем не там, где нужно.','2018-11-10','refr','Кислота','2018-10-04');
INSERT INTO Рецензия VALUES (NULL,'Что понравилось:1)   Выбранная эпоха. Нечасто иностранцы снимают кино о тех временах, да еще не связанные напрямую с войной.2)   Реалистическое изображение пороков общества: подлость, карьеризм, нищета, грязь, пропаганда.','2015-07-25','ladyhelen','Номер 44','2015-04-15');
INSERT INTO Рецензия VALUES (NULL,'Никогда не был интересен Фредди Меркьюри, и я никогда не фанател по классике рока, несмотря на то что я являюсь тем еще меломаном, просто я не застал то время, и подобное не вызвало больших эмоций.','2019-04-09','vlalkex','Богемская Рапсодия','2018-10-23');

INSERT INTO ОценкаРецензии VALUES (6,'45677w','2019-04-10',3);
INSERT INTO ОценкаРецензии VALUES (2,'refr','2018-04-12',3);
INSERT INTO ОценкаРецензии VALUES (3,'bobik','2019-03-10',4);
INSERT INTO ОценкаРецензии VALUES (1,'vlalkex','2019-02-2-18',4);
INSERT INTO ОценкаРецензии VALUES (5,'refr','2019-04-09',1);