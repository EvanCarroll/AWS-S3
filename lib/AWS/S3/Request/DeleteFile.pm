
package AWS::S3::Request::DeleteFile;

use Moose;
use AWS::S3::Signer;
use AWS::S3::ResponseParser;

with 'AWS::S3::Roles::Request';

has 'bucket' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has 'key' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

sub request {
    my $s = shift;

    my $signer = AWS::S3::Signer->new(
        s3     => $s->s3,
        method => 'DELETE',
        uri    => $s->protocol . '://' . $s->bucket . '.s3.amazonaws.com/' . $s->key,
    );
    $s->_send_request(
        $signer->method => $signer->uri => {
            Authorization => $signer->auth_header,
            Date          => $signer->date,
        }
    );
}    # end request()

sub parse_response {
    my ( $s, $res ) = @_;

    AWS::S3::ResponseParser->new(
        response       => $res,
        expect_nothing => 1,
        type           => $s->type,
    );
}    # end http_request()

__PACKAGE__->meta->make_immutable;
