delete from concept_relationship_stage
where
	concept_code_1 in (select source_code from tofix_vax where concept_id is not null) and
	vocabulary_id_1 = 'GGR' and
	relationship_id = 'Maps to'
;
insert into concept_relationship_stage
select
	null :: int4,
	null :: int4,
	v.source_code,
	c.concept_code,
	'GGR',
	c.vocabulary_id,
	'Maps to',
	(SELECT vocabulary_date FROM sources.ggr_ir LIMIT 1),
	to_date ('20991231','yyyymmdd') as valid_end_date,
	null as invalid_reason
from tofix_vax v
join concept c using (concept_id)
;
insert into concept_relationship_stage --deprecate old existing
select
	null :: int4,
	null :: int4,
	v.source_code,
	c.concept_code,
	'GGR',
	c.vocabulary_id,
	cr.relationship_id,
	cr.valid_start_date,
	(SELECT vocabulary_date FROM sources.ggr_ir LIMIT 1) - 1,
	'D'
from tofix_vax v
join concept x on
	(v.source_code, 'GGR') = (x.concept_code, x.vocabulary_id)
join concept_relationship cr on
	x.concept_id = cr.concept_id_1 and
	cr.relationship_id = 'Maps to' and
	cr.concept_id_2 != v.concept_id --not same as we map to
join concept c on
	c.concept_id = cr.concept_id_2
;
--Dose Forms are inconsistent between releases, discard them
delete from concept_relationship_stage where (concept_code_1, vocabulary_id_1) in (select concept_code, 'GGR' from concept_stage where concept_class_id = 'Dose Form')
;
delete from concept_stage where concept_class_id = 'Dose Form' and vocabulary_id = 'GGR'
;
--Discard pack component concepts
delete from concept_relationship_stage where (concept_code_1, vocabulary_id_1) in (select concept_code, 'GGR' from concept_stage where concept_class_id = 'Med Product Pack' and vocabulary_id = 'GGR' and concept_code like 'OMOP%')
;
delete from concept_stage where concept_class_id = 'Med Product Pack' and vocabulary_id = 'GGR' and concept_code like 'OMOP%'
;
insert into concept_stage (concept_id,concept_name,domain_id,vocabulary_id,concept_class_id,standard_concept,concept_code,valid_start_date,valid_end_date,invalid_reason)
select
	null :: int4 as concept_id,
	concept_name,
	domain_id,
	vocabulary_id,
	concept_class_id,
	standard_concept,
	concept_code,
	valid_start_date,
		(
			SELECT vocabulary_date FROM sources.ggr_ir LIMIT 1
		) - 1
		as valid_end_date,
	'D' as invalid_reason
from devv5.concept
where
	concept_code like 'OMOP%' and
	vocabulary_id = 'GGR' and invalid_reason is null
;