package MiniNews::Model::News;

use strict;
use warnings;
use v5.10;

use base 'MiniNews::Model::Base';

sub schema {'public'}

sub table {'news'}

sub select_all {
  my $class = shift;
  my $only_ready = shift;
  my $sql   = <<"END_SQL";
  select n.id, n.title, n.lead, n.body, n.is_ready, 
         to_char(n.updated, 'DD.MM.YYYY HH24:MI:SS') updated,
         array(select t.name 
                 from public.news_tags nt, public.tags t 
                where nt.id_news = n.id and t.id = nt.id_tag) tags
    from public.news n
   where not ? or is_ready
   order by id;
END_SQL
  $class->query($sql, $only_ready);
}

sub select_by_id {
  my $class = shift;
  my $id    = shift;
  my $sql   = <<"END_SQL";
  select n.id, n.title, n.lead, n.body, n.is_ready, 
         to_char(n.updated, 'DD.MM.YYYY HH24:MI:SS') updated,
         array(select t.name 
                 from public.news_tags nt, public.tags t 
                where nt.id_news = n.id and t.id = nt.id_tag) tags
    from public.news n
   where n.id = ?;
END_SQL
  $class->query($sql, $id);
}

sub select_by_tag {
  my $class = shift;
  my $tag   = shift;
  my $sql   = <<"END_SQL";
  select n.id, n.title, n.lead, n.body, n.is_ready, 
         to_char(n.updated, 'DD.MM.YYYY HH24:MI:SS') updated
    from public.news n, public.news_tags nt
   where nt.id_news = n.id and n.is_ready
         and nt.id_tag in (select id
                             from public.tags
                            where name ilike ?);
END_SQL
  $class->query($sql, $tag);
}

1;