import 'package:cruelty_free_zone/core/company_name_search.dart';
import 'package:cruelty_free_zone/repository/company_repository.dart';
import 'package:flutter/material.dart';

class CompanyList extends StatefulWidget {
  final bool test;

  CompanyList({this.test});

  @override
  _CompanyListState createState() => _CompanyListState();
}

class _CompanyListState extends State<CompanyList> {
  CompanyRepository _companyRepository;
  List<String> data;

  @override
  void initState() {
    super.initState();
    _companyRepository = new CompanyRepository();
    data = _companyRepository.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.test
            ? "Companies that test on animals"
            : "Companies that does not test on animals"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () async {
          final result = await showSearch<String>(
            context: context,
            delegate: CompanyNameSearch(data),
          );
          print(result);
        },
      ),
      body: Container(
        child: FutureBuilder(
          future: _companyRepository.findList(widget.test),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('${snapshot.data[index]}'),
                );
              },
            );
          },
        ),
      ),
    );
  }
}