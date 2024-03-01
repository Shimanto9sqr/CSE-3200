
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

class CseInfo extends StatefulWidget {
  const CseInfo({super.key});

  @override
  State<CseInfo> createState() => _CseInfoState();
}

class _CseInfoState extends State<CseInfo> {
  
  @override
  void initState(){
    super.initState();
    initialization();
    getCseDate();
  }
   void initialization() async {
   
    
    await Future.delayed(const Duration(seconds:1));
   
    FlutterNativeSplash.remove();
  }

  Future<List<String>> getCseDate() async { 
    final url = Uri.parse('https://www.cse.ruet.ac.bd/teacher_list');
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);
    print(html);
    final images = html
          .querySelectorAll('#table_list > tbody > tr> td:nth-child(1) > img')
          .map((element)=> 'https://www.cse.ruet.ac.bd${element.attributes['src']}')
          .toList();
    final name = html
          .querySelectorAll('#table_list > tbody > tr> td:nth-child(3)> a').map((element) => element.innerHtml.trim())
          .toList();
    final designation = html
          .querySelectorAll('#table_list > tbody > tr> td:nth-child(7)').map((element) => element.innerHtml.trim())
          .toList();
    final department = html
          .querySelectorAll('#table_list > tbody > tr> td:nth-child(9)').map((element) => element.innerHtml.trim())
          .toList();
    final email = html
          .querySelectorAll('#table_list > tbody > tr> td:nth-child(11)').map((element) => element.innerHtml.trim())
          .toList();
    final phone = html
          .querySelectorAll('#table_list > tbody > tr> td:nth-child(13)').map((element) => element.innerHtml.trim())
          .toList();
    final officeContact = html
          .querySelectorAll('#table_list > tbody > tr> td:nth-child(15)').map((element) => element.innerHtml.trim())
          .toList();           

   // print('Count: ${images.length}');
    for(int i=0;i<images.length;i++){
      print(images[i]);
      print(name[i]);
      print(designation[i]);
      print(department[i]);
      print(email[i]);
      print(phone[i]);
      print(officeContact[i]);

    }    
     return images;         
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
           appBar: AppBar(
            title: const Text("Show Photo"),
            centerTitle: true,
            backgroundColor: Colors.cyan,
           ),
           body: Center(
            child: FutureBuilder<List<String>>(future: getCseDate(), builder: ((context,snapshot){
              if(snapshot.hasData){
                 return ListView.builder(itemBuilder: (context,index){
                    String? photo = snapshot.data?[index];
                    return ListTile(
                         leading: Image.network(photo!),
                         title: const Text('Faculty of CSE'),
                    );
                 },
                 itemCount: snapshot.data!.length,
                 );
                  
                
              }else if(snapshot.hasError){
                return Text('ERROR: ${snapshot.error}');
              }

              return const CircularProgressIndicator();

            }),  )
           ),
    );
  }
}