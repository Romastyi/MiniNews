package MiniNews::Model::Tags;

use strict;
use warnings;
use v5.10;

use base 'MiniNews::Model::Base';

sub schema {'public'}

sub table {'tags'}

sub create_for_news {
  my $class   = shift;
  my $id_news = shift;
  my $tags    = shift;
  # Если что-то не задано выходим
  return unless ($id_news || $tags);
  $class->delete_by_news($id_news);
  # Перебираем теги
  foreach my $tag (@{$tags}) {
    my ($id) = $class->id_by_name($tag)->list;
    $id = $class->insert({name => "$tag"}) unless $id;
    $class->insert_new($id_news, $id);
  }
}

sub delete_by_news {
  my $class   = shift;
  my $id_news = shift;
  my $sql     = <<"END_SQL";
  delete from public.news_tags
   where id_news = ?;
END_SQL
  $class->query($sql, $id_news);
}

sub insert_new {
  my $class   = shift;
  my $id_news = shift;
  my $id_tag  = shift;
  # Если что-то не задано выходим
  return unless ($id_news || $id_tag);
  # Добавляем пару новость <-> тег
  my $sql = <<"END_SQL";
  insert into public.news_tags
  (id_news, id_tag) values (?, ?);
END_SQL
  $class->query($sql, $id_news, $id_tag);
}

sub id_by_name {
  my $class = shift;
  my $name  = shift;
  my $sql   = <<"END_SQL";
  select id 
    from public.tags
   where name ilike ?;
END_SQL
  $class->query($sql, $name);
}

1;
