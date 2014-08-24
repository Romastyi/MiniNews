package MiniNews::Model::Base;

use strict;
use warnings;
use v5.10;

use base 'Mojo::Base';

# Общие методы

sub table_name {
  my $class = shift;
  join('.', $class->schema, $class->table);
}

sub select {
  my $class = shift;
  MiniNews::Model->db->select($class->table_name, '*', @_);
}

sub query {
  my $class = shift;
  my $query = shift;
  MiniNews::Model->db->query($query, @_);
}

sub insert {
  my $class = shift;
  my $db    = MiniNews::Model->db;
  $db->insert($class->table_name, @_) or die $db->error();
  $db->last_insert_id('', $class->schema, $class->table, '') or die $db->error();
}

sub update {
  my $class = shift;
  my $db    = MiniNews::Model->db;
  $db->update($class->table_name, @_) or die $db->error();
}

sub delete {
  my $class = shift;
  my $db    = MiniNews::Model->db;
  $db->delete($class->table_name, @_) or die $db->error();
}

1;