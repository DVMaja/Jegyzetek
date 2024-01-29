create database  rendeles2

use rendelés2


Select * from  beszerzés
Select * from anyag
Select * from  termék
Select * from  szerkezet

Select * from Árvált
Select * from Minõsítés

Select * from Partner
Select * from Rend_fej
Select * from Rend_tétel
--Select * from Engedmény

Select * from Termék
Select * from Száll_fej
Select * from Száll_tétel
Select * from Számla

select dbo.termék_ára('20240129', 3)

select dbo.futja(3)
--select dbo.termék_ára(2024-01-28, 1)
--select dbo.termék_ára(getDate(), 1)
--Minden termék olcsó e
--Mennyibe kerül egy adott napon egy adott termék
--ha megtörténik egy updsate akkor az if azt nézi ami már benn van , és egy after updatell változtat


