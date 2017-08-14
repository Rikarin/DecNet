module user;


/**
 * Common user even myself
 *
 * TODO: ECDSA, SHA-2, ECDSA pub-key recovery, BASE-58, RandomGenerator, json serializer
 */
class User {
    // TODO
}


class Myself : User {
    // string m_privateKey;

}

/*
TODO: date, CRC? (CRC = sha2(sha2(whole message))[0 .. 4])
    Message:
    // For everyone
    {
        message: "foo bar",
    }

    // For group of people
    {
        message: "SADFLKSDFKJL3429IU04239IJERGJIOERWG908J423", // message encrypted by random revertable hash
        users: [
            "address1": "SDFJDFGSJSDFKSDF", // hash encrypted by public key of specific user
        ]
    }






*/
