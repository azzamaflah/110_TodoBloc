import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todobloc/bloc/todo_bloc.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _key = GlobalKey<FormState>();
    final _controller = TextEditingController();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Todo List'),

              Row(
                children: [
                  Column(
                    children: [
                      Text('Pilih Tanggal'),

                      BlocBuilder<TodoBloc, TodoState>(
                        builder: (context, state) {
                          if (state is TodoLoaded) {
                            if (state.selectDate != null) {
                              return Text(
                                '${state.selectDate!.day}/${state.selectDate!.month}/${state.selectDate!.year}',
                              );
                            }
                          }
                          return Text('Tidak ada tanggal yang dipilih');
                        },
                      ),
                    ],
                  ),

                  SizedBox(width: 16.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        ).then((selectedDate) {
                          if (selectedDate != null) {
                            context.read<TodoBloc>().add(
                              TodoSelectDate(date: selectedDate),
                            );
                          }
                        });
                      },
                      child: Text('Pilih Tanggal'),
                    ),
                  ),
                ],
              ),

               SizedBox(height: 20),
              Form(
                key: _key,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _controller,
                        decoration: InputDecoration(
                          labelText: 'Todo',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Masukan data todo';
                          }
                          return null;
                        },
                      ),
                    ),

                    SizedBox(width: 10),
                    FilledButton(
                      onPressed: () {
                        if (_key.currentState!.validate()) {
                          final selectDate = context.read<TodoBloc>().state;

                          if (selectDate is TodoLoaded) {
                            context.read<TodoBloc>().add(
                              TodoEventAdd(
                                title: _controller.text,
                                date: selectDate.selectDate!,
                              ),
                            );
                            _controller.clear();
                            selectDate.selectDate = null;
                          }
                        }
                      },
                      child: Text('Tambah'),
                    ),
                  ],
                ),
              ),
              
            SizedBox(height: 16.0),
              Expanded(
                child: BlocBuilder<TodoBloc, TodoState>(
                  builder: (context, state) {
                    if(state is TodoLoading) {
                      return Center(child: CircularProgressIndicator(),);
                    } else if (state is TodoLoaded) {
                      
                      if(state.todos.isEmpty) {
                        return Center(child: Text('Todo List Kosong'));
                      }

                      return ListView.builder(
                        itemCount: state.todos.length,
                        itemBuilder: (context, index) {
                          final todo = state.todos[index];
                          return Container(
                            margin: EdgeInsets.only(bottom: 8.0),
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(8.0)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          todo.title,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                         SizedBox(height: 24),
                                        Text(
                                          '${todo.date.day}/${todo.date.month}/${todo.date.year}',
                                          style: TextStyle(color: Colors.grey),
                                        ),

                                        SizedBox(height: 4.0),
                                        Text(
                                          todo.isComplete
                                            ? 'completed'
                                            : 'Not Completed',
                                          style: TextStyle(
                                            color:
                                              todo.isComplete
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                        )
                                      ],
                                    ),
            ],
          ),
        ),
      ),
    );
  }
}
