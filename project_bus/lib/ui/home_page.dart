import 'package:flutter/material.dart';
import 'package:little_contacts/helpers/timer_helper.dart';
import 'package:little_contacts/ui/timer_page.dart';

enum OrderOptions{orderaz, orderza}

class HomePage extends StatefulWidget {
//  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TimerHelper helper = TimerHelper();

  List<Timer> timers = List();

  @override
  void initState() {
    super.initState();

    _getAllTimers();
  } //TESTE DE FUNCIONAMENTO DO BANCO
  /* @override
  void initState() {
    super.initState();

   Timer c = Timer();
    c.schoolIn = "marechal";
    c.date = "23/10/2021";
    c.quilometerIn = "325.985";
    c.quilometerOut = "325.950";
    c.quilometerAll = "52.25";

    helper.saveTimer(c);

    helper.getAllTimer().then((list){
      print(list);
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordernar de A-Z"),
                value: OrderOptions.orderaz,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordernar de Z-A"),
                value: OrderOptions.orderza,
              )
            ],
            onSelected: _orderList,
          )
        ],
        title: Text(
          "Horários",
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
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showTimerPage();
        },
        child: Container(
          width: 60,
          height: 60,
          child: Icon(Icons.add, color: Colors.white),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [Colors.green, Colors.yellow])),
        ),
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(8.0),
          itemCount: timers.length,
          //retorna o tamanho da lista dos horários
          itemBuilder: (context, index) {
            return _timerCard(context, index);
          }),
    );
  }

  Widget _timerCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  children: [
                    Text(
                      timers[index].schoolIn ?? "",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      timers[index].quilometerIn ?? "",
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      timers[index].quilometerOut ?? "",
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      timers[index].quilometerOut ?? "",
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      timers[index].date ?? "",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        _showOptions(context, index);
      },
    );
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  //ocupar o menimo de espaço disponível
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text(
                          "Editar",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _showTimerPage(timer: timers[index]);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text(
                          "Excluir",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: () {
                          helper.deleteTimer(timers[index].id);
                          //remove o horario
                          setState(() {
                            timers.removeAt(index);
                            //remover da lista
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  void _showTimerPage({Timer timer}) async {
    //void nao retorna nada
    final recTimer = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => TimerPage(timer: timer)));
    //já carrega o horário na página, caso ele exista,( manda pra próxima tela)
    if (recTimer != null) {
      if (timer != null) {
        await helper.updateTimer(recTimer);
        //atualiza o contato que mandei
      } else {
        await helper.saveTimer(recTimer);
      }
      _getAllTimers();
      //devolve os contatos atualizados
    }
  }

  void _getAllTimers() {
    helper.getAllTimer().then((list) {
      setState(() {
        timers = list;
        //carrega a lista do banco e coloca na tela
      });
    });
  }

  void _orderList(OrderOptions result){
    switch(result){
      case OrderOptions.orderaz:
        timers.sort((a,b) {
         return a.schoolIn.toLowerCase().compareTo(b.schoolIn.toLowerCase());
        });
        break;
        case OrderOptions.orderza:
          timers.sort((a,b) {
           return  b.schoolIn.toLowerCase().compareTo(a.schoolIn.toLowerCase());
          });
        break;
    }
    setState((){

              });
  }
}
