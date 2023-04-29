import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class SQLhelper {
  static Future<void> createTables(Database database) async {
    //Veritabanını oluşturduk ve tablomuzda yer alması gerekenleri execute ettik.
    await database.execute("""CREATE TABLE items(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      title TEXT,
      description TEXT,
      createdAt TIMESTAMP NOT NULL DEFAULT CURENT_TIMESTAMP
    )""");
  }

  static Future<Database> db() async {
    //veritabanımızın adını versyonunu alırız ve tablo oluşturma fonks. çağırırız.
    return openDatabase('ItemsDB.db', version: 1,
        onCreate: (Database database, version) async {
      print('...tablo oluşturuldu');
      await createTables(database);
    });
  }

//veritabanına değişkenleri eklemek isterken kullanacağımız fonk.
  static Future<int> createItem(String title, String? description) async {
    final db = await SQLhelper.db(); //veritabanını çağır
    final data = {
      'title': title,
      'description': description
    }; //Eklenecek olan değerler-tabloda yer alan
    final id = await db.insert('items', data,
        conflictAlgorithm: ConflictAlgorithm
            .replace); //Veritabanına ekleriz neye göre tablo ismine ve girilecek verilere göre
    return id;
  }

//veritabanından id numarasına göre çekeceğimiz fonk.
  static Future<List<Map<String, dynamic>>> getItems() async {
    //Değerleri getir
    final db = await SQLhelper.db(); //veritabanını çağır
    return db.query('items',
        orderBy: 'id'); //id numarasını sırala ve öyle getir.
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLhelper.db(); //veritabanını çağır
    return db.query('items', where: 'id=?', whereArgs: [id], limit: 1);
  }

//ekle işleminin güncelleme işlemi olanı
  static Future<int> updateItem(
      int id, String title, String? description) async {
    final db = await SQLhelper.db(); //veritabanını çağır
    final data = {
      'title': title,
      'description': description,
      'createdAt': DateTime.now()
          .toString() //tekrar ne zaman güncellendiyse o vakiti güncelleme adına
    };

    final result =
        await db.update('items', data, where: 'id=?', whereArgs: [id]);
    return result;
  }

//var olan tabloodan idye göre silme işlemi
  static Future<void> deleteItem(int id) async {
    final db = await SQLhelper.db(); //veritabanını çağır

    try {
      await db.delete('items', where: 'id=?', whereArgs: [id]);
    } catch (e) {
      debugPrint('Bi şeyler ters gitti $e');
    }
  }
}
