import 'dart:async';
import 'package:flutter/material.dart';
import 'package:little_contacts/helpers/timer_helper.dart';

class TimerPage extends StatefulWidget {
  // const TimerPage({Key? key}) : super(key: key);
  final Timer timer;

  TimerPage({this.timer});

  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {

  final _schoolController = TextEditingController();
  final _quilometerOutController = TextEditingController();
  final _quilometerInController = TextEditingController();
  final _quilometerAllController = TextEditingController();

  TimeOfDay selectedTime =TimeOfDay.now();

  final _schoolFocus = FocusNode();
  bool _userEdited = false;
  Timer _editedTimer;

  @override
  void initState() {
    super.initState();

    if (widget.timer == null) {
      _editedTimer = Timer();
    } else {
      _editedTimer = Timer.fromMap(widget.timer.toMap());
      //criando um novo horario através do mapa
      _schoolController.text = _editedTimer.schoolIn;
      _quilometerOutController.text = _editedTimer.quilometerOut;
      _quilometerInController.text= _editedTimer.quilometerIn;
      _quilometerAllController.text = _editedTimer.quilometerAll;
      //já pega os dados dos horários e preenche automaticamente

    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      ///chama uma função para um popup
      onWillPop: _requestPop,
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              _editedTimer.schoolIn ?? "Novo Horário",
              style: TextStyle(color: Colors.black),
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[Colors.green, Colors.yellow])),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if(_editedTimer.schoolIn != null && _editedTimer.schoolIn.isNotEmpty){
                Navigator.pop(context, _editedTimer);
              } else {
                FocusScope.of(context).requestFocus(_schoolFocus);
                //se tentar salvar sem a escola, ele vai para o campo escola direto
                //para preencher
              }
            },
            child: Container(
              width: 60,
              height: 60,
              child: Icon(Icons.save, color: Colors.white),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [Colors.green, Colors.yellow])),
            ),
          ),
          body: SingleChildScrollView(
            //single é para rolar a tela quando abrir o treclado e não tampar o conteudo
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                TextField(
                  controller: _schoolController,
                  focusNode: _schoolFocus,
                  decoration: InputDecoration(labelText: "Nome da escola"),
                  onChanged: (text){
                    _userEdited = true;
                    setState(() {
                      _editedTimer.schoolIn = text;
                      //salvando no contato editado
                    });
                  },
                ),
                TextField(
                  controller: _quilometerOutController,
                  decoration: InputDecoration(labelText: "Km's de saída da garagem"),
                  onChanged: (text){
                    _userEdited = true;
                    _editedTimer.quilometerOut = text;
                  },
                  keyboardType: TextInputType.number,
                ),TextField(
                  controller: _quilometerInController,
                  decoration: InputDecoration(labelText: "Km's de chegada na escola"),
                  onChanged: (text){
                    _userEdited = true;
                    _editedTimer.quilometerIn = text;
                  },
                  keyboardType: TextInputType.number,
                ),TextField(
                  controller: _quilometerAllController,
                  decoration: InputDecoration(labelText: "Total de Km's"),
                  onChanged: (text){
                    _userEdited = true;
                    _editedTimer.quilometerAll = text;
                  },
                  keyboardType: TextInputType.number,
                ),TextField(
                  // controller: _dateController,
                  decoration: InputDecoration(labelText: "Data"),
                  onChanged: (text){
                    _userEdited = true;
                    _editedTimer.date = text;
                  },
                  keyboardType: TextInputType.number,
                ),
                /*RaisedButton(
              onPressed: () => _chooseDate(context),
              child: Text('Select date'),
            ),*/

              ],
            ),
          )
      ),
    );
  }

 Future<bool> _requestPop(){
    if(_userEdited){
      showDialog(context: context, builder: (context){
        return AlertDialog(
          title: Text("Descartar Alterações?"),
          content: Text("Se sair, as alterações serão perdidas"),
          actions: [
            FlatButton(
              child: Text("Cancelar"),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("Sair"),
              onPressed: (){
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

/* void _chooseDate(BuildContext context){
    Future<Null> _selectTime(BuildContext context) async {
      final TimeOfDay picked_s = await showTimePicker(
          context: context,
          initialTime: selectedTime, builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child,
        );});

      if (picked_s != null && picked_s != selectedTime )
        setState(() {
          selectedTime = picked_s;
        });
    }
  }*/
}
