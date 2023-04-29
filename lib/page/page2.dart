// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class MyHomePage2 extends StatefulWidget {
  const MyHomePage2({super.key});

  @override
  State<MyHomePage2> createState() => _MyHomePageState();
}

class Contact {
  String userName;
  String userNumber;
  Contact({required this.userName, required this.userNumber});
}

class _MyHomePageState extends State<MyHomePage2> {
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();

  List<Contact> contacts = List.empty(growable: true);
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text('İletişim Listesi '),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBoxWidget(
              height: 70,
            ),
            getNameField(),
            SizedBoxWidget(
              height: 20,
            ),
            getNumberField(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [getSaveButton(), getUpdateButton()],
            ),
            SizedBoxWidget(
              height: 40,
            ),
            contacts.isEmpty
                ? const Text(
                    'Henüz Eklenen Veri Yok..',
                    style: TextStyle(fontSize: 25),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: contacts.length,
                      itemBuilder: (context, index) => getListTile(index),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Widget getNumberField() {
    return TextField(
      maxLength: 10,
      keyboardType: TextInputType.number,
      controller: numberController,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
  }

  Widget getNameField() {
    return TextField(
      controller: nameController,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
  }

  Widget getSaveButton() {
    return ElevatedButton(
        onPressed: () {
          //trim fonksiyonu stringin başındaki ve sonundaki boşluğu siler.
          String userName = nameController.text.trim();
          String userNumber = numberController.text.trim();
          if (userName.isNotEmpty && userNumber.isNotEmpty) {
            setState(() {
              nameController.text = '';
              numberController.text = '';
              //contacts listesine textfielda yazılan değerlerin girilerek eklenmesi
              contacts.add(Contact(userName: userName, userNumber: userNumber));
            });
          }
        },
        child: const Text('Kaydet'));
  }

  Widget getUpdateButton() {
    return ElevatedButton(
        onPressed: () {
          //field içine girilen değeri belirlediğimiz değişkenlere atarız.
          String userName = nameController.text.trim();
          String userNumber = numberController.text.trim();
          if (userName.isNotEmpty && userNumber.isNotEmpty) {
            //eğerki field içi boş değiş ise fonk. içine girecek.
            setState(() {
              nameController.text = '';
              numberController.text = '';
              //seçili olan index yani düzenle ikonuna tıklanıp index değeri seçili indexe eşit olan index;
              //field içinden alınan değişkenlerin atandığı değerleri değişkenlerin seçili indexine göre ata
              contacts[selectedIndex].userName = userName;
              contacts[selectedIndex].userNumber = userNumber;
              selectedIndex = 1;
            });
          }
        },
        child: const Text('Güncelle'));
  }

  Widget getListTile(int index) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          //çift olanları mor tek olanları pembe bacqround yapılacak.
          backgroundColor: index % 2 == 0 ? Colors.purple : Colors.pink,
          foregroundColor: Colors.white,
          child: Text(
            contacts[index]
                .userName[0]
                .toUpperCase(), //eklenen kullanıcının baş harfini ekleyecek.
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
        //listedeki kullanıcı adını ekle
        title: Text(
          contacts[index].userName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        //listedeki numarayı al
        subtitle: Text(contacts[index].userNumber),
        trailing: SizedBox(
          width: 70,
          child: Row(
            children: [
              InkWell(
                  //Güncelleme butonu
                  onTap: () {
                    //listeden gelen kullanıcı adınıı textfield içine yaz
                    nameController.text = contacts[index].userName;
                    numberController.text = contacts[index].userNumber;
                    setState(() {
                      //listenin index değerini seçili olan index değerine ata
                      selectedIndex = index;
                    });
                    //
                  },
                  child: const Icon(Icons.edit)),
              InkWell(
                  onTap: (() {
                    //
                    setState(() {
                      //listenin indexindeki elemanı sil
                      contacts.removeAt(index);
                    });
                    //
                  }),
                  child: const Icon(Icons.delete)),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNameTextField() {
    return TextField(
      controller: nameController,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
  }

  Widget buildNumberTextField() {
    return TextField(
      keyboardType: TextInputType.number,
      maxLength: 10,
      controller: numberController,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
  }
}

class SizedBoxWidget extends StatelessWidget {
  SizedBoxWidget({super.key, required this.height});
  int height;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height.toDouble(),
    );
  }
}
