/*
create table Pobocka(
id int PRIMARY KEY,
Adresa Varchar(20),
Mesto Varchar(20)
);
create table AutoModel(
id int PRIMARY KEY,
Znacka Varchar(10) NOT NULL, 
Model Varchar(20) NOT NULL,
Motor float,
Palivo Char(6),
Prevodovka Char,
Klima Char,
CenaDen int NOT NULL,
UNIQUE KEY thekey (Znacka,Model)
);
create table Auto(
SPZ Varchar(7) PRIMARY KEY,
idPobocka int,
idAutoModel int,
FOREIGN KEY (idPobocka) REFERENCES Pobocka(id)on delete SET NULL on update cascade,
FOREIGN KEY (idAutoModel)  REFERENCES AutoModel(id) on delete SET NULL on update cascade
);
insert into AutoModel values (1,'AUDI','A4 Combi',2.0,'diesel','A','A',65);
insert into AutoModel values (2,'BMW','6 650 XDrive',5.0,'benzin','A','A',120);
insert into AutoModel values (3,'Fiat','Ducato',2.2,'diesel','M','A',99);
insert into AutoModel values (4,'Hyundai','i30 Combi',1.4,'diesel','M','N',45);
insert into AutoModel values (5,'Škoda','120',NULL,'benzin','M','N',20);
insert into AutoModel values (6,'Škoda','Octavia III',1.9,'diesel','M','A',50);
insert into Pobocka values (1,'Farská 2','Žilina');
insert into Pobocka values (2,'Galvaniho 2/A','Bratislava');
insert into Pobocka values (3,'Južná trieda 2/A','Košice');
insert into Auto values ('KE001AB',3,1);
insert into Auto values ('KE002AB',3,5);
insert into Auto values ('KE003AB',3,6);
insert into Auto values ('KE004AB',3,5);
insert into Auto values ('BA123AC',2,1);
insert into Auto values ('BA124AC',2,3);
insert into Auto values ('BA125AC',2,5);
insert into Auto values ('BA126AC',2,4);
insert into Auto values ('BA127AC',2,4);
insert into Auto values ('TN111ZZ',1,1);
insert into Auto values ('TN111ZX',1,4);
insert into Auto values ('TN111ZY',1,6);
insert into Auto values ('KE005AB',1,4);

drop table Auto;
drop table automodel;
drop table pobocka;
*/

-- Napíšte SQL dopyt, ktorý vráti všetky ŠPZ áut s košickou značkou (prefix KE)
select 
	SPZ 
from 
	Auto 
where 
	SPZ like 'KE%';

/*Napíšte SQL dopyt, ktorý zistí počet modelov áut značky Škoda v autopožičovni (modelov,
konkrétnych áut).*/

select 
	pobocka.Adresa,
	count(distinct autoModel.Model) as pocet 
from 
	auto 
    left outer join 
		automodel 
	on 
		auto.idAutoModel=autoModel.id 
    left outer join 
		pobocka on auto.idPobocka=pobocka.id 
where 
	automodel.Znacka like 'Škoda' 
group by 
	auto.idPobocka;
    
/*Napíšte SQL dopyt, ktorý vráti pár (Znacka, PocetModelov), kde Znacka bude značka auta,
a PocetModelov bude počet rôznych modelov, ktoré autopožičovňa ponúka (teda napr. vráti 
páry (Škoda, 2), atď). Zobrazte iba značky, ktoré majú aspoň dva modely.*/    

select 
	Znacka, 
    Count(model) as PocetModelov 
from 
	automodel 
group by 
	znacka 
having 
	Count(*)>=2;
    
/* 
Zobrazte záznamy (Mesto, Znacka, Model), pomocou ktorého si zákazník bude môcť vybrať
model auta poskytovaný v jeho meste (napr. (Košice, Audi, A4 Combi)). Záznamy zoraďte 
podľa mesta, potom podľa značky a nakoniec podľa modelu.
*/
select 
	pobocka.Mesto,
    automodel.Znacka,
    automodel.model 
from 
	auto 
    left outer join 
		automodel 
	on 
		auto.idAutoModel=autoModel.id 
    left outer join 
		pobocka on auto.idPobocka=pobocka.id 
order by 
	pobocka.Mesto,
    automodel.Znacka,
    automodel.model;
    
-- Zistite, koľko áut značky Škoda je v Košiciach.
select 
	count(automodel.Model) as pocet 
from 
	automodel 
    left outer join 
		auto 
	on 
		auto.idAutoModel=autoModel.id 
    left outer join 
		pobocka on auto.idPobocka=pobocka.id 
where 
	pobocka.Mesto='Košice'
group by 
	automodel.Znacka
having 
	automodel.Znacka='Škoda';
    
-- Nájdite ŠPZky všetkých kombi áut bez klímy.
select 
	auto.SPZ 
from 
	auto
    left outer join 
		automodel  
	on 
		auto.idAutoModel=autoModel.id 
where 
	automodel.Klima='N' AND 
    automodel.Model like '%Combi';
    
-- Nájdite mestá, v ktorých pobočky ponúkajú najlacnejšie auto z ponuky
select 
	distinct pobocka.Mesto 
from 
    auto 
    left outer join 
		automodel 
	on 
		auto.idAutoModel=autoModel.id 
    left outer join 
		pobocka on auto.idPobocka=pobocka.id
where 
	automodel.CenaDen=(select 
							min(CenaDen) 
					   from 
							automodel);
                            
/*
Zistite značku a model auta, ktoré nie je k dispozícií na žiadnej pobočke. Použite
OUTER JOIN.
*/
select 
	automodel.Znacka,
	automodel.Model 
from 
	automodel 
    left outer join 
		auto 
	on 
		auto.idAutoModel=autoModel.id 
    left outer join 
		pobocka on auto.idPobocka=pobocka.id
where 
	idPobocka is NULL;
    
/*
Napíšte update, ktorý zvýši cenu na deň o 10% u všetkých modelov áut, ktoré majú klímu
(pre overenie, cena BMW stúpne na 132E). Uveďte všetky príkazy, ktoré sú potrebné pre 
splnenie úlohy (sú 2).
*/
/*
SET SQL_SAFE_UPDATES=0;
update automodel set CenaDen=CenaDen*1.1 where Klima='A';
*/
/*
Vytvorte jednoduchý trigger Zametac, ktorý pri zmazaní pobočky zmaže všetky modely áut,
ktoré sa po zmazaní pobočky už nenachádzajú na žiadnej pobočke. Tzn. napr. pri zmazaní  
bratislavskej pobočky má dôjsť aj k zmazaniu modelu Fiat Ducato, pretože auto tejto značky 
bolo iba na bratislavskej pobočke. Dôjde aj k zmazaniu záznamu BMW, pretože ten sa už pred 
zmazaním bratislavskej pobočky nenachádzal na žiadnej pobočke.
*/
delete from pobocka where mesto='Bratislava';
select * from automodel;
delimiter //
CREATE TRIGGER Zametac AFTER DELETE on pobocka
FOR EACH ROW
BEGIN
DELETE FROM automodel
    WHERE automodel.id=(select automodel.id from automodel left outer join auto on automodel.id=auto.idAutoModel where auto.idpobocka is NULL);
END