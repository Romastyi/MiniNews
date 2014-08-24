use DBI;

# Подключение к БД (все в открытом виде!)
my $dbh = DBI->connect("dbi:Pg:dbname=rt_news", "rt_news", "rt_news", {PrintError => 0}) or die "Could not connect to DB!";

# Обертка над $dbh
helper db => sub { $dbh };

# Помощник для выборки всех новостей
helper select_all => sub {
  my $self = shift;
  my $all  = $_[0];
  my $sql  = <<"END_SQL";
  select n.id, n.title, n.lead, n.body, n.is_ready, 
         to_char(n.updated, 'DD.MM.YYYY HH24:MI:SS') updated,
         array(select t.name 
                 from public.news_tags nt, public.tags t 
                where nt.id_news = n.id and t.id = nt.id_tag) tags
    from public.news n
   where ? or is_ready
   order by id;
END_SQL
  my $sth = eval { $self->db->prepare($sql) } || return undef;
  $sth->execute($all);
  return $sth->fetchall_hashref('id');
};

# Помощник для выборки новости по id
helper select_by_id => sub {
  my $self = shift;
  my $id   = $_[0];
  my $sql  = <<"END_SQL";
  select n.id, n.title, n.lead, n.body, n.is_ready, 
         to_char(n.updated, 'DD.MM.YYYY HH24:MI:SS') updated,
         array(select t.name 
                 from public.news_tags nt, public.tags t 
                where nt.id_news = n.id and t.id = nt.id_tag) tags
    from public.news n
   where n.id = ?;
END_SQL
  my $sth = eval { $self->db->prepare($sql) } || return undef;
  $sth->execute($id);
  return $sth->fetchrow_hashref;
};

# Помощник для выборки по имени тега
helper select_by_tag => sub {
  my $self = shift;
  my $tag  = $_[0];
  my $sql  = <<"END_SQL";
  select n.id, n.title, n.lead, n.body, n.is_ready, 
         to_char(n.updated, 'DD.MM.YYYY HH24:MI:SS') updated
    from public.news n, public.news_tags nt
   where nt.id_news = n.id and n.is_ready
         and nt.id_tag in (select id
                             from public.tags
                            where name ilike ?);
END_SQL
  my $sth = eval { $self->db->prepare($sql) } || return undef;
  $sth->execute($tag);
  return $sth->fetchall_hashref('id');
};
 
