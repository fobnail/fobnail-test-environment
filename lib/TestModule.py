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
import cbor2
import subprocess

logging.basicConfig(level=logging.INFO)
BASE_URI = 'coap://169.254.0.1/api/v1'

requests = { # endpoint, method, result_code, output
    '/admin/token_provision':[Code.POST, 2.01, 'csr'],
    '/admin/provision_complete':[Code.POST, 2.01, None]
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
        with open(argument, 'rb') as cbor_in:
            payload = cbor2.load(cbor_in)
        try:
            request = Message(code=requests[endpoint][0], uri=f'{BASE_URI}{endpoint}', payload=payload)
            r: Message = await proto.request(request).response
            print(r.code)
            if r.code != requests[endpoint][1]:
                raise RuntimeError(f'Request failed with error {r.code}')
            if requests[endpoint][2] == 'csr':
                pass
        except NetworkError:
            pass
        except RuntimeError as ex:
            error(ex)
