// ignore_for_file: unused_field

import 'package:flutter/material.dart';

import '../database/sql_helper.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> _sqflite = [];
  bool _isloading = true;

  void _refreSqflite() async {
    final data = await SQLhelper
        .getItems(); //id'ye göre sıralı şekilde verileri getiiriz.
    setState(() {
      _sqflite = data; //çekilen datayı listeye atadık.
      _isloading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreSqflite();
    print('... listenin uzunluğu ${_sqflite.length}');
  }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Future<void> _addItem() async {
    await SQLhelper.createItem(
        titleController.text, descriptionController.text);
    _refreSqflite();
  }

  Future<void> _updateItem(int id) async {
    await SQLhelper.updateItem(
        id, titleController.text, descriptionController.text);
    _refreSqflite();
  }

  Future<void> _deleteItem(int id) async {
    await SQLhelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Başarılı bir şekilde silinmiştir.')));
    _refreSqflite();
  }

  void _showForm(int? id) async {
    if (id != null) {
      final existingSqflite =
          _sqflite.firstWhere((element) => element['id'] == id);
      titleController.text = existingSqflite['title'];
      descriptionController.text = existingSqflite['description'];
    }
    showModalBottomSheet(
        context: context,
        builder: (_) => SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 120),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20, top: 30, bottom: 10),
                      child: TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                        controller: titleController,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: TextField(
                        controller: descriptionController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (id == null) {
                            //id bmarası yoksa eleman ekle
                            await _addItem();
                          }
                          if (id != null) {
                            //id numarası varsa güncelleme işlemi yap o fonk. çağır.
                            await _updateItem(id);
                          }
                          titleController.text = '';
                          descriptionController.text = '';
                          Navigator.of(context).pop();
                        },
                        child: Text(id == null ? 'Yeni Ekle' : 'Güncelle'))
                  ],
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        centerTitle: true,
        title: const Text('Veritabanına Kayıtlı'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(null),
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
          itemCount: _sqflite.length,
          itemBuilder: (context, index) => Card(
                child: ListTile(
                  leading: Text(_sqflite[index]['id'].toString()),
                  //belirttiğimiz listede yer alan title ve description değerlerini ekleriz
                  title: Text(_sqflite[index]['title']),
                  subtitle: Text(_sqflite[index]['description']),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              _showForm(_sqflite[index]['id']);
                            },
                            icon: Icon(Icons.edit)),
                        IconButton(
                            onPressed: () => _deleteItem(_sqflite[index]['id']),
                            icon: Icon(Icons.delete))
                      ],
                    ),
                  ),
                ),
              )),
    );
  }
}
