CREATE OR REPLACE VIEW vw_employees AS
SELECT
    e.emp_no                                AS num_funcionario,
    e.birth_date                            AS data_nascimento,
    e.gender                                AS sexo,
    CONCAT(e.first_name, ' ', e.last_name)  AS nome_funcionario,
    e.hire_date                             AS data_contratado,
    t.title                                 AS cargo,
    t.from_date                             AS titulado_em,
    t.to_date                               AS titulado_ate,
    s.salary                                AS salario,
    s.from_date                             AS data_ajuste_salario
FROM
    employees e
    INNER JOIN titles   t ON e.emp_no = t.emp_no
    INNER JOIN salaries s ON e.emp_no = s.emp_no
ORDER BY
    e.emp_no;

-- 4.638.507 registros
SELECT * FROM vw_employees;


CREATE OR REPLACE VIEW vw_dept_emp AS
SELECT
    de.emp_no      AS num_funcionario,
    d.dept_name    AS departamento,
    de.from_date   AS lotado_em,
    de.to_date     AS lotado_ate
FROM
    dept_emp de
    INNER JOIN departments d
        ON de.dept_no = d.dept_no
ORDER BY
    de.emp_no;

-- 331.603 registros
SELECT * FROM vw_dept_emp;


CREATE OR REPLACE VIEW vw_dept_manager AS
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS chefia,               -- nome completo do gerente
    dm.emp_no                             AS num_chefia,           -- número do gerente
    d.dept_name                           AS nome_departamento,    -- nome do departamento
    dm.from_date                          AS data_entrada_chefia,  -- início da chefia
    dm.to_date                            AS data_saida_chefia     -- fim da chefia
FROM
    dept_manager dm
    INNER JOIN departments d
        ON dm.dept_no = d.dept_no
    INNER JOIN employees e
        ON dm.emp_no = e.emp_no
ORDER BY
    dm.emp_no;

-- 24 registros
SELECT * FROM vw_dept_manager;


CREATE OR REPLACE VIEW vw_employees_dept AS
SELECT
    ve.num_funcionario       AS num_funcionario,
    ve.data_nascimento       AS data_nascimento,
    ve.sexo                  AS sexo,
    ve.nome_funcionario      AS nome_funcionario,
    ve.data_contratado       AS data_contratado,
    ve.cargo                 AS cargo,
    ve.titulado_em           AS titulado_em,
    ve.titulado_ate          AS titulado_ate,
    ve.salario               AS salario,
    ve.data_ajuste_salario   AS data_ajuste_salario,
    vd.departamento          AS dept_name,
    'Subordinado'            AS role,
    vd.lotado_em             AS from_date_role,
    vd.lotado_ate            AS to_date_role
FROM
    vw_employees ve
    INNER JOIN vw_dept_emp vd
        ON ve.num_funcionario = vd.num_funcionario;

-- 5.124.191 registros
SELECT * FROM vw_employees_dept;


CREATE OR REPLACE VIEW vw_employees_manager AS
SELECT
    ve.num_funcionario       AS num_funcionario,
    ve.data_nascimento       AS data_nascimento,
    ve.sexo                  AS sexo,
    ve.nome_funcionario      AS nome_funcionario,
    ve.data_contratado       AS data_contratado,
    ve.cargo                 AS cargo,
    ve.titulado_em           AS titulado_em,
    ve.titulado_ate          AS titulado_ate,
    ve.salario               AS salario,
    ve.data_ajuste_salario   AS data_ajuste_salario,
    vm.nome_departamento     AS dept_name,
    'Gerente'                AS role,
    vm.data_entrada_chefia   AS from_date_role,
    vm.data_saida_chefia     AS to_date_role
FROM
    vw_employees ve
    INNER JOIN vw_dept_manager vm
        ON ve.num_funcionario = vm.num_chefia;

-- 863 registros
SELECT * FROM vw_employees_manager;


CREATE OR REPLACE VIEW vw_all_employees AS
SELECT
    data_nascimento,
    sexo,
    data_contratado      AS hire_date,
    cargo                AS title,
    titulado_em          AS from_date_titles,
    titulado_ate         AS to_date_titles,
    salario,
    data_ajuste_salario  AS from_date_salary,
    dept_name,
    role,
    from_date_role,
    to_date_role
FROM vw_employees_dept

UNION ALL

SELECT
    data_nascimento,
    sexo,
    data_contratado,
    cargo,
    titulado_em,
    titulado_ate,
    salario,
    data_ajuste_salario,
    dept_name,
    role,
    from_date_role,
    to_date_role
FROM vw_employees_manager;

-- 5.125.053 registros
SELECT * FROM vw_all_employees;


CREATE TABLE IF NOT EXISTS employees_dm (
    id                    INT AUTO_INCREMENT PRIMARY KEY,
    birth_date            DATE,
    gender                ENUM('M','F'),
    hire_date             DATE,
    title                 VARCHAR(50),
    from_date_titles      DATE,
    to_date_titles        DATE,
    salary                INT,
    from_date_salary      DATE,
    to_date_salary        DATE,
    dept_name             VARCHAR(40),
    role                  VARCHAR(45),
    from_date_role        DATE,
    to_date_role          DATE
);
INSERT INTO employees_dm (
    birth_date,
    gender,
    hire_date,
    title,
    from_date_titles,
    to_date_titles,
    salary,
    from_date_salary,
    dept_name,
    role,
    from_date_role,
    to_date_role
)
SELECT
    data_nascimento,
    sexo,
    hire_date,
    title,
    from_date_titles,
    to_date_titles,
    salario,
    from_date_salary,
    dept_name,
    role,
    from_date_role,
    to_date_role
FROM vw_all_employees;



SELECT * FROM employees_dm;
-- 5.125.053 registros
