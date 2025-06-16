/* Cielo4 */
/*1. Quali sono i voli di durata maggiore della durata media di tutti i voli della stessa
compagnia? Restituire il codice del volo, la compagnia e la durata. */

with stats as (select avg(v.durataMinuti) as media, v.comp
			  from volo as v
			  group by v.comp)
select v.codice, v.comp, v.durataMinuti
from volo as v
join stats as s on v.comp = s.comp
where v.durataMinuti > s.media;

/*2. Quali sono le città che hanno piu” di un aeroporto e dove almeno uno di questi ha
un volo operato da “Apitalia”?*/

with stats as (select count(l.aeroporto) as conto, l.citta
			  from luogoaeroporto as l
			  group by l.citta)
select distinct l.citta
from luogoaeroporto as l
join stats as s on s.citta = l.citta
join aeroporto as a on a.codice = l.aeroporto
join arrpart as ap on ((ap.arrivo = a.codice) or (ap.partenza = a.codice))
join volo as v on ap.codice = v.codice
where v.comp = 'Apitalia' and s.conto > 1


