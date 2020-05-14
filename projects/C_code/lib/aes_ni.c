#include "aes_ni.h"
#include <stdio.h>

// The function of AES Encryption
uint8_t* aes_enc_128bits(char* plain_str, char* enc_key_str){
    uint8_t* plain;
    uint8_t* enc_key;
    plain = (uint8_t*) malloc(17*sizeof(uint8_t));
    if (plain == NULL) {
        printf("Malloc failed.\n");
        return NULL;
    }
    enc_key = (uint8_t*) malloc(17*sizeof(uint8_t));
    if (enc_key == NULL) {
        printf("Malloc failed.\n");
        return NULL;
    }

    // Casting the relevant data
    for (int i = 0; i < 16; i++)
    {
        plain[i] = (uint8_t)plain_str[i];
        enc_key[i] = (uint8_t)enc_key_str[i];
    }

    uint8_t* computed_cipher;
    computed_cipher = (uint8_t*) malloc(17 * sizeof(uint8_t));
    if (computed_cipher == NULL) {
        printf("Malloc failed.\n");
        return NULL;
    }

    // The encryption
    __m128i key_schedule[20];
    aes128_load_key(enc_key,key_schedule);
    aes128_enc(key_schedule,plain,computed_cipher);

    // Stating the end of the data
    computed_cipher[16] = '\0';
    return computed_cipher;
}

// The function of AES Decryption
uint8_t* aes_dec_128bits(char* cipher_str, char* enc_key_str){
    uint8_t* cipher;
    uint8_t* enc_key;
    cipher = (uint8_t*) malloc(17*sizeof(uint8_t));
    if (cipher == NULL) {
        printf("Malloc failed.\n");
        return NULL;
    }
    enc_key = (uint8_t*) malloc(17*sizeof(uint8_t));
    if (enc_key == NULL) {
        printf("Malloc failed.\n");
        return NULL;
    }

    // Casting the relevant data
    for (int i = 0; i < 17; i++)
    {
        cipher[i] = (uint8_t)cipher_str[i];
        enc_key[i] = (uint8_t)enc_key_str[i];
    }

    uint8_t* computed_plain;
    computed_plain = (uint8_t*) malloc(17 * sizeof(uint8_t));
    if (computed_plain == NULL) {
        printf("Malloc failed.\n");
        return NULL;
    }

    // The decryption
    __m128i key_schedule[20];
    aes128_load_key(enc_key,key_schedule);
    aes128_dec(key_schedule,cipher,computed_plain);

    // Stating the end of the data
    computed_plain[16] = '\0';
    return computed_plain;
}

