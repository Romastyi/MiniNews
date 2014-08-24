package MiniNews::Controller::Auth;

use strict;
use warnings;
use v5.10;

use base 'Mojolicious::Controller';

sub login {
  my $self  = shift;
  my $login = $self->param('login');
  my $pass  = $self->param('pass');
  
  my $user = MiniNews::Model::User->select({login => $login, pass => $pass})->hash;
  
  if ($login && $user->{'id'}) {
    $self->session(
      user_id => $user->{'id'},
      login   => $user->{'login'}
    )->redirect_to('admin_index');
  } else {
    $self->flash(error => 'Wrong user or password.')->redirect_to('auth_form');
  }
}

sub logout {
  shift->session(user_id => '', login => '')->redirect_to('auth_form');
}

sub check {
  my $self = shift;
  return 1 if $self->session('user_id');
  $self->flash(error => 'Need authentication.')->redirect_to('auth_form');
  return;
}

sub form {
  shift->render('admin/login');
}

1;