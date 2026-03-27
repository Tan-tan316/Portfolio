WITH a AS (SELECT *
, CASE WHEN ovd LIKE '%ХЕРСОНСЬКІЙ%' THEN 'Херсонська обл.'
            WHEN ovd LIKE '%ВІННИЦЬКІЙ%' THEN 'Вінницька обл.'
            WHEN ovd LIKE '%ВОЛИНСЬКІЙ%' THEN 'Волинська обл.'
            WHEN ovd LIKE '%ДНІПРОПЕТРОВСЬКІЙ%' THEN 'Дніпропетровська обл.'
            WHEN ovd LIKE '%ДОНЕЦЬКІЙ%' THEN 'Донецька обл.'
            WHEN ovd LIKE '%ЖИТОМИРСЬКІЙ%' THEN 'Житомирська обл.'
            WHEN ovd LIKE '%ЗАКАРПАТСЬКІЙ%' THEN 'Закарпатська обл.'
            WHEN ovd LIKE '%ІВАНО-ФРАНКІВСЬКІЙ%' THEN 'Івано-Франковська обл.'          
            WHEN ovd LIKE '%КІРОВОГРАДСЬКІЙ%' THEN 'Кіровоградська обл.'
            WHEN ovd LIKE '%ЛЬВІВСЬКІЙ%' THEN 'Львівська обл.'
            WHEN ovd LIKE '%МИКОЛАЇВСЬКІЙ%' THEN 'Миколаївська обл.'
            WHEN ovd LIKE '%ОДЕСЬКІЙ%' THEN 'Одеська обл.'
            WHEN ovd LIKE '%ПОЛТАВСЬКІЙ%' THEN 'Полтавська обл.'
            WHEN ovd LIKE '%РІВНЕНСЬКІЙ%' THEN 'Рівненська обл.'
            WHEN ovd LIKE '%СУМСЬКІЙ%' THEN 'Сумська обл.'
            WHEN ovd LIKE '%ТЕРНОПІЛЬСЬКІЙ%' THEN 'Тернопільська обл.'
            WHEN ovd LIKE '%ХАРКІВСЬКІЙ%' THEN 'Харківська обл.'
            WHEN ovd LIKE '%ХМЕЛЬНИЦЬКІЙ%' THEN 'Хмельницька обл.'
            WHEN ovd LIKE '%ЧЕРКАСЬКІЙ%' THEN 'Черкаська обл.'
            WHEN ovd LIKE '%ЧЕРНІВЕЦЬКІЙ%' THEN 'Чернівецька обл.'
            WHEN ovd LIKE '%ЧЕРНІГІВСЬКІЙ%' THEN 'Чернігівська обл.'
            WHEN ovd LIKE '%ЗАПОРІЗЬКІЙ%' THEN 'Запорізька обл.'
            WHEN ovd LIKE '%ЛУГАНСЬКІЙ%' THEN 'Луганській обл.'
            WHEN ovd LIKE '%ХЕРСОНСЬКОЇ%' THEN 'Херсонська обл.'
            WHEN ovd LIKE '%ЖИТОМИРСЬКЕ%' THEN 'Житомирська обл.'
            WHEN ovd LIKE '%ЧЕРНІГІВСЬКОЇ%' THEN 'Чернігівська обл.'
            WHEN ovd LIKE '%КИЄВІ%' THEN 'м.Київ'
            WHEN ovd LIKE '%КИЇВСЬКІЙ%' THEN 'Київська обл.'
            ELSE 'Автономна Республіка Крим'
		END AS oblst
from stolen_phones)
SELECT *
FROM a 
WHERE oblst != 'Луганській обл.'

SELECT *
FROM stolen_phones
WHERE obl = 'Автономна Республіка Крим'


				
