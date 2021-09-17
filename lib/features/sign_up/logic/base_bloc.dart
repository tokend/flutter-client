import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseBloc<E, S> extends Bloc<E, S> {
  BaseBloc(S initialState) : super(initialState);


}
