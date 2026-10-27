-- Aluno: Francisco Jesus
-- Numero: a22502776
-- Turma: LEI Noite
-- Horário: 19:30
-- Caso de estudo:  Horários Escolares


/*Q1*/
CREATE SCHEMA a22502776;
GO

CREATE TABLE a22502776.Docente (
    DocenteID INT IDENTITY(1,1) PRIMARY KEY,
    Nome NVARCHAR(100) NOT NULL,
    Email NVARCHAR(150) NULL,
    CONSTRAINT UQ_Docente_Email UNIQUE (Email)
);

CREATE TABLE a22502776.Disciplina (
    DisciplinaID INT IDENTITY(1,1) PRIMARY KEY,
    Nome NVARCHAR(100) NOT NULL,
    Codigo NVARCHAR(20) NOT NULL,
    CONSTRAINT UQ_Disciplina_Codigo UNIQUE (Codigo)
);

CREATE TABLE a22502776.Aula (
    AulaID INT IDENTITY(1,1) PRIMARY KEY,
    DocenteID INT NOT NULL,
    DisciplinaID INT NOT NULL,
    DiaDaSemana TINYINT NOT NULL,
    HoraInicio TIME NOT NULL,
    HoraFim TIME NOT NULL,
    CONSTRAINT FK_Aula_Docente FOREIGN KEY (DocenteID)
        REFERENCES a22502776.Docente(DocenteID),
    CONSTRAINT FK_Aula_Disciplina FOREIGN KEY (DisciplinaID)
        REFERENCES a22502776.Disciplina(DisciplinaID),
    CONSTRAINT CK_Aula_Dia CHECK (DiaDaSemana BETWEEN 1 AND 7),
    CONSTRAINT CK_Aula_Horario CHECK (HoraInicio < HoraFim),
    CONSTRAINT UQ_Docente_Dia_Hora UNIQUE (DocenteID, DiaDaSemana, HoraInicio)
);

SELECT * FROM a22502776.Docente;
SELECT * FROM a22502776.Disciplina;
SELECT * FROM a22502776.Aula;


/*Q2*/
INSERT INTO a22502776.Docente (Nome, Email)
VALUES
    ('A', 'A@escola.pt'),
    ('B', 'B@escola.pt'),
    ('C', 'C@escola.pt');

INSERT INTO a22502776.Disciplina (Nome, Codigo)
VALUES
    ('Matemática', 'M'),
    ('Programação', 'P'),
    ('Ciências', 'C'); 

INSERT INTO a22502776.Aula (DocenteID, DisciplinaID, DiaDaSemana, HoraInicio, HoraFim)
VALUES
    (1, 1, 1, '19:30', '21:00'), 
    (1, 1, 3, '19:30', '21:00'),
    (2, 1, 2, '19:30', '21:00'),
    (2, 2, 4, '19:30', '21:00'),
    (2, 2, 6, '09:00', '10:30');

SELECT * FROM a22502776.Docente;
SELECT * FROM a22502776.Disciplina;
SELECT * FROM a22502776.Aula;

SELECT
    d.Nome AS Docente,
    di.Nome AS Disciplina,
    a.DiaDaSemana,
    a.HoraInicio,
    a.HoraFim
FROM a22502776.Aula AS a
INNER JOIN a22502776.Docente AS d ON d.DocenteID = a.DocenteID
INNER JOIN a22502776.Disciplina AS di ON di.DisciplinaID = a.DisciplinaID
WHERE d.Nome = N'Ana Martins'
ORDER BY a.DiaDaSemana, a.HoraInicio;

SELECT di.Nome AS Disciplina
FROM a22502776.Disciplina AS di
WHERE NOT EXISTS (
    SELECT 1
    FROM a22502776.Aula AS a
    WHERE a.DisciplinaID = di.DisciplinaID
);


/*Q3*/
ALTER TABLE a22502776.Aula
ADD Sala NVARCHAR(20) NULL;

UPDATE a22502776.Aula
SET Sala = CASE AulaID
    WHEN 1 THEN N'F'
    WHEN 2 THEN N'F'
    WHEN 3 THEN N'Q'
    WHEN 4 THEN N'U'
    ELSE N'U'
END;

ALTER TABLE a22502776.Aula
ALTER COLUMN Sala NVARCHAR(20) NOT NULL;

ALTER TABLE a22502776.Aula
ADD CONSTRAINT CK_Aula_Sala
CHECK (Sala LIKE N'[FQU]%');

SELECT * FROM a22502776.Aula;
SELECT * FROM a22502776.Aula
WHERE DocenteID = 2;

/*Q4*/
UPDATE a22502776.Disciplina
SET Codigo = N'MD'
WHERE DisciplinaID = (
    SELECT TOP 1 a.DisciplinaID
    FROM a22502776.Aula AS a
    INNER JOIN a22502776.Docente AS d ON d.DocenteID = a.DocenteID
    WHERE d.Nome = N'A'
);

SELECT
    d.Nome AS Docente,
    di.Nome AS Disciplina,
    a.DiaDaSemana,
    a.HoraInicio,
    a.HoraFim,
    a.Sala
FROM a22502776.Aula AS a
INNER JOIN a22502776.Docente AS d ON d.DocenteID = a.DocenteID
INNER JOIN a22502776.Disciplina AS di ON di.DisciplinaID = a.DisciplinaID
WHERE d.DocenteID IN (
    SELECT DISTINCT a2.DocenteID
    FROM a22502776.Aula AS a2
    WHERE a2.Sala = N'F'
)
ORDER BY d.Nome, a.DiaDaSemana, a.HoraInicio;


/*Q5*/
SELECT
    di.Nome AS Disciplina,
    a.DiaDaSemana,
    a.HoraInicio,
    a.HoraFim,
    a.Sala
FROM a22502776.Aula AS a
INNER JOIN a22502776.Docente AS d ON d.DocenteID = a.DocenteID
INNER JOIN a22502776.Disciplina AS di ON di.DisciplinaID = a.DisciplinaID
WHERE d.Nome = N'A';

DELETE FROM a22502776.Aula
WHERE DocenteID = 1;

DELETE FROM a22502776.Docente
WHERE DocenteID = 1;

SELECT *
FROM a22502776.Docente
WHERE DocenteID = 1;


/*Q6*/
DELETE FROM a22502776.Aula;
DELETE FROM a22502776.Disciplina;
DELETE FROM a22502776.Docente;

SELECT * FROM a22502776.Docente;
SELECT * FROM a22502776.Disciplina;
SELECT * FROM a22502776.Aula;


/*Q7*/
DROP TABLE a22502776.Aula;
DROP TABLE a22502776.Disciplina;
DROP TABLE a22502776.Docente;

DROP SCHEMA a22502776;

SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'a22502776';

SELECT name FROM sys.schemas WHERE name = 'a22502776';