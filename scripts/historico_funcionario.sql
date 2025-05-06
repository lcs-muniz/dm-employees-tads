SELECT
  e.emp_no                             AS num_funcionario,
  e.birth_date                         AS data_nascimento,
  e.gender                             AS sexo,
  CONCAT(e.first_name,' ',e.last_name) AS nome_funcionario,
  e.hire_date                          AS data_contratado,

  de.dept_no                           AS num_departamento,
  d.dept_name                          AS departamento,
  de.from_date                         AS lotado_em,
  de.to_date                           AS lotado_ate,

  t.title                              AS cargo,
  t.from_date                          AS titulado_em,
  t.to_date                            AS titulado_ate,

  s.salary                             AS salario,
  s.from_date                          AS data_ajuste_salario,

  IF(dm.emp_no IS NOT NULL,
     CONCAT(c.first_name,' ',c.last_name),
     NULL)                             AS chefia,
  dm.from_date                         AS data_entrada_chefia,
  dm.to_date                           AS data_saida_chefia

FROM employees e

  JOIN titles t
    ON e.emp_no = t.emp_no

  LEFT JOIN salaries s
    ON e.emp_no    = s.emp_no
   AND s.from_date <= t.from_date
   AND s.to_date   >= t.from_date

  LEFT JOIN dept_emp de
    ON e.emp_no    = de.emp_no
   AND de.from_date <= t.from_date
   AND de.to_date   >= t.from_date

  LEFT JOIN departments d
    ON de.dept_no = d.dept_no

  LEFT JOIN dept_manager dm
    ON de.dept_no   = dm.dept_no
   AND dm.from_date <= t.from_date
   AND dm.to_date   >= t.from_date

  LEFT JOIN employees c
    ON c.emp_no = dm.emp_no

ORDER BY
  e.emp_no,
  t.from_date;