DROP DATABASE IF EXISTS ACADEMIA;
CREATE DATABASE ACADEMIA;
USE ACADEMIA;

CREATE TABLE Usuario (
    idUsuario INT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
    senha VARCHAR(50) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    cpf VARCHAR(15) NOT NULL,
    data_nascimento DATE NOT NULL,
    PRIMARY KEY (idUsuario)
);
-- tipo de aula, carga horaria, salario
CREATE TABLE Professor (
    idProfessor INT NOT NULL AUTO_INCREMENT,
    tipo_aula VARCHAR(50)NOT NULL, 
    carga_horaria INT NOT NULL, 
    salario DECIMAL(10,2) NOT NULL,	
    id_usuario INT NOT NULL,
    PRIMARY KEY (idProfessor),
    FOREIGN KEY (id_usuario) REFERENCES Usuario(idUsuario)
);

CREATE TABLE Plano (
    idPlano INT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (idPlano)
);

CREATE TABLE Aluno (
    idAluno INT NOT NULL AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    id_plano INT NOT NULL,
    objetivo VARCHAR(30) NOT NULL,
    peso DECIMAL(10,2) NOT NULL,
    altura DECIMAL(10,2) NOT NULL,
    IMC DECIMAL(10,2),
    PRIMARY KEY (idAluno),
    FOREIGN KEY (id_usuario) REFERENCES Usuario (idUsuario),
    FOREIGN KEY (id_plano) REFERENCES Plano (idPlano)
);

CREATE TABLE Exercicio (
    idExercicio INT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    PRIMARY KEY (idExercicio)
);

CREATE TABLE ExercicioAlunoProfessor (
	idExercicioAluno INT NOT NULL AUTO_INCREMENT, 
	id_exercicio INT NOT NULL,
    id_aluno INT NOT NULL,
	id_professor INT NOT NULL,
	PRIMARY KEY (idExercicioAluno),
    FOREIGN KEY (id_exercicio) REFERENCES Exercicio(idExercicio),
    FOREIGN KEY (id_aluno) REFERENCES Aluno(idAluno),
    FOREIGN KEY (id_professor) REFERENCES Professor(idProfessor)
);

CREATE TABLE Pagamento (
    idPagamento INT NOT NULL AUTO_INCREMENT,
    id_aluno INT NOT NULL,
    data_pagamento DATE NOT NULL,
	statusPagamento VARCHAR(8) NOT NULL DEFAULT 'A pagar',
    PRIMARY KEY (idPagamento),
    FOREIGN KEY (id_aluno) REFERENCES Aluno(idAluno)
);



# INSERTS

INSERT INTO Usuario (nome, email, senha, telefone, cpf, data_nascimento) VALUES
	('Lucas Oliveira', 'lucas.oliveira@gmail.com', 'lucas456', '7777-7777', '123.456.789-00', '1990-01-01'),
	('Henrique Araújo', 'henrique.araujo@outlook.com', 'paris@13', '8888-8888', '327.856.490-03', '1980-06-15'),
	('Mara Shimamoto', 'mara.shima@msn.com', 'MS#R5', '9999-9999', '234.567.890-11', '1985-05-10'),
    ('João Silva', 'joao.silva@gmail.com', '123456', '5555-5555', '345.678.901-22', '1995-12-31'),
    ('Maria Santos', 'maria.santos@hotmail.com', 'abcdef', '6666-6666', '152.903.375-04', '2000-08-20'),
    ('Pedro Oliveira', 'pedro.oliveira@yahoo.com', 'qwerty', '7777-7777', '349.538.683-04', '2002-07-25'),
    ('Ana Souza', 'ana.souza@gmail.com', 'ana456', '99586-2429', '111.222.333-44', '1992-07-10');

INSERT INTO Professor (tipo_aula, carga_horaria, salario, id_usuario) VALUES
    ('Musculação', 8, 2700.00, 1),
    ('Musculação', 8, 2890.00, 3),
    ('Zumba e Ginástica', 7, 1900.00, 7);

INSERT INTO Plano (nome, descricao, valor) VALUES
    ('Plano básico', 'Acesso a todas as áreas da academia', 100.00),
    ('Plano premium', 'Acesso a todas as áreas da academia + aulas de grupo', 150.00),
    ('Plano VIP', 'Acesso a todas as áreas da academia + aulas de grupo + treinamento personalizado', 250.00);


INSERT INTO Aluno (objetivo, peso, altura, id_usuario, id_plano) VALUES
    ('Emagrecer', 105.56, 1.76, 2, 1),
    ('Ganhar massa muscular', 80.2, 1.85, 4, 1),
    ('Manter o peso', 65.0, 1.70, 1, 2),
    ('Perder gordura abdominal', 75.3, 1.78, 5, 3),
    ('Melhorar a saúde', 90.5, 1.80, 6, 1);
    
INSERT INTO Exercicio (nome, categoria) VALUES
	("Agachamento livre", "Membros inferiores"),
    ("Afundo", "Membros inferiores"),
    ("Leg 45", "Membros inferiores"),
    ("Supino", "Membros superiores"),
    ("Triceps testa", "Membros superiores"),
    ("Desenvolvimento barra", "Membros superiores");

INSERT INTO ExercicioAlunoProfessor (id_aluno, id_exercicio, id_professor) VALUES
	(1, 1, 1),
	(1, 2, 1),
    (2, 3, 1),
    (3, 4, 2),
    (4, 5, 2),
    (5, 4, 2),
    (5, 5, 2),
    (5, 6, 2);
    
INSERT INTO Pagamento (id_aluno, data_pagamento) VALUES
	(1, '2023-05-20'),
	(2, '2023-06-30'),
    (3, '2023-09-09'),
    (4, '2023-04-21'),
    (5, '2023-09-12');
    
SET GLOBAL log_bin_trust_function_creators = 1;
    
DELIMITER ||
CREATE FUNCTION calcular_imc(peso DECIMAL(10,2), altura DECIMAL(10,2))
RETURNS DECIMAL(10,2)
BEGIN
    DECLARE imc DECIMAL(10,2);
    SET imc = peso / (altura * altura);
    RETURN imc;
END 
||
DELIMITER ;

#  Criar um novo aluno no banco de dados;
DELIMITER ||
CREATE PROCEDURE cria_novo_aluno(IN pNome VARCHAR(50), IN pEmail VARCHAR(50), IN pSenha VARCHAR(50), IN pTelefone VARCHAR(50), IN pCPF VARCHAR(14), IN pDataNascimento DATE, IN pObjetivo VARCHAR(30), IN pPeso DECIMAL(10,2), IN pAltura DECIMAL(10,2), IN pNomePlano VARCHAR(100), IN pDataPagamento DATE)
BEGIN
	INSERT INTO Usuario (nome, email, senha, telefone, cpf, data_nascimento) VALUES (pNome, pEmail, pSenha, pTelefone, pCPF, pDataNascimento);
    INSERT INTO Aluno (objetivo, peso, altura, id_plano, id_usuario, IMC) VALUES (pObjetivo, pPeso, pAltura, (select idPlano from Plano where nome = pNomePlano), last_insert_id(), calcular_imc(pPeso, pAltura));
    INSERT INTO Pagamento (id_aluno, data_pagamento) VALUES (last_insert_id(), pDataPagamento);
END
||

call cria_novo_aluno('Rafael', 'rafael@laal.com', 'rafael1234', '99876-2564', '569.145.246-02', '2002-06-14', 'Ganhar mais massa muscular', 85.0, 1.91, 'Plano básico', '2023-05-12');

#  Ver todos os aluno no banco de dados;
CREATE VIEW VerAluno AS
	select u.Nome, u.Email, u.Senha, u.Telefone, u.CPF, u.Data_Nascimento, l.nome as Tipo_Plano, p.Data_Pagamento from Aluno a 
	INNER JOIN Usuario u ON idUsuario = id_usuario
    INNER JOIN Plano l ON id_plano = idPlano
	INNER JOIN Pagamento p ON idAluno = id_aluno ORDER BY u.Nome ASC;
SELECT * from VerAluno;

CREATE VIEW quantidade_alunos_por_plano AS
SELECT COUNT(*) as Alunos, p.nome FROM Aluno a
INNER JOIN Plano p ON a.id_plano = p.idPlano
GROUP BY(id_plano);

SELECT * FROM quantidade_alunos_por_plano;

DELIMITER ||
CREATE FUNCTION valida_cpf(cpf VARCHAR(14)) RETURNS BOOLEAN
BEGIN
    DECLARE dig1 INT DEFAULT 0;
    DECLARE dig2 INT DEFAULT 0;
    DECLARE i INT DEFAULT 0;
    DECLARE calc INT DEFAULT 0;
    DECLARE cpf_clean VARCHAR(11) DEFAULT '';

    SET cpf_clean = REPLACE(REPLACE(REPLACE(cpf, '.', ''), '-', ''), ' ', '');

    IF cpf_clean REGEXP '^[0-9]+$' AND CHAR_LENGTH(cpf_clean) = 11 THEN
        SET i = 1;
        SET calc = 0;

        WHILE i <= 9 DO
            SET calc = calc + SUBSTRING(cpf_clean, i, 1) * (11 - i);
            SET i = i + 1;
        END WHILE;

        SET dig1 = 11 - MOD(calc, 11);
        IF dig1 >= 10 THEN
            SET dig1 = 0;
        END IF;

        SET i = 1;
        SET calc = 0;

        WHILE i <= 10 DO
            SET calc = calc + SUBSTRING(cpf_clean, i, 1) * (12 - i);
            SET i = i + 1;
        END WHILE;

        SET dig2 = 11 - MOD(calc, 11);
        IF dig2 >= 10 THEN
            SET dig2 = 0;
        END IF;

        IF dig1 = SUBSTRING(cpf_clean, 10, 1) AND dig2 = SUBSTRING(cpf_clean, 11, 1) THEN
            RETURN TRUE;
        ELSE
            RETURN FALSE;
        END IF;
    ELSE
        RETURN FALSE;
    END IF;
END ||
DELIMITER ;

DELIMITER ||
CREATE TRIGGER verifica_cpf_usuario
BEFORE INSERT ON Usuario
FOR EACH ROW
BEGIN
	DECLARE cpfValido BOOLEAN DEFAULT FALSE;
    
    IF EXISTS (SELECT * FROM Usuario WHERE cpf = NEW.cpf) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CPF já cadastrado!';
    END IF;
    
    SET cpfValido = valida_cpf(NEW.cpf);
    IF NOT cpfValido THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CPF inválido!';
    END IF;
END;
||

DELIMITER ||
CREATE PROCEDURE listar_exercicios_por_categoria(IN categoria VARCHAR(50))
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE nome_exercicio VARCHAR(50);
    DECLARE cur CURSOR FOR SELECT nome FROM Exercicio e WHERE e.categoria LIKE categoria;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO nome_exercicio;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        SELECT nome_exercicio;
    END LOOP;
    
    CLOSE cur;
END
||

DELIMITER ;

CALL listar_exercicios_por_categoria('Membros inferiores');

DELIMITER ||
CREATE FUNCTION contar_alunos_por_plano(idPlano INT)
RETURNS INT
BEGIN
    DECLARE count INT;
    SELECT COUNT(*) INTO count FROM Aluno WHERE id_plano = idPlano;
    RETURN count;
END 
||
DELIMITER ;

DELIMITER ||
CREATE PROCEDURE atualizar_data_pagamento(IN pIdAluno INT, IN pNovaData DATE)
BEGIN
	UPDATE pagamento p SET p.data_pagamento = pNovaData WHERE p.id_aluno = pIdAluno;
END;
||
DELIMITER ;

CALL atualizar_data_pagamento(1, "2023-05-15");


CREATE VIEW verificar_pagamentos_atrasados AS
	SELECT u.nome, u.email, u.telefone, DATE_FORMAT(p.data_pagamento, "%d/%m/%Y") as dataPagamento
    FROM aluno a INNER JOIN usuario u
    ON a.id_usuario = u.idUsuario
    INNER JOIN pagamento p
    ON p.id_aluno = a.idAluno
    WHERE p.data_pagamento < curdate();
    
DELIMITER ||
CREATE PROCEDURE pagamento_aluno(IN pIdPagamento INT, pStatusPagamento VARCHAR(8))
BEGIN
	UPDATE pagamento SET statusPagamento = pStatusPagamento WHERE idPagamento = pIdPagamento;
    
    IF(pStatusPagamento = "Pago") THEN
		INSERT INTO pagamento(id_aluno, data_pagamento) VALUE(
		(SELECT id FROM ((SELECT id_aluno as id FROM pagamento WHERE idPagamento = pIdPagamento)) as P), DATE_ADD(CURDATE(), INTERVAL 1 MONTH)
            );
	END IF;
END
||
DELIMITER ;
call pagamento_aluno(2, 'Pago');

#Cursor para buscar alunos por professor
-- drop procedure buscar_alunos_professor
DELIMITER ||
CREATE PROCEDURE buscar_alunos_professor(IN nomeProfessor VARCHAR(50))
BEGIN
    DECLARE professor_id INT;
    DECLARE done INT DEFAULT FALSE;
    DECLARE aluno_id INT;
    DECLARE aluno_nome VARCHAR(50);
    DECLARE cur CURSOR FOR
        SELECT DISTINCT a.idAluno, u.nome
        FROM Aluno a
        INNER JOIN ExercicioAlunoProfessor eap ON a.idAluno = eap.id_aluno
        INNER JOIN Professor p ON eap.id_professor = p.idProfessor
        INNER JOIN Usuario u ON a.id_usuario = u.idUsuario
        WHERE p.idProfessor = professor_id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    SELECT idProfessor INTO professor_id FROM Professor p INNER JOIN Usuario u ON p.id_usuario = u.idUsuario WHERE u.nome = nomeProfessor;

    OPEN cur;
    FETCH cur INTO aluno_id, aluno_nome;
    WHILE NOT done DO
        SELECT aluno_id, aluno_nome;
        FETCH cur INTO aluno_id, aluno_nome;
    END WHILE;
    CLOSE cur;
END;
||
DELIMITER ;

-- call buscar_alunos_professor('Mara Shimamoto');
DELIMITER ||
CREATE TRIGGER valida_carga_horaria 
BEFORE INSERT ON Professor
FOR EACH ROW
BEGIN
	IF(NEW.carga_horaria > 8) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A carga horária diária não pode ser superior a 8 horas!';
    END IF;
END;
||
DELIMITER ;

DELIMITER ||
	CREATE TRIGGER valida_formato_email
    BEFORE INSERT ON Usuario
    FOR EACH ROW
    BEGIN
		IF NEW.email NOT REGEXP '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$' THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'O email fornecido não é válido';
		END IF;
	END;
||

DELIMITER ;
