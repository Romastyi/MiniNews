use Mojolicious::Lite;

require 'helpers.pl';

# / - список новостей
get '/' => sub {
  my $self = shift;
  my $recs = $self->select_all;
  $self->render('index', recs => $recs);
};

# /:id - новость по id
# проверяем id по regexp '\d+'
get '/:id' => [id => qr/\d+/] => sub {
  my $self = shift;
  my $id   = $self->param('id');
  my $rec  = $self->select_by_id($id);
  $self->render('news', rec => $rec);
};

# /tag/:tag - список новостей с tag
# проверям tag по regexp '.+'
get '/tag/:tag' => [tag => qr/.+/] => sub {
  my $self = shift;
  my $tag  = $self->param('tag');
  my $recs = $self->select_by_tag($tag);
  $self->render('tags', tag => $tag, recs => $recs);
};

# Запускаем Mojolicious
app->start;

__DATA__

@@ index.html.ep
<!DOCTYPE html>
<html>
  <head><title>All news</title></head>
  <body>
    <div>Here is list on all news:</div>
    <table border="1">
      <thead>
	<tr>
	  <th>Id</th>
	  <th>Title</th>
	  <th>Lead</th>
	  <th>News</th>
	  <th>Updated</th>
	  <th>Tags</th>
	</tr>
      </thead>
      <tbody id="table">
	%= include 'table'
      </tbody>
    </table>
  </body>
</html>

@@ news.html.ep
<!DOCTYPE html>
<html>
  <head><title>News: "<%= $rec->{"title"} %>"</title></head>
  <body>
    <div><h1><%= $rec->{"title"} %></h1></div>
    <div><h2><%= $rec->{"lead"} %></h2></div>
    <div><%= $rec->{"updated"} %></div>
    </br>
    <div><%= $rec->{"body"} %></div>
    </br>
    <div>
      % my $tags_array = $rec->{"tags"};
      % foreach my $tag (@$tags_array) {
	<a href="<%= $tag %>"><%= $tag %></a>
      % }
    </div>
    </br>
    <a href="/">Back to all</a>
  </body>
</html>

@@ tags.html.ep
<!DOCTYPE html>
<html>
  <head><title>News by tag "<%= $tag %>"</title></head>
  <body>
    <div>List of news with tag "<%= $tag %>":</div>
    <table border="1">
      <thead>
	<tr>
	  <th>Id</th>
	  <th>Title</th>
	  <th>Lead</th>
	  <th>News</th>
	  <th>Updated</th>
	</tr>
      </thead>
      <tbody id="table">
	%= include 'table'
      </tbody>
    </table>
    <a href="/">Back to all</a>
  </body>
</html>

@@ table.html.ep
% foreach my $id (sort keys %$recs) {
  <tr>
    <td><a href="/<%= $id %>"><%= $recs->{$id}->{"id"} %></a></td>
    <td><%= $recs->{$id}->{"title"} %></td>
    <td><%= $recs->{$id}->{"lead"} %></td>
    <td><%= $recs->{$id}->{"body"} %></td>
    <td><%= $recs->{$id}->{"updated"} %></td>
    % if ($recs->{$id}->{"tags"}) {
    <td>
      % my $tags_array = $recs->{$id}->{"tags"};
      % foreach my $link (@$tags_array) {
	<a href="/tag/<%= $link %>"><%= $link %></a>
      % }
    </td>
    % }
  </tr>
% }
