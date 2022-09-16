from argparse import ArgumentParser
from cryptography import x509
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import serialization
from cbor import cbor
import pem
import hexdump

class TestModule(object):
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'
    
    def convert_pem_to_cbor(self, input_file, output_file):

        chain = pem.parse_file(input_file)
        cert = []
        for c in chain:
            c = x509.load_pem_x509_certificate(
                str(c).encode('utf-8'), default_backend())
            der = c.public_bytes(serialization.Encoding.DER)
            cert.append(bytes(der))
        encoded = cbor.dumps({
            'certs': cert
        })

        with open(output_file, 'wb') as out:
            out.write(encoded)
            out.close()

        # hexdump.hexdump(encoded)

    def send_data(self, msg):
        pass