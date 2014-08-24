package MiniNews;

use strict;
use warnings;
use base 'Mojolicious';

# Выполняется один раз при запуске приложения
sub startup {
  my $self = shift;
  
  $self->secrets(['MiniNewsSecret']);
  
  # Считываем конфиг "fast_news.json" из корневой папки приложения. 
  # Переменная $config содержит наш конфиг. После инициализации 
  # приложения мы можем получить доступ к конфигу используя
  # $self->stash('config').
  my $config = $self->plugin('JSONConfig'); 
  
  my $r = $self->routes;
  # Будет искать контроллеры в папке lib/FastNotes/Controller
  $r->namespaces(['MiniNews::Controller']);
  
  # Назначаем обработку путей
  # Морда
  $r->route('/')                      ->via('get')->to('news#index') ->name('news_index');
  $r->route('/:id', id => qr/\d+/)    ->via('get')->to('news#by_id') ->name('news_by_id');
  $r->route('/tag/:tag', id => qr/.+/)->via('get')->to('news#by_tag')->name('news_by_tag');
  
  # Админка
  $r->route('/form')  ->to('auth#form')  ->name('auth_form');
  $r->route('/login') ->to('auth#login') ->name('auth_login');
  $r->route('/logout')->to('auth#logout')->name('auth_logout');
  my $ra = $r->bridge('/admin')->to('auth#check'); # Для всех адресов /admin/... будет проверяться авторизация.
  $ra->route('/')                               ->via('get')   ->to('admin#index')  ->name('admin_index');
  $ra->route('/')                               ->via('post')  ->to('admin#create') ->name('admin_create');
  # По RESTfull должена быть PUT, Но оставлю POST, чтобы не заморачиваться с формой
  $ra->route('/:id'        , id => qr/\d+/)     ->via('post')  ->to('admin#update') ->name('admin_update');
  $ra->route('/:id'        , id => qr/\d+/)     ->via('delete')->to('admin#delete') ->name('admin_delete');
  $ra->route('/:id/edit'   , id => qr/(\d+|-1)/)->via('get')   ->to('admin#edit')   ->name('admin_edit');
  $ra->route('/:id/preview', id => qr/(\d+|-1)/)->via('post')  ->to('admin#preview')->name('admin_preview');
  
  # Подгружаем модуль Model.pm
  if (my $e = Mojo::Loader->load('MiniNews::Model')) {
    die ref $e ? "Exception: $e" : 'Not found!';
  }
  
  # Настройки БД
  MiniNews::Model->init( $config->{db} || 
    {
      dsn      => 'dbi:Pg:dbname=',
      user     => '',
      password => ''
    });
}

1;