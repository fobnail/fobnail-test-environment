from argparse import ArgumentParser
from cryptography import x509
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import serialization
from cbor import cbor
import pem
import hexdump

parser = ArgumentParser()
parser.add_argument('input')
parser.add_argument('output')
args = parser.parse_args()

chain = pem.parse_file(args.input)

cert = []
for c in chain:
    c = x509.load_pem_x509_certificate(
        str(c).encode('utf-8'), default_backend())
    der = c.public_bytes(serialization.Encoding.DER)
    cert.append(bytes(der))

encoded = cbor.dumps({
    'certs': cert
})

with open(args.output, 'wb') as out:
    out.write(encoded)
    out.close()

# hexdump.hexdump(encoded)
