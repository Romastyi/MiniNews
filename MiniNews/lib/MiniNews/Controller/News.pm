package MiniNews::Controller::News;

use strict;
use warnings;
use v5.10;
use base 'Mojolicious::Controller';

sub index {
  my $self = shift;
  my $news = MiniNews::Model::News->select_all(1)->hashes;
  $self->render('index', rows => $news);
}

sub by_id {
  my $self = shift;
  my $news = MiniNews::Model::News->select_by_id($self->param('id'))->hash;
  $self->render('news', rec => $news);
}

sub by_tag {
  my $self = shift;
  my $news = MiniNews::Model::News->select_by_tag($self->param('tag'))->hashes;
  $self->render('tags', rows => $news);
}

1;
