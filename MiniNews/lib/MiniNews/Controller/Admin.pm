package MiniNews::Controller::Admin;

use strict;
use warnings;
use v5.10;

use base 'Mojolicious::Controller';

sub index {
  my $self = shift;
  my $news = MiniNews::Model::News->select_all(0)->hashes;
  $self->render('admin/index', rows => $news);
}

sub create {
  my $self = shift;
  my $news = $self->req->params->to_hash;
  my @tags = split(/,\s/, $news->{"tags"});
  $news->{"is_ready"} = $news->{"is_ready"} ? 1 : 0;
  delete $news->{"tags"};
  delete $news->{"updated"};
  MiniNews::Model::Tags->create_for_news(MiniNews::Model::News->insert($news), \@tags);
  $self->redirect_to('admin_index');
}

sub update {
  my $self = shift;
  my $id   = $self->param('id');
  my $news = $self->req->params->to_hash;
  my @tags = split(/,\s/, $news->{"tags"});
  $news->{"is_ready"} = $news->{"is_ready"} ? 1 : 0;
  $news->{"updated"} = 'now()';
  delete $news->{"tags"};
  MiniNews::Model::News->update($news, {id => $id});
  MiniNews::Model::Tags->create_for_news($id, \@tags);
  $self->redirect_to('admin_index');
}

sub delete {
  my $self = shift;
  my $id   = $self->param('id');
  MiniNews::Model::News->delete({id => $id});
  #$self->redirect_to('admin_index');
  $self->render(text => 'OK');
}

sub edit {
  my $self = shift;
  my $news = MiniNews::Model::News->select_by_id($self->param('id'))->hash;
  $self->render('admin/edit', rec => $news);
}

sub preview {
  my $self = shift; 
  my $news = $self->req->params->to_hash;
  $news->{'id'} = $self->param('id');
  
  # Валидация
  my $validation = $self->validation;
  $validation->required('title')->like(qr/.+/);
  $validation->required('lead')->like(qr/.+/);
  $validation->required('body')->like(qr/.+/);
  $validation->required('tags')->like(qr/^\w+(?:\s*,\s*\w+)*$/);
  
  return $self->render('admin/edit', rec => $news) if $validation->has_error;
  
  $self->render('admin/preview', rec => $news);
}

1;