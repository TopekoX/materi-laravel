SELECT name, AVG(score) AS average
FROM results
GROUP BY name
HAVING AVG(score) >= 60
ORDER BY average DESC;
