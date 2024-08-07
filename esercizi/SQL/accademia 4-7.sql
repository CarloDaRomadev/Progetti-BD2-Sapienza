/*accademia 4*/
/*1. Quali sono i cognomi distinti di tutti gli strutturati? */

select distinct p.cognome
from persona as p;

/*2. Quali sono i Ricercatori ( con nome e cognome ) ? */

select p.nome,p.cognome
from persona as p
where p.posizione = 'Ricercatore';

/*3 Quali sono i Professori Associati il cui cognome comincia con la lettera ‘V’ ? */

select p.nome,p.cognome
from persona as p
where p.posizione = 'Professore Associato' and p.cognome like 'V%';

/*4 Quali sono i Professori (sia Associati che Ordinari) il cui cognome comincia con la
lettera ‘V’ ? */

select p.nome,p.cognome
from persona as p
where (p.posizione = 'Professore Associato' or p.posizione = 'Professore Ordinario') and p.cognome like 'V%';

/*5. Quali sono i Progetti già terminati alla data odierna? */

select p.id,p.nome,p.fine
from progetto as p
where p.fine < now();

/*6. Quali sono i nomi di tutti i Progetti ordinati in ordine crescente di data di inizio? */

select p.id,p.nome,p.inizio
from progetto as p
order by p.inizio;

/*7. Quali sono i nomi dei WP ordinati in ordine crescente (per nome)? */

select p.id,p.nome,p.inizio
from progetto as p
order by p.nome asc;

/*8. Quali sono (distinte) le cause di assenza di tutti gli strutturati? */

select distinct a.tipo
from assenza as a
join persona as p on p.id = a.persona;

/*9. Quali sono (distinte) le tipologie di attività di progetto di tutti gli strutturati? */

select distinct a.tipo
from attivitaprogetto as a
join persona as p on p.id = a.persona;

/*10. Quali sono i giorni distinti nei quali del personale ha effettuato attività non pro-
gettuali di tipo ‘Didattica’ ? Dare il risultato in ordine crescente. */

select a.giorno
from attivitanonProgettuale as a
where a.tipo = 'Didattica'
order by giorno asc;

/*accademia 5 */
/* 1. Quali sono il nome, la data di inizio e la data di fine dei WP del progetto di nome
‘Pegasus’ ? */

select wp.nome, wp.inizio, wp.fine
from wp
join progetto as p on wp.progetto = p.id
where p.nome = 'Pegasus';

/*2. Quali sono il nome, il cognome e la posizione degli strutturati che hanno almeno
una attività nel progetto ‘Pegasus’, ordinati per cognome decrescente? */

select distinct p.nome, p.cognome, p.posizione 
from persona as p
join attivitaProgetto as ap on p.id = ap.persona
join progetto as pr on pr.id = ap.progetto
where pr.nome = 'Pegasus'
order by p.cognome desc;

/*3. Quali sono il nome, il cognome e la posizione degli strutturati che hanno più di
una attività nel progetto ‘Pegasus’ ? */ 

select distinct p.nome, p.cognome, p.posizione 
from persona as p
join attivitaProgetto as ap on p.id = ap.persona
join progetto as pr on pr.id = ap.progetto
join attivitaProgetto as ap2 on p.id = ap2.persona
where ap2.progetto = ap.progetto and pr.nome = 'Pegasus'  and ap.giorno <> ap2.giorno;
/* potrebbe essere fatto meglio (non me ne frega ncazzo)*/

/*9. Quali sono il nome e il cognome degli strutturati che nello stesso giorno hanno sia
attività progettuali che attività non progettuali? Si richiede anche di proiettare il
giorno, il nome del progetto, il tipo di attività non progettuali e la durata in ore di
entrambe le attività. */

select distinct p.nome, p.cognome, ap.giorno, pr.nome, anp.tipo, ap.oreDurata as durataP, anp.oreDurata as durataAnonP
from persona as p
join attivitaProgetto as ap on p.id = ap.persona
join attivitaNonProgettuale as anp on p.id = anp.persona
join progetto as pr on ap.progetto = pr.id
where ap.giorno = anp.giorno;

/*10. Quali sono il nome e il cognome degli strutturati che nello stesso giorno sono
assenti e hanno attività progettuali? */

select distinct p.nome, p.cognome
from persona as p
join attivitaProgetto as ap on p.id = ap.persona
join assenza as a on p.id = a.persona
where a.giorno = ap.giorno;

/*11. Quali sono il nome e il cognome degli strutturati che nello stesso giorno sono
assenti e hanno attività progettuali? Si richiede anche di proiettare il giorno, il
nome del progetto, la causa di assenza e la durata in ore della attività progettuale. */

select distinct p.nome, p.cognome, pr.nome, a.giorno, a.tipo, ap.oredurata
from persona as p
join attivitaProgetto as ap on p.id = ap.persona
join assenza as a on p.id = a.persona
join progetto as pr on pr.id = ap.progetto
where a.giorno = ap.giorno;

/*12. Quali sono i WP che hanno lo stesso nome, ma appartengono a progetti diversi? */

select distinct wp1.nome
from wp as wp1
join progetto as p on wp1.progetto = p.id
join wp as wp2 on wp1.nome = wp2.nome
join progetto as p2 on wp2.progetto = p2.id
where p.id <> p2.id;

/*accademia 6 */
/*1. Quanti sono gli strutturati di ogni fascia?*/

select p.posizione, count(p.posizione)
from persona as p
group by p.posizione;

/*2. Quanti sono gli strutturati con stipendio ≥ 40000? */

select count(p.id)
from persona as p
where p.stipendio >= 40000;

/* 3. Quanti sono i progetti già finiti che superano il budget di 50000? */

select count(pr.id)
from progetto as pr
where pr.fine <= now();

/* 4. Qual è la media, il massimo e il minimo delle ore delle attività relative al progetto
‘Pegasus’ ? */

select avg(ap.oredurata), max(ap.oredurata), min(ap.oredurata)
from attivitaProgetto as ap
join progetto as p on ap.progetto = p.id
where p.nome = 'Pegasus';

/*9. Quante ore ‘Ginevra Riva’ ha dedicato ad ogni progetto nel quale ha lavorato? */

select sum(AP.oredurata), pr.nome
from attivitaProgetto as ap
join persona as p on ap.persona = p.id
join progetto as pr on pr.id = ap.progetto
where p.nome = 'Ginevra' and p.cognome = 'Riva'
group by pr.id;

/* 10. Qual è il nome dei progetti su cui lavorano più di due strutturati? */

select pr.nome
from progetto as pr
join attivitaprogetto as attpr on attpr.progetto = pr.id
join persona as p on attpr.persona = p.id
group by pr.nome
having count(attpr.persona) >= 2;

/*11. Quali sono i professori associati che hanno lavorato su più di un progetto?*/

select p.id, p.nome, p.cognome
from progetto as pr
join attivitaprogetto as attpr on attpr.progetto = pr.id
join persona as p on attpr.persona = p.id
where p.posizione = 'Professore Associato'
group by p.id
having count(attpr.persona) >= 2;

/* accademia 7 */
/* 1. Qual è media e deviazione standard degli stipendi per ogni categoria di strutturati? */

/* *//* */

/* 2. Quali sono i ricercatori (tutti gli attributi) con uno stipendio superiore alla media
della loro categoria? */

select *
from persona as p, (select avg(p2.stipendio) as stip, p2.posizione
					from persona as p2
					group by p2.posizione) as stipendioMedio 
where p.posizione = stipendioMedio.posizione and p.stipendio > stipendioMedio.stip
and p.posizione = 'Ricercatore';

/*7. Quali sono i professori ordinari che hanno fatto più assenze per malattia del nu-
mero di assenze medio per malattia dei professori associati? Restituire id, nome e
cognome del professore e il numero di giorni di assenza per malattia. */
with stats as (select count(a4.id) as conto, p.id
			  from assenza as a4
			  join persona as p on a4.persona = p.id
			  where a4.tipo = 'Malattia' and p.posizione = 'Professore Associato'
			  group by p.id),
			  
media as (select avg(stats.conto) as mid
		  from stats)

select *
from stats, persona as p2, media as m, (select count(a.id) as conto, p.id
			  from assenza as a
			  join persona as p on a.persona = p.id
			  where a.tipo = 'Malattia' and p.posizione = 'Professore Ordinario'
			  group by p.id) as local
where local.id = p2.id and m.mid < local.conto;
/*che monnezza!, LO RISCRIVO*/


/*7. Quali sono i professori ordinari che hanno fatto più assenze per malattia del nu-
mero di assenze medio per malattia dei professori associati? Restituire id, nome e
cognome del professore e il numero di giorni di assenza per malattia. */
with stats as (select count(a.id) as conto
			  from persona as p
			  join assenza as a on a.persona = p.id
			  where p.posizione = 'Professore Associato' and a.tipo = 'Malattia'
			  group by p.id),
statsspec as (select avg(stats.conto) as media
			 from stats)

select p.id, p.nome, p.cognome, locale.conto
from persona as p, statsspec as s, (select count(a.id) as conto, p2.id
									  from persona as p2
									  join assenza as a on a.persona = p2.id
									  where a.tipo = 'Malattia'
									  group by p2.id) as locale
									  
									  
where p.posizione = 'Professore Ordinario' and locale.id = p.id and locale.conto > s.media


















