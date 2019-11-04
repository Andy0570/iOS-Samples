//
//  openssl_wrapper.m
//  AliSDKDemo
//
//  Created by antfin on 17-10-24.
//  Copyright (c) 2017年 AntFin. All rights reserved.
//

#import "openssl_wrapper.h"
#import "rsa.h"
#include "pem.h"
#include "bio.h"
#include "sha.h"

int rsa_sign_with_private_key_pem(char *message, int message_length
                                  , unsigned char *signature, unsigned int *signature_length
                                  , char *private_key_file_path, BOOL rsa2)
{
    unsigned char shabuf[(rsa2?(SHA256_DIGEST_LENGTH):(SHA_DIGEST_LENGTH))];
    if (rsa2) {
        SHA256((unsigned char *)message, message_length, shabuf);
    } else {
        SHA1((unsigned char *)message, message_length, shabuf);
    }
    
    int success = 0;
    BIO *bio_private = BIO_new(BIO_s_file());
    BIO_read_filename(bio_private, private_key_file_path);
    RSA *rsa_private = PEM_read_bio_RSAPrivateKey(bio_private, NULL, NULL, "");
	if (rsa_private != nil) {
		if (1 == RSA_check_key(rsa_private)) {
            int rsa_sign_valid = RSA_sign((rsa2?(NID_sha256):(NID_sha1))
										  , shabuf, (rsa2?(SHA256_DIGEST_LENGTH):(SHA_DIGEST_LENGTH))
										  , signature, signature_length
										  , rsa_private);
			if (1 == rsa_sign_valid) {
				success = 1;
			}
		}
        RSA_free(rsa_private);
	} else {
		NSLog(@"rsa_private read error : private key is NULL");
	}

    BIO_free_all(bio_private);
    return success;
}

NSString *base64StringFromData(NSData *signature)
{
    int signatureLength = (int)[signature length];
    unsigned char *outputBuffer = (unsigned char *)malloc(2 * 4 * (signatureLength / 3 + 1));
    int outputLength = EVP_EncodeBlock(outputBuffer, [signature bytes], signatureLength);
    outputBuffer[outputLength] = '\0';
    NSString *base64String = [NSString stringWithCString:(char *)outputBuffer encoding:NSASCIIStringEncoding];
    free(outputBuffer);
    return base64String;
}

