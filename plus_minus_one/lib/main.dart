import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

void main() {
  runApp(MyApp());
}

// STATE
class AppState {
  final int count;

  AppState({this.count});
  AppState.initialState() : count = 0;
}

// ACTION
class HomeMinusOneAction {}

class HomePlusOneAction {}

// REDUCER
AppState appReducer(AppState state, action) {
  if (action is HomeMinusOneAction) {
    return AppState(count: state.count - 1);
  }

  if (action is HomePlusOneAction) {
    return AppState(count: state.count + 1);
  }
  return AppState(count: state.count);
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  MyApp()
      : store = Store<AppState>(
          appReducer,
          initialState: AppState.initialState(),
        );

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        home: MyHomePage(title: "test"),
      ),
    );
  }
}

class _ViewModel {
  final int count;
  final VoidCallback onMinusOne;
  final VoidCallback onPlusOne;

  _ViewModel({
    this.count,
    this.onMinusOne,
    this.onPlusOne,
  });
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) {
        return _ViewModel(
          count: store.state.count,
          onMinusOne: () => store.dispatch(HomeMinusOneAction()),
          onPlusOne: () => store.dispatch(HomePlusOneAction()),
        );
      },
      builder: (context, viewModel) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("${viewModel.count}"),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: RaisedButton(
                  padding: EdgeInsets.all(20.0),
                  color: Colors.lightBlue,
                  onPressed: () => viewModel.onPlusOne(),
                  child: Text('Plus One'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: RaisedButton(
                  padding: EdgeInsets.all(20.0),
                  color: Colors.lightBlue,
                  onPressed: () => viewModel.onMinusOne(),
                  child: Text('Minus One'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
