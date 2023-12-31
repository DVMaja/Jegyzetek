USE [oktatas]
GO
INSERT [dbo].[evfolyam] ([evf]) VALUES (3)
INSERT [dbo].[evfolyam] ([evf]) VALUES (5)
GO
INSERT [dbo].[tantargy] ([tant], [megnev], [heti_oraszam]) VALUES (N'ANG5 ', N'Angol', 5)
INSERT [dbo].[tantargy] ([tant], [megnev], [heti_oraszam]) VALUES (N'FIZ5 ', N'Fizika', 4)
INSERT [dbo].[tantargy] ([tant], [megnev], [heti_oraszam]) VALUES (N'INFO ', N'Informatika', 3)
INSERT [dbo].[tantargy] ([tant], [megnev], [heti_oraszam]) VALUES (N'MAT3 ', N'Matek', 2)
INSERT [dbo].[tantargy] ([tant], [megnev], [heti_oraszam]) VALUES (N'MAT5 ', N'Matek', 5)
INSERT [dbo].[tantargy] ([tant], [megnev], [heti_oraszam]) VALUES (N'RAJZ ', N'Rajz', 2)
INSERT [dbo].[tantargy] ([tant], [megnev], [heti_oraszam]) VALUES (N'TÖRT3', N'Történelem', 2)
GO
INSERT [dbo].[tanterv] ([evf], [tant]) VALUES (3, N'MAT3 ')
INSERT [dbo].[tanterv] ([evf], [tant]) VALUES (3, N'RAJZ ')
INSERT [dbo].[tanterv] ([evf], [tant]) VALUES (3, N'TÖRT3')
INSERT [dbo].[tanterv] ([evf], [tant]) VALUES (5, N'ANG5 ')
INSERT [dbo].[tanterv] ([evf], [tant]) VALUES (5, N'FIZ5 ')
INSERT [dbo].[tanterv] ([evf], [tant]) VALUES (5, N'INFO ')
INSERT [dbo].[tanterv] ([evf], [tant]) VALUES (5, N'MAT5 ')
GO
INSERT [dbo].[osztaly] ([evf], [betu]) VALUES (3, N'A')
INSERT [dbo].[osztaly] ([evf], [betu]) VALUES (3, N'B')
INSERT [dbo].[osztaly] ([evf], [betu]) VALUES (3, N'C')
INSERT [dbo].[osztaly] ([evf], [betu]) VALUES (5, N'A')
INSERT [dbo].[osztaly] ([evf], [betu]) VALUES (5, N'B')
GO
SET IDENTITY_INSERT [dbo].[tanar] ON 

INSERT [dbo].[tanar] ([kod], [nev], [belepes], [aktiv]) VALUES (1, N'Kupcsik Ilona', CAST(N'1990-10-10' AS Date), 1)
INSERT [dbo].[tanar] ([kod], [nev], [belepes], [aktiv]) VALUES (3, N'Csolti Péter', CAST(N'1990-10-20' AS Date), 1)
SET IDENTITY_INSERT [dbo].[tanar] OFF
GO
INSERT [dbo].[kepes] ([tanar], [tant]) VALUES (1, N'FIZ5 ')
INSERT [dbo].[kepes] ([tanar], [tant]) VALUES (1, N'MAT3 ')
INSERT [dbo].[kepes] ([tanar], [tant]) VALUES (1, N'MAT5 ')
INSERT [dbo].[kepes] ([tanar], [tant]) VALUES (3, N'INFO ')
INSERT [dbo].[kepes] ([tanar], [tant]) VALUES (3, N'TÖRT3')
GO
SET IDENTITY_INSERT [dbo].[diak] ON 

INSERT [dbo].[diak] ([azon], [nev], [evf], [betu]) VALUES (101, N'XV', 3, N'A')
INSERT [dbo].[diak] ([azon], [nev], [evf], [betu]) VALUES (102, N'ZÉ', 5, N'B')
SET IDENTITY_INSERT [dbo].[diak] OFF
GO
INSERT [dbo].[tanit] ([evf], [betu], [tant], [tanar]) VALUES (3, N'A', N'MAT3 ', 1)
INSERT [dbo].[tanit] ([evf], [betu], [tant], [tanar]) VALUES (3, N'A', N'RAJZ ', NULL)
INSERT [dbo].[tanit] ([evf], [betu], [tant], [tanar]) VALUES (3, N'A', N'TÖRT3', NULL)
INSERT [dbo].[tanit] ([evf], [betu], [tant], [tanar]) VALUES (3, N'B', N'MAT3 ', 1)
INSERT [dbo].[tanit] ([evf], [betu], [tant], [tanar]) VALUES (3, N'B', N'RAJZ ', NULL)
INSERT [dbo].[tanit] ([evf], [betu], [tant], [tanar]) VALUES (3, N'B', N'TÖRT3', NULL)
INSERT [dbo].[tanit] ([evf], [betu], [tant], [tanar]) VALUES (3, N'C', N'MAT3 ', 1)
INSERT [dbo].[tanit] ([evf], [betu], [tant], [tanar]) VALUES (3, N'C', N'RAJZ ', NULL)
INSERT [dbo].[tanit] ([evf], [betu], [tant], [tanar]) VALUES (3, N'C', N'TÖRT3', NULL)
INSERT [dbo].[tanit] ([evf], [betu], [tant], [tanar]) VALUES (5, N'A', N'ANG5 ', NULL)
INSERT [dbo].[tanit] ([evf], [betu], [tant], [tanar]) VALUES (5, N'A', N'FIZ5 ', NULL)
INSERT [dbo].[tanit] ([evf], [betu], [tant], [tanar]) VALUES (5, N'A', N'INFO ', 3)
INSERT [dbo].[tanit] ([evf], [betu], [tant], [tanar]) VALUES (5, N'A', N'MAT5 ', 1)
INSERT [dbo].[tanit] ([evf], [betu], [tant], [tanar]) VALUES (5, N'B', N'ANG5 ', NULL)
INSERT [dbo].[tanit] ([evf], [betu], [tant], [tanar]) VALUES (5, N'B', N'FIZ5 ', NULL)
INSERT [dbo].[tanit] ([evf], [betu], [tant], [tanar]) VALUES (5, N'B', N'INFO ', NULL)
INSERT [dbo].[tanit] ([evf], [betu], [tant], [tanar]) VALUES (5, N'B', N'MAT5 ', 1)
GO
SET IDENTITY_INSERT [dbo].[jegytipus] ON 

INSERT [dbo].[jegytipus] ([tip], [elnev], [szorzo]) VALUES (1, N'röpdolgozat', 1)
INSERT [dbo].[jegytipus] ([tip], [elnev], [szorzo]) VALUES (2, N'nagydolgozat', 3)
INSERT [dbo].[jegytipus] ([tip], [elnev], [szorzo]) VALUES (3, N'házi feladat', 2)
INSERT [dbo].[jegytipus] ([tip], [elnev], [szorzo]) VALUES (4, N'órai munka', 1)
SET IDENTITY_INSERT [dbo].[jegytipus] OFF
GO
INSERT [dbo].[terem] ([tszam], [ferohely]) VALUES (111, 20)
INSERT [dbo].[terem] ([tszam], [ferohely]) VALUES (222, 30)
INSERT [dbo].[terem] ([tszam], [ferohely]) VALUES (333, 120)
GO
INSERT [dbo].[orarend] ([evf], [betu], [nap], [ora], [tant], [terem]) VALUES (3, N'A', 1, 4, N'MAT3 ', 111)
INSERT [dbo].[orarend] ([evf], [betu], [nap], [ora], [tant], [terem]) VALUES (3, N'A', 1, 5, N'MAT3 ', 111)
INSERT [dbo].[orarend] ([evf], [betu], [nap], [ora], [tant], [terem]) VALUES (5, N'A', 1, 2, N'MAT5 ', 222)
GO
