-- SORT_QUERY_RESULTS
set hive.explain.user=false;

create table iceTbl (id int, name string) Stored by Iceberg;

-- creating tag requires table to have current snapshot. here insert some values to generate current snapshot
insert into iceTbl values(1, 'jack');

-- create tag with default values based on the current snapshotId
explain alter table iceTbl create tag test_tag_1;
alter table iceTbl create tag test_tag_1;
select name, max_reference_age_in_ms from default.iceTbl.refs where type='TAG';

-- create a tag which could be retained 5 days based on the current snapshotId
insert into iceTbl values(2, 'bob');
explain alter table iceTbl create tag test_tag_2 retain 5 days;
alter table iceTbl create tag test_tag_2 retain 5 days;
select name, max_reference_age_in_ms from default.iceTbl.refs where type='TAG';

-- create a tag which already exists
explain alter table iceTbl create tag if not exists test_tag_2;
alter table iceTbl create tag if not exists test_tag_2;

-- create or replace
explain alter table iceTbl create or replace tag test_tag_1;
alter table iceTbl create or replace tag test_tag_1;
select * from default.iceTbl.tag_test_tag_1;

-- drop a tag
explain alter table iceTbl drop tag test_tag_2;
alter table iceTbl drop tag test_tag_2;

-- drop a tag with if exists
explain alter table iceTbl drop tag if exists test_tag_1;
alter table iceTbl drop tag if exists test_tag_1;

-- drop a non-exist tag with if exists
alter table iceTbl drop tag if exists test_tag_4;


