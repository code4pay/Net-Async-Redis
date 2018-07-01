package Net::Async::Redis::Server::Connection;

use strict;
use warnings;

use parent qw(IO::Async::Notifier);

# VERSION

=head1 NAME

Net::Async::Redis::Server::Connection - represents a single connection to a server

=head1 DESCRIPTION

Best to wait until the 2.000 release for this one.

=cut

use strict;
use warnings;

use Net::Async::Redis::Commands;

sub AUTOLOAD {
    my ($self, @args) = @_;
    my ($method) = our $AUTOLOAD =~ /::([^:]+)$/;
    my $cmd = uc $method;
    if(Net::Async::Redis::Commands->can($method)) {
        $cmd =~ tr/_/ /;
        return $self->request->reply(ERR => 'Unimplemented command ' . $cmd);
    }
    return $self->request->reply(ERR => 'Unknown command ' . $cmd);
}

sub request { }

sub stream { shift->{stream} }

sub configure {
    my ($self, %args) = @_;
    for (qw(server stream)) {
        Scalar::Util::weaken($self->{$_} = delete $args{$_}) if exists $args{$_};
    }
    $self->next::method(%args);
}
1;


