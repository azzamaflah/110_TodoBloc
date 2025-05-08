import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todobloc/model/todo.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoLoaded(todos: [], selectDate: null)) {
    on<TodoEventAdd>((event, emit) {
      final currentState = state;
      if (currentState is TodoLoaded) {
        final List<Todo> updatedTodos = List.from(currentState.todos);

        updatedTodos.add(
          Todo(title: event.title, date: event.date, isComplete: false),
        );

        emit(
          TodoLoaded(todos: updatedTodos, selectDate: currentState.selectDate),
        );
      }
      ;
    });

    on<TodoSelectDate>((event, emit) {
      final currentstate = state;
      if (currentstate is TodoLoaded) {
        emit(TodoLoaded(todos: currentstate.todos, selectDate: event.date));
      }
    });
    on<TodoEventComplete>((event, emit) {
      final currentState = state;

      if (currentState is TodoLoaded) {
        final List<Todo> updatedTodos = List.from(currentState.todos);

        if (event.index >= 0 && event.index < updatedTodos.length) {
          updatedTodos[event.index] = Todo(
            title: updatedTodos[event.index].title,
            isComplete: !updatedTodos[event.index].isComplete,

            // isComplete: updatedTodos[event.index].isComplete,
            date: updatedTodos[event.index].date,
          );

          emit(
            TodoLoaded(
              todos: updatedTodos,
              selectDate: currentState.selectDate,
            ),
          );
        }
      }
    });
  }
}
