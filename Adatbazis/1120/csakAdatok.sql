USE [Dalok]
GO
use DALOK_jo
SET IDENTITY_INSERT [dbo].[mufaj] ON 

INSERT [dbo].[mufaj] ([id], [elnevezes]) VALUES (12, N'alternatív rock')
INSERT [dbo].[mufaj] ([id], [elnevezes]) VALUES (14, N'elektropop')
INSERT [dbo].[mufaj] ([id], [elnevezes]) VALUES (13, N'pop zene')
INSERT [dbo].[mufaj] ([id], [elnevezes]) VALUES (10, N'pop-rock')
INSERT [dbo].[mufaj] ([id], [elnevezes]) VALUES (11, N'rock')
SET IDENTITY_INSERT [dbo].[mufaj] OFF
GO
SET IDENTITY_INSERT [dbo].[dal] ON 

INSERT [dbo].[dal] ([azon], [cim], [keletkezes], [mufaj], [eredeti]) VALUES (1000, N'Radio GaGa', CAST(N'1984-11-22' AS Date), 10, NULL)
INSERT [dbo].[dal] ([azon], [cim], [keletkezes], [mufaj], [eredeti]) VALUES (1001, N'Radio GaGa', CAST(N'2022-10-10' AS Date), 10, 1000)
INSERT [dbo].[dal] ([azon], [cim], [keletkezes], [mufaj], [eredeti]) VALUES (1002, N'Gossip', CAST(N'2023-01-13' AS Date), 12, NULL)
INSERT [dbo].[dal] ([azon], [cim], [keletkezes], [mufaj], [eredeti]) VALUES (1003, N'Honey', CAST(N'2023-09-01' AS Date), 12, NULL)
INSERT [dbo].[dal] ([azon], [cim], [keletkezes], [mufaj], [eredeti]) VALUES (1004, N'Kool Kids', CAST(N'2023-01-20' AS Date), 10, NULL)
INSERT [dbo].[dal] ([azon], [cim], [keletkezes], [mufaj], [eredeti]) VALUES (1005, N'Gasoline', CAST(N'2023-01-20' AS Date), 11, NULL)
INSERT [dbo].[dal] ([azon], [cim], [keletkezes], [mufaj], [eredeti]) VALUES (1006, N'Cleopatra', CAST(N'2022-06-10' AS Date), 13, NULL)
INSERT [dbo].[dal] ([azon], [cim], [keletkezes], [mufaj], [eredeti]) VALUES (1007, N' Ernten Was Wir Säen', CAST(N'2009-08-07' AS Date), 11, NULL)
INSERT [dbo].[dal] ([azon], [cim], [keletkezes], [mufaj], [eredeti]) VALUES (1008, N'Sandmann', CAST(N'2009-08-07' AS Date), 11, NULL)
INSERT [dbo].[dal] ([azon], [cim], [keletkezes], [mufaj], [eredeti]) VALUES (1009, N'Labyrinth', CAST(N'2009-08-07' AS Date), 11, NULL)
INSERT [dbo].[dal] ([azon], [cim], [keletkezes], [mufaj], [eredeti]) VALUES (1010, N'Träumst du', CAST(N'2006-03-24' AS Date), 11, NULL)
INSERT [dbo].[dal] ([azon], [cim], [keletkezes], [mufaj], [eredeti]) VALUES (1011, N'Zwischen uns', CAST(N'2015-01-23' AS Date), 11, NULL)
INSERT [dbo].[dal] ([azon], [cim], [keletkezes], [mufaj], [eredeti]) VALUES (1012, N'Supposed To Be', CAST(N'2016-11-25' AS Date), 14, NULL)
INSERT [dbo].[dal] ([azon], [cim], [keletkezes], [mufaj], [eredeti]) VALUES (1013, N'Too Loud', CAST(N'2016-11-25' AS Date), 14, NULL)
INSERT [dbo].[dal] ([azon], [cim], [keletkezes], [mufaj], [eredeti]) VALUES (1014, N'Pulse', CAST(N'2016-11-25' AS Date), 14, NULL)
INSERT [dbo].[dal] ([azon], [cim], [keletkezes], [mufaj], [eredeti]) VALUES (1015, N'Demons', CAST(N'2016-11-25' AS Date), 14, NULL)
INSERT [dbo].[dal] ([azon], [cim], [keletkezes], [mufaj], [eredeti]) VALUES (1016, N'Warrior of the Mind', CAST(N'2022-12-24' AS Date), 12, NULL)
INSERT [dbo].[dal] ([azon], [cim], [keletkezes], [mufaj], [eredeti]) VALUES (1017, N'My Goodbye', CAST(N'2023-01-26' AS Date), 13, NULL)
INSERT [dbo].[dal] ([azon], [cim], [keletkezes], [mufaj], [eredeti]) VALUES (1018, N'Vengo dalla luna', CAST(N'2017-12-17' AS Date), 11, NULL)
INSERT [dbo].[dal] ([azon], [cim], [keletkezes], [mufaj], [eredeti]) VALUES (1023, N'Gossip', CAST(N'2023-09-09' AS Date), 12, 1002)
INSERT [dbo].[dal] ([azon], [cim], [keletkezes], [mufaj], [eredeti]) VALUES (1024, N'Warrior of the Mind', CAST(N'2023-02-19' AS Date), 12, 1017)
INSERT [dbo].[dal] ([azon], [cim], [keletkezes], [mufaj], [eredeti]) VALUES (1025, N'Dont Wanna Sleep', CAST(N'2023-01-20' AS Date), 11, NULL)
INSERT [dbo].[dal] ([azon], [cim], [keletkezes], [mufaj], [eredeti]) VALUES (1026, N'Labyrinth', CAST(N'2013-09-14' AS Date), 11, 1009)
INSERT [dbo].[dal] ([azon], [cim], [keletkezes], [mufaj], [eredeti]) VALUES (1027, N'Gossip', CAST(N'2023-05-16' AS Date), 11, 1002)
INSERT [dbo].[dal] ([azon], [cim], [keletkezes], [mufaj], [eredeti]) VALUES (1028, N'Dont Wanna Sleep', CAST(N'2023-05-16' AS Date), 11, 1025)
SET IDENTITY_INSERT [dbo].[dal] OFF
GO
SET IDENTITY_INSERT [dbo].[szem_egy] ON 

INSERT [dbo].[szem_egy] ([kod], [nev], [kezd_ev], [vege_ev], [jelzes]) VALUES (100, N'Queen', 1970, NULL, N'E')
INSERT [dbo].[szem_egy] ([kod], [nev], [kezd_ev], [vege_ev], [jelzes]) VALUES (101, N'Freddie Mercury', 1969, NULL, N'S')
INSERT [dbo].[szem_egy] ([kod], [nev], [kezd_ev], [vege_ev], [jelzes]) VALUES (102, N'Adam Lambert', 2010, NULL, N'S')
INSERT [dbo].[szem_egy] ([kod], [nev], [kezd_ev], [vege_ev], [jelzes]) VALUES (103, N'Maneskin', 2016, NULL, N'E')
INSERT [dbo].[szem_egy] ([kod], [nev], [kezd_ev], [vege_ev], [jelzes]) VALUES (104, N'Oomph!', 1989, NULL, N'E')
INSERT [dbo].[szem_egy] ([kod], [nev], [kezd_ev], [vege_ev], [jelzes]) VALUES (105, N'Icon For Hire', 2007, NULL, N'E')
INSERT [dbo].[szem_egy] ([kod], [nev], [kezd_ev], [vege_ev], [jelzes]) VALUES (106, N'Eisbrecher', 2003, NULL, N'E')
INSERT [dbo].[szem_egy] ([kod], [nev], [kezd_ev], [vege_ev], [jelzes]) VALUES (107, N'Annapantsu', 2011, NULL, N'S')
INSERT [dbo].[szem_egy] ([kod], [nev], [kezd_ev], [vege_ev], [jelzes]) VALUES (108, N'Kareline', 2008, NULL, N'S')
INSERT [dbo].[szem_egy] ([kod], [nev], [kezd_ev], [vege_ev], [jelzes]) VALUES (109, N'Damiano David', 2016, NULL, N'S')
INSERT [dbo].[szem_egy] ([kod], [nev], [kezd_ev], [vege_ev], [jelzes]) VALUES (110, N'Ethan Torchio', 2016, NULL, N'S')
INSERT [dbo].[szem_egy] ([kod], [nev], [kezd_ev], [vege_ev], [jelzes]) VALUES (111, N'Thomas Raggi', 2016, NULL, N'S')
INSERT [dbo].[szem_egy] ([kod], [nev], [kezd_ev], [vege_ev], [jelzes]) VALUES (112, N'Victoria De Angelis', 2016, NULL, N'S')
INSERT [dbo].[szem_egy] ([kod], [nev], [kezd_ev], [vege_ev], [jelzes]) VALUES (113, N'Thomas Raggi', 2016, NULL, N'S')
INSERT [dbo].[szem_egy] ([kod], [nev], [kezd_ev], [vege_ev], [jelzes]) VALUES (114, N'Ariel Bloomer', 2007, NULL, N'S')
INSERT [dbo].[szem_egy] ([kod], [nev], [kezd_ev], [vege_ev], [jelzes]) VALUES (115, N'Shawn Jump', 2007, NULL, N'S')
INSERT [dbo].[szem_egy] ([kod], [nev], [kezd_ev], [vege_ev], [jelzes]) VALUES (116, N'Joshua Davis', 2007, NULL, N'S')
INSERT [dbo].[szem_egy] ([kod], [nev], [kezd_ev], [vege_ev], [jelzes]) VALUES (117, N'Adam Kronshagen', 2007, NULL, N'S')
INSERT [dbo].[szem_egy] ([kod], [nev], [kezd_ev], [vege_ev], [jelzes]) VALUES (118, N'Josh kincheloe', 2013, NULL, N'S')
INSERT [dbo].[szem_egy] ([kod], [nev], [kezd_ev], [vege_ev], [jelzes]) VALUES (119, N'Dero', 1989, NULL, N'S')
INSERT [dbo].[szem_egy] ([kod], [nev], [kezd_ev], [vege_ev], [jelzes]) VALUES (120, N'Crap', 1989, NULL, N'S')
INSERT [dbo].[szem_egy] ([kod], [nev], [kezd_ev], [vege_ev], [jelzes]) VALUES (121, N'Flux', 1989, NULL, N'S')
INSERT [dbo].[szem_egy] ([kod], [nev], [kezd_ev], [vege_ev], [jelzes]) VALUES (122, N'Alexx Wesselsky', 2003, NULL, N'S')
INSERT [dbo].[szem_egy] ([kod], [nev], [kezd_ev], [vege_ev], [jelzes]) VALUES (123, N' Noel Pix', 2003, NULL, N'S')
INSERT [dbo].[szem_egy] ([kod], [nev], [kezd_ev], [vege_ev], [jelzes]) VALUES (124, N'Jürgen Plangger', 2003, NULL, N'S')
SET IDENTITY_INSERT [dbo].[szem_egy] OFF
GO
SET IDENTITY_INSERT [dbo].[szerep] ON 

INSERT [dbo].[szerep] ([id], [megnevezes], [jogdijas]) VALUES (50, N'zeneszerző', 1)
INSERT [dbo].[szerep] ([id], [megnevezes], [jogdijas]) VALUES (51, N'hangszerelő', 0)
INSERT [dbo].[szerep] ([id], [megnevezes], [jogdijas]) VALUES (52, N'rap betét', 0)
INSERT [dbo].[szerep] ([id], [megnevezes], [jogdijas]) VALUES (53, N'gitár betét', 0)
INSERT [dbo].[szerep] ([id], [megnevezes], [jogdijas]) VALUES (54, N'extra dobszoló', 0)
INSERT [dbo].[szerep] ([id], [megnevezes], [jogdijas]) VALUES (55, N'klasszikus feldolgozás', 0)
SET IDENTITY_INSERT [dbo].[szerep] OFF
GO
SET IDENTITY_INSERT [dbo].[alkotja] ON 

INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (500, 101, 1000, 50)
INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (505, 101, 1000, 52)
INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (509, 107, 1006, 50)
INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (510, 107, 1006, 52)
INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (512, 109, 1002, 52)
INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (511, 109, 1003, 52)
INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (513, 109, 1004, 52)
INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (514, 109, 1005, 52)
INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (515, 109, 1025, 52)
INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (517, 110, 1002, 54)
INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (516, 110, 1003, 54)
INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (518, 110, 1004, 54)
INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (519, 110, 1005, 54)
INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (520, 110, 1025, 54)
INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (522, 111, 1002, 53)
INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (521, 111, 1003, 53)
INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (523, 111, 1004, 53)
INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (524, 111, 1005, 53)
INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (525, 111, 1025, 53)
INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (527, 112, 1002, 55)
INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (526, 112, 1003, 55)
INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (528, 112, 1004, 55)
INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (529, 112, 1005, 55)
INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (530, 112, 1025, 55)
INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (531, 114, 1012, 50)
INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (532, 114, 1012, 52)
INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (533, 114, 1013, 50)
INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (534, 114, 1013, 52)
INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (535, 114, 1014, 50)
INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (536, 114, 1014, 52)
INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (537, 114, 1015, 50)
INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (538, 114, 1015, 52)
INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (539, 115, 1012, 53)
INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (540, 115, 1013, 53)
INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (541, 115, 1014, 53)
INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (542, 115, 1015, 53)
INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (543, 119, 1007, 52)
INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (544, 119, 1008, 52)
INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (545, 119, 1009, 52)
INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (546, 120, 1007, 53)
INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (547, 120, 1008, 53)
INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (548, 120, 1009, 53)
INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (549, 121, 1007, 54)
INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (550, 121, 1008, 54)
INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (551, 121, 1009, 54)
INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (552, 122, 1011, 52)
INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (553, 123, 1011, 54)
INSERT [dbo].[alkotja] ([alk_id], [szemely], [dal], [szerep]) VALUES (554, 124, 1011, 53)
SET IDENTITY_INSERT [dbo].[alkotja] OFF
GO
INSERT [dbo].[platform] ([platform]) VALUES (N'bakelit         ')
INSERT [dbo].[platform] ([platform]) VALUES (N'CD              ')
INSERT [dbo].[platform] ([platform]) VALUES (N'DVD             ')
INSERT [dbo].[platform] ([platform]) VALUES (N'laptapír.hu     ')
INSERT [dbo].[platform] ([platform]) VALUES (N'Pirate Bay      ')
INSERT [dbo].[platform] ([platform]) VALUES (N'steaming        ')
INSERT [dbo].[platform] ([platform]) VALUES (N'élőadás        ')
GO
INSERT [dbo].[megjelent] ([dal], [datum], [platform], [beszerzes]) VALUES (1000, CAST(N'2020-01-01' AS Date), N'CD              ', CAST(N'2022-01-01' AS Date))
INSERT [dbo].[megjelent] ([dal], [datum], [platform], [beszerzes]) VALUES (1002, CAST(N'2023-01-13' AS Date), N'bakelit         ', CAST(N'2023-11-11' AS Date))
INSERT [dbo].[megjelent] ([dal], [datum], [platform], [beszerzes]) VALUES (1003, CAST(N'2023-01-13' AS Date), N'steaming        ', CAST(N'2023-11-11' AS Date))
INSERT [dbo].[megjelent] ([dal], [datum], [platform], [beszerzes]) VALUES (1004, CAST(N'2023-01-20' AS Date), N'laptapír.hu     ', CAST(N'2023-11-11' AS Date))
INSERT [dbo].[megjelent] ([dal], [datum], [platform], [beszerzes]) VALUES (1005, CAST(N'2023-01-13' AS Date), N'steaming        ', CAST(N'2023-11-11' AS Date))
INSERT [dbo].[megjelent] ([dal], [datum], [platform], [beszerzes]) VALUES (1006, CAST(N'2023-01-13' AS Date), N'Pirate Bay      ', CAST(N'2023-11-11' AS Date))
INSERT [dbo].[megjelent] ([dal], [datum], [platform], [beszerzes]) VALUES (1007, CAST(N'2023-01-13' AS Date), N'steaming        ', CAST(N'2023-11-11' AS Date))
INSERT [dbo].[megjelent] ([dal], [datum], [platform], [beszerzes]) VALUES (1008, CAST(N'2023-01-13' AS Date), N'steaming        ', CAST(N'2023-11-11' AS Date))
INSERT [dbo].[megjelent] ([dal], [datum], [platform], [beszerzes]) VALUES (1009, CAST(N'2023-01-13' AS Date), N'Pirate Bay      ', CAST(N'2023-11-11' AS Date))
INSERT [dbo].[megjelent] ([dal], [datum], [platform], [beszerzes]) VALUES (1010, CAST(N'2023-01-13' AS Date), N'steaming        ', CAST(N'2023-11-11' AS Date))
INSERT [dbo].[megjelent] ([dal], [datum], [platform], [beszerzes]) VALUES (1011, CAST(N'2023-01-13' AS Date), N'CD              ', CAST(N'2023-11-11' AS Date))
INSERT [dbo].[megjelent] ([dal], [datum], [platform], [beszerzes]) VALUES (1012, CAST(N'2023-01-13' AS Date), N'CD              ', CAST(N'2023-11-11' AS Date))
INSERT [dbo].[megjelent] ([dal], [datum], [platform], [beszerzes]) VALUES (1013, CAST(N'2023-01-13' AS Date), N'steaming        ', CAST(N'2023-11-11' AS Date))
INSERT [dbo].[megjelent] ([dal], [datum], [platform], [beszerzes]) VALUES (1014, CAST(N'2023-01-13' AS Date), N'Pirate Bay      ', CAST(N'2023-11-11' AS Date))
INSERT [dbo].[megjelent] ([dal], [datum], [platform], [beszerzes]) VALUES (1015, CAST(N'2023-01-13' AS Date), N'bakelit         ', CAST(N'2023-11-11' AS Date))
INSERT [dbo].[megjelent] ([dal], [datum], [platform], [beszerzes]) VALUES (1016, CAST(N'2023-01-13' AS Date), N'laptapír.hu     ', CAST(N'2023-11-11' AS Date))
INSERT [dbo].[megjelent] ([dal], [datum], [platform], [beszerzes]) VALUES (1017, CAST(N'2023-01-13' AS Date), N'steaming        ', CAST(N'2023-11-11' AS Date))
INSERT [dbo].[megjelent] ([dal], [datum], [platform], [beszerzes]) VALUES (1018, CAST(N'2023-01-13' AS Date), N'CD              ', CAST(N'2023-11-11' AS Date))
INSERT [dbo].[megjelent] ([dal], [datum], [platform], [beszerzes]) VALUES (1024, CAST(N'2023-01-13' AS Date), N'CD              ', CAST(N'2023-11-11' AS Date))
INSERT [dbo].[megjelent] ([dal], [datum], [platform], [beszerzes]) VALUES (1025, CAST(N'2023-01-13' AS Date), N'steaming        ', CAST(N'2023-11-11' AS Date))
INSERT [dbo].[megjelent] ([dal], [datum], [platform], [beszerzes]) VALUES (1026, CAST(N'2023-01-13' AS Date), N'bakelit         ', CAST(N'2023-11-11' AS Date))
INSERT [dbo].[megjelent] ([dal], [datum], [platform], [beszerzes]) VALUES (1027, CAST(N'2023-01-13' AS Date), N'Pirate Bay      ', CAST(N'2023-11-11' AS Date))
INSERT [dbo].[megjelent] ([dal], [datum], [platform], [beszerzes]) VALUES (1028, CAST(N'2023-01-13' AS Date), N'CD              ', CAST(N'2023-11-11' AS Date))
GO
INSERT [dbo].[tagja] ([egyuttes], [szemely], [datumtol], [datumig]) VALUES (103, 109, CAST(N'2016-01-01' AS Date), NULL)
INSERT [dbo].[tagja] ([egyuttes], [szemely], [datumtol], [datumig]) VALUES (103, 110, CAST(N'2016-01-01' AS Date), NULL)
INSERT [dbo].[tagja] ([egyuttes], [szemely], [datumtol], [datumig]) VALUES (103, 111, CAST(N'2016-01-01' AS Date), NULL)
INSERT [dbo].[tagja] ([egyuttes], [szemely], [datumtol], [datumig]) VALUES (103, 112, CAST(N'2016-01-01' AS Date), NULL)
INSERT [dbo].[tagja] ([egyuttes], [szemely], [datumtol], [datumig]) VALUES (104, 119, CAST(N'1989-01-01' AS Date), NULL)
INSERT [dbo].[tagja] ([egyuttes], [szemely], [datumtol], [datumig]) VALUES (104, 120, CAST(N'1989-01-01' AS Date), NULL)
INSERT [dbo].[tagja] ([egyuttes], [szemely], [datumtol], [datumig]) VALUES (104, 121, CAST(N'1989-01-01' AS Date), NULL)
INSERT [dbo].[tagja] ([egyuttes], [szemely], [datumtol], [datumig]) VALUES (105, 114, CAST(N'2007-01-01' AS Date), NULL)
INSERT [dbo].[tagja] ([egyuttes], [szemely], [datumtol], [datumig]) VALUES (105, 115, CAST(N'2007-01-01' AS Date), NULL)
INSERT [dbo].[tagja] ([egyuttes], [szemely], [datumtol], [datumig]) VALUES (105, 116, CAST(N'2007-01-01' AS Date), CAST(N'2009-01-01' AS Date))
INSERT [dbo].[tagja] ([egyuttes], [szemely], [datumtol], [datumig]) VALUES (105, 116, CAST(N'2010-01-01' AS Date), CAST(N'2013-01-01' AS Date))
INSERT [dbo].[tagja] ([egyuttes], [szemely], [datumtol], [datumig]) VALUES (105, 117, CAST(N'2007-01-01' AS Date), CAST(N'2015-01-01' AS Date))
INSERT [dbo].[tagja] ([egyuttes], [szemely], [datumtol], [datumig]) VALUES (105, 118, CAST(N'2013-01-01' AS Date), CAST(N'2016-01-01' AS Date))
INSERT [dbo].[tagja] ([egyuttes], [szemely], [datumtol], [datumig]) VALUES (105, 118, CAST(N'2017-01-01' AS Date), CAST(N'2019-01-01' AS Date))
INSERT [dbo].[tagja] ([egyuttes], [szemely], [datumtol], [datumig]) VALUES (106, 122, CAST(N'2003-01-01' AS Date), NULL)
INSERT [dbo].[tagja] ([egyuttes], [szemely], [datumtol], [datumig]) VALUES (106, 123, CAST(N'2003-01-01' AS Date), CAST(N'2013-01-01' AS Date))
INSERT [dbo].[tagja] ([egyuttes], [szemely], [datumtol], [datumig]) VALUES (106, 124, CAST(N'2003-01-01' AS Date), CAST(N'2006-01-01' AS Date))
INSERT [dbo].[tagja] ([egyuttes], [szemely], [datumtol], [datumig]) VALUES (106, 123, CAST(N'2020-01-01' AS Date), NULL)
INSERT [dbo].[tagja] ([egyuttes], [szemely], [datumtol], [datumig]) VALUES (106, 124, CAST(N'2008-01-01' AS Date), CAST(N'2010-01-01' AS Date))
GO
