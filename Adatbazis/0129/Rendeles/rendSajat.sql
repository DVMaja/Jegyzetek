create database  rendeles2

use rendel�s2


Select * from  beszerz�s
Select * from anyag
Select * from  term�k
Select * from  szerkezet

Select * from �rv�lt
Select * from Min�s�t�s

Select * from Partner
Select * from Rend_fej
Select * from Rend_t�tel
--Select * from Engedm�ny

Select * from Term�k
Select * from Sz�ll_fej
Select * from Sz�ll_t�tel
Select * from Sz�mla

select dbo.term�k_�ra('20240129', 3)

select dbo.futja(3)
--select dbo.term�k_�ra(2024-01-28, 1)
--select dbo.term�k_�ra(getDate(), 1)
--Minden term�k olcs� e
--Mennyibe ker�l egy adott napon egy adott term�k
--ha megt�rt�nik egy updsate akkor az if azt n�zi ami m�r benn van , �s egy after updatell v�ltoztat


