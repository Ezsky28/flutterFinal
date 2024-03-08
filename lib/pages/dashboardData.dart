import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:finalproject/models/country_model.dart';
import 'package:finalproject/pages/view_country.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class DashData extends StatefulWidget {
  @override
  State<DashData> createState() => _DashDataState();
}

class _DashDataState extends State<DashData> {
  Future<List<Country>> countryFuture = getCountry();
  String searchCountry = "";
  final user = FirebaseAuth.instance.currentUser;
  static Future<List<Country>> getCountry() async {
    var url = Uri.parse("https://restcountries.com/v3.1/all");
    final response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    final List body = json.decode(response.body);
    return body.map((e) => Country.fromJsonList(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        colors: [
          Color.fromRGBO(106, 107, 107, 1),
          Color.fromARGB(255, 0, 0, 0)
        ],
        stops: [0, 1],
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
      )),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            SizedBox(height: 6),
            Container(
              child: TextField(
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Seacrh for a country',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                onChanged: (value) {
                  setState(() {
                    searchCountry = value;
                  });
                },
              ),
            ),
            Center(
              child: FutureBuilder<List<Country>>(
                future: countryFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    final countries = snapshot.data!;
                    final filteredCountries = countries
                        .where((country) => country.nameCommon!
                            .toLowerCase()
                            .contains(searchCountry.toLowerCase()))
                        .toList();
                    return buildCountry(filteredCountries);
                    //return buildCountry(countries);
                  } else {
                    return const Text("No data available");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCountry(List<Country> countries) {
    return SizedBox(
      height: 649,
      child: ListView.builder(
          itemCount: countries.length,
          itemBuilder: (context, index) {
            final country = countries[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CountryInfo(name: country.nameCommon.toString())));
              },
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color.fromARGB(255, 255, 255, 255)
                        .withOpacity(.5),
                  ),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 10),
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  height: 100,
                  width: double.maxFinite,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            height: 100,
                            width: 180,
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Image(
                                fit: BoxFit.cover,
                                image: NetworkImage(country.flagPng!))),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 190),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            country.nameCommon!,
                            style: GoogleFonts.bebasNeue(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  )),
            );
          }),
    );
  }
}
