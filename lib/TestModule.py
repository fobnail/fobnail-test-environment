from cryptography import x509
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import serialization
from cbor import cbor
import pem
import hexdump
from typing import Optional, Tuple
from aiocoap.error import NetworkError
from aiocoap import *
from logging import error, info
import asyncio
import logging
import cbor
import subprocess

logging.basicConfig(level=logging.INFO)
BASE_URI = 'coap://169.254.0.1/api/v1'

requests = { # endpoint, method, input, output
    '/admin/token_provision':{'method': Code.POST,'in': 'cbor','out': 'csr'},
    '/admin/provision_complete':{'method': Code.POST,'in': 'csr','out': None}
}

class TestModule(object):
    ROBOT_LIBRARY_VERSION = '1.0.0'
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

    async def send_data(self, endpoint, argument):
        proto = await Context.create_client_context()

        if requests[endpoint]['in'] == 'cbor':
            payload = open(argument, 'rb').read()
            if not isinstance(payload, bytes):
                payload = cbor.dumps(payload)
        else:
            payload = open(argument, 'rb').read()
        
        try:
            request = Message(code=requests[endpoint]['method'], uri=f'{BASE_URI}{endpoint}', payload=payload)
            if requests[endpoint]['in'] == 'cbor':
                request.opt.content_format = ContentFormat.CBOR
            r: Message = await proto.request(request).response
            if r.code != Code.CREATED:
                raise RuntimeError(f'Request failed with error {r.code}')
            if requests[endpoint]['out'] == 'csr':
                with open('provisioning/tmp/fobnail.csr', 'w+b') as out:
                    out.write(r.payload)
        except NetworkError:
            pass
        except RuntimeError as ex:
            error(ex)
