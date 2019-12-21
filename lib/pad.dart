import "package:flutter/material.dart";
import "package:random_string/random_string.dart";
import "dart:convert";
import "package:http/http.dart" as http;
import "package:json_annotation/json_annotation.dart";
import "package:steel_crypt/steel_crypt.dart";

import "page.dart";
import "minmax.dart";
import "model.dart";

@JsonSerializable()
class Content {
    String proof;
    List<Page> content;

    Content({ Key key, this.proof, this.content });

    static Content fromJson(Map<String, dynamic> input) {
        List list = input["Content"] as List;
        List<Page> pages = list.map((i) => Page.fromJson(i)).toList();

        return Content(
            proof: input["Proof"],
            content: pages,
        );
    }

    Map<String, dynamic> toJson() =>
        {
            "Content": this.content,
            "Proof": this.proof,
        };
}

@JsonSerializable()
class Pad {
    static final MinMax IDLen = MinMax(4, 16);
    static final int ProofLen = 32;
    static final MinMax PasswordLen = MinMax(8, 64);

    String id, proof, newProof, password, encrypted;
    List<Page> content;

    Pad({ Key key, this.id, this.content, this.encrypted, this.proof, this.newProof }) {
        if (this.content == null) {
            this.content = List<Page>();
        }
    }

    randomiseProof() {
        this.proof = randomString(ProofLen);
        this.newProof = this.proof;
    }

    static Pad fromJson(Map<String, dynamic> input) =>
        Pad(
            id: input["ID"],
            encrypted: input["Content"],
            proof: input["Proof"],
            newProof: input["NewProof"],
        );

    Map<String, dynamic> toJson() {
        var unencrypted = Content(
            content: this.content,
            proof: this.proof,
        );

        String encoded = json.encode(unencrypted);

        String iv = CryptKey().genDart();
        String key = PassCrypt(Model.AlgorithmPasswordHash).hashPass(iv, this.password);
        AesCrypt crypt = AesCrypt(key, Model.AlgorithmCipherMode, Model.AlgorithmPadding);
        String encrypted = crypt.encrypt(encoded, iv);

        var res = {
            "ID": this.id,
            "Content": iv + Model.EncryptionSeparator + encrypted,
        };

        if (proof != null)
            res.addAll({"Proof": this.proof});

        if (newProof != null)
            res.addAll({"NewProof": this.newProof});

        return res;
    }

    void decrypt() {
        var split = this.encrypted.split(Model.EncryptionSeparator);
        String iv = split[0];
        String encrypted = split[1];

        String key = PassCrypt(Model.AlgorithmPasswordHash).hashPass(iv, password);
        AesCrypt crypt = AesCrypt(key, Model.AlgorithmCipherMode, Model.AlgorithmPadding);

        String decrypted = crypt.decrypt(encrypted, iv);

        var decoded = json.decode(decrypted);
        Content content = Content.fromJson(decoded);

        this.proof = content.proof;
        this.content = content.content;
    }

    static const Map<String, String> headers = {"Content-type": "application/json"};
    static const String baseUrl = Model.BaseUrl + "pad";

    Future<http.Response> save() async {
        String body = json.encode(this);

        if (newProof != null) {
            proof = newProof;
            newProof = null;
        }

        debugPrint(body);

        var response = await http.put(
            baseUrl,
            headers: headers,
            body: body,
        );

        return response;
    }
}