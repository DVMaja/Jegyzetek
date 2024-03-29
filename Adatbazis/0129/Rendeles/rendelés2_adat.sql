USE [rendelés2]
-- feltöltés:
-- az alapszkript után így futtatható
-- (a teljes szkript utáni feltöltés esetén csak a triggerek kikapcsolását követően futtatandó ld. lentebb)
GO
INSERT [dbo].[Anyag] ([azonosító], [a_név], [mért_egys], [készlet], [átl_ár]) VALUES (111, N'egyes', N'kg   ', CAST(14.00 AS Decimal(18, 2)), 150.0000)
GO
INSERT [dbo].[Anyag] ([azonosító], [a_név], [mért_egys], [készlet], [átl_ár]) VALUES (222, N'kettes', N'kg   ', CAST(1.96 AS Decimal(18, 2)), 2500.0000)
GO
INSERT [dbo].[Anyag] ([azonosító], [a_név], [mért_egys], [készlet], [átl_ár]) VALUES (333, N'hármas', N'l    ', CAST(0.00 AS Decimal(18, 2)), 0.0000)
GO
INSERT [dbo].[Termék] ([kód], [t_név], [akt_ár]) VALUES (1, N'elso', 1100.0000)
GO
INSERT [dbo].[Termék] ([kód], [t_név], [akt_ár]) VALUES (2, N'másod', 5000.0000)
GO
INSERT [dbo].[Termék] ([kód], [t_név], [akt_ár]) VALUES (3, N'harmad', 3200.0000)
GO
INSERT [dbo].[Szerkezet] ([kód], [azonosító], [menny]) VALUES (1, 111, CAST(1.50 AS Decimal(14, 2)))
GO
INSERT [dbo].[Szerkezet] ([kód], [azonosító], [menny]) VALUES (1, 222, CAST(0.01 AS Decimal(14, 2)))
GO
INSERT [dbo].[Szerkezet] ([kód], [azonosító], [menny]) VALUES (2, 222, CAST(0.10 AS Decimal(14, 2)))
GO
INSERT [dbo].[Szerkezet] ([kód], [azonosító], [menny]) VALUES (3, 222, CAST(0.20 AS Decimal(14, 2)))
GO
INSERT [dbo].[Szerkezet] ([kód], [azonosító], [menny]) VALUES (3, 333, CAST(2.00 AS Decimal(14, 2)))
GO
INSERT [dbo].[Beszerzés] ([dátum], [azonosító], [mennyiség], [be_ár]) VALUES (CAST(N'2019-03-01' AS Date), 111, CAST(10.00 AS Decimal(16, 2)), 100.0000)
GO
INSERT [dbo].[Beszerzés] ([dátum], [azonosító], [mennyiség], [be_ár]) VALUES (CAST(N'2019-03-30' AS Date), 111, CAST(10.00 AS Decimal(16, 2)), 200.0000)
GO
INSERT [dbo].[Beszerzés] ([dátum], [azonosító], [mennyiség], [be_ár]) VALUES (CAST(N'2019-04-11' AS Date), 222, CAST(2.00 AS Decimal(16, 2)), 2500.0000)
GO
INSERT [dbo].[Árvált] ([kód], [mikor], [régi_ár]) VALUES (1, CAST(N'2019-03-22T14:29:50.087' AS DateTime), 1200.0000)
GO
INSERT [dbo].[Partner] ([partner], [p_név], [irsz], [hely], [utca], [tel]) VALUES (11, N'Ez                                      ', N'1111      ', N'budapest                                ', N'fgh                           ', N'123456         ')
GO
INSERT [dbo].[Partner] ([partner], [p_név], [irsz], [hely], [utca], [tel]) VALUES (22, N'Az                                      ', N'1212      ', N'Budapest                                ', N'ijk                           ', N'55555          ')
GO
INSERT [dbo].[Engedmény] ([százalék], [határ]) VALUES (0, 0.0000)
GO
INSERT [dbo].[Engedmény] ([százalék], [határ]) VALUES (5, 11000.0000)
GO
INSERT [dbo].[Engedmény] ([százalék], [határ]) VALUES (10, 25000.0000)
GO
INSERT [dbo].[Rend_fej] ([rendszám], [kelt], [hat_idő], [partner], [engedmény]) VALUES (N'r111                ', CAST(N'2019-04-30T00:00:00.000' AS DateTime), CAST(N'2019-05-31T00:00:00.000' AS DateTime), 11, 0)
GO
INSERT [dbo].[Rend_fej] ([rendszám], [kelt], [hat_idő], [partner], [engedmény]) VALUES (N'r222                ', CAST(N'2019-04-01T00:00:00.000' AS DateTime), CAST(N'2019-05-11T00:00:00.000' AS DateTime), 22, 0)
GO
INSERT [dbo].[Rend_fej] ([rendszám], [kelt], [hat_idő], [partner], [engedmény]) VALUES (N'r333                ', CAST(N'2019-05-02T00:00:00.000' AS DateTime), CAST(N'2019-06-10T00:00:00.000' AS DateTime), 22, 5)
GO
INSERT [dbo].[Rend_tétel] ([rendszám], [kód], [r_menny], [teljesítve]) VALUES (N'r111                ', 1, 3, 2)
GO
INSERT [dbo].[Rend_tétel] ([rendszám], [kód], [r_menny], [teljesítve]) VALUES (N'r222                ', 1, 2, 1)
GO
INSERT [dbo].[Rend_tétel] ([rendszám], [kód], [r_menny], [teljesítve]) VALUES (N'r333                ', 1, 1, 1)
GO
INSERT [dbo].[Rend_tétel] ([rendszám], [kód], [r_menny], [teljesítve]) VALUES (N'r333                ', 2, 2, 0)
GO
INSERT [dbo].[Számla] ([szlaszám], [kelt]) VALUES (N'szla55              ', CAST(N'2019-05-22T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[Száll_fej] ([szlevél], [kelt], [szlaszám]) VALUES (N'sz111               ', CAST(N'2019-04-20T00:00:00.000' AS DateTime), NULL)
GO
INSERT [dbo].[Száll_fej] ([szlevél], [kelt], [szlaszám]) VALUES (N'sz555               ', CAST(N'2019-05-20T00:00:00.000' AS DateTime), N'szla55              ')
GO
INSERT [dbo].[Száll_tétel] ([szlevél], [sorszám], [rendszám], [kód], [sz_menny]) VALUES (N'sz111               ', 1, N'r222                ', 1, 1)
GO
INSERT [dbo].[Száll_tétel] ([szlevél], [sorszám], [rendszám], [kód], [sz_menny]) VALUES (N'sz111               ', 2, N'r333                ', 1, 1)
GO
INSERT [dbo].[Száll_tétel] ([szlevél], [sorszám], [rendszám], [kód], [sz_menny]) VALUES (N'sz555               ', 1, N'r111                ', 1, 2)
GO
INSERT [dbo].[Minősítés] ([alsó], [szöveg]) VALUES (10000, N'drága               ')
GO
INSERT [dbo].[Minősítés] ([alsó], [szöveg]) VALUES (5000, N'közepes             ')
GO
INSERT [dbo].[Minősítés] ([alsó], [szöveg]) VALUES (0, N'olcsó               ')
GO

-- teljes szkript után az adatfelvitel előtt!
-- biz. triggerek kikapcsolása:
--alter table beszerzés disable trigger készlet
--alter table termék disable trigger árváltozás
--alter table száll_tétel disable trigger új_száll_tétel
-- insert parancsok futtatása (adatfelvitel)
-- majd a triggerek visszakapcsolása:
--alter table beszerzés enable trigger készlet
--alter table termék enable trigger árváltozás
--alter table száll_tétel enable trigger új_száll_tétel