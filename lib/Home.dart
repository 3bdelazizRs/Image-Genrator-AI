import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_genrator_ai/constants/constants.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController prompConroller = TextEditingController();
  bool isLoading = false;
  String? linkImage;
  void genrateImage() async {
    const apiKey =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiMTcwMzIzMWQtZWEwZS00Nzg3LWEwMDItODRjNDA5ZTJmNWVkIiwidHlwZSI6ImFwaV90b2tlbiJ9.0RJewdkfrylgp_ECvylF7tzFlGZKt5KDCmO1pD_Yia4';
    // const apiKey = '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';
    const url = 'https://api.edenai.run/v2/image/generation';
    // const url = 'https://api.openai.com/v1/images/generations';
    if (prompConroller.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      try {
        var response = await http.post(Uri.parse(url),
            headers: {
              'accept': 'application/json',
              'content-type': 'application/json',
              'authorization': "Bearer $apiKey"
              // 'Authorization': 'Bearer $apiKey',
              // 'Content-Type': 'application/json',
            },
            body: json.encode({
              'text': prompConroller.text,
              'response_as_dict': false,
              'attributes_as_list': false,
              'show_original_response': false,
              'resolution': '512x512',
              'num_images': 1,
              'providers': 'stabilityai',
            }));

        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          setState(() {
            linkImage = data[0]['items'][0]['image_resource_url'];
            isLoading = false;
          });
        }
      } catch (e) {
        print(e);
      }
      ;
    }
  }

  void saveImage() async {
    var response = await Dio()
        .get(linkImage!, options: Options(responseType: ResponseType.bytes));

    final resualt = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 80);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appbarColor,
        leading: linkImage == null
            ? null
            : IconButton(
                onPressed: () {
                  setState(() {
                    linkImage == null;
                  });
                  prompConroller.clear();
                },
                icon: Icon(
                  Icons.history,
                  color: buttonColor,
                )),
        actions: linkImage == null
            ? null
            : [
                IconButton(
                    onPressed: () {
                      saveImage();
                    },
                    icon: Icon(
                      Icons.download,
                      color: buttonColor,
                    )),
              ],
        centerTitle: true,
        title: const Text(
          "Image Generator AI",
          style: TextStyle(color: Colors.white, fontFamily: 'Rubik'),
        ),
      ),
      body: Column(children: [
        Expanded(
            child: Center(
          child: SingleChildScrollView(
            child: linkImage == null
                ? Lottie.asset(
                    isLoading ? "assets/loading.json" : "assets/ai_logo.json")
                : Padding(
                    padding: const EdgeInsets.all(20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        linkImage!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
          ),
        )),
        Container(
          color: appbarColor,
          padding: const EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          child: SafeArea(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Enter your prompt",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Rubik',
                    fontSize: 25,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF5F5F5F))),
                child: TextField(
                  controller: prompConroller,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                  decoration: const InputDecoration.collapsed(
                      hintStyle: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF9F9F9F),
                          fontFamily: 'Rubik'),
                      hintText: "Write the prompt here ..."),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: MaterialButton(
                  color: buttonColor,
                  height: 55,
                  onPressed: () {
                    if (!isLoading) {
                      genrateImage();
                    }
                  },
                  child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.generating_tokens,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Generate",
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Rubik',
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )
                      ]),
                ),
              )
            ],
          )),
        ),
      ]),
    );
  }
}
