import React from "react";
import TodoForm from "./TodoForm";
import Todo from "./Todo";


export default class TodoLis  extends React.Component {
    state = {
        todos: [],
        todoToShow: "all",
        toggleAllComplete: true
    };

    addTodo = todo => {
        this.setState(state => ({
            todos: [todo, ...state.todos]
        }));
    };

    toggleComplete = id => {
        this.setState(state => ({
            todos: state.todos.map(todo => {
                if (todo.id === id) {
                    // suppose to update
                    return {
                        ...todo,
                        complete: !todo.complete
                    };
                } else {
                    return Todo;
                }
            })
        }));
    };

    updateTodoToShow = s => {
        this.setState({
            todoToShow: s
        });
    };

    handleDeleteTodo = id => {
        this.setState(state => ({
            todos: state.todos.filter(todo => todo.id !== id)
        }));
    };

    removeAllTodosThatAreComplete = () => {
        this.setState(state => ({
            todos: state.todos.filter(todo => !todo.complete)
        }));
    };

    render() {
        let todos = [];

        if (this.state.todoToShow === "all") {
            todos = this.state.todos;
        } else if (this.state.todoToShow === "active") {
            todos = this.state.todos.filter(todo => !todo.complete);
        } else if (this.state.todoToShow === "complete") {
            todos = this.state.todos.filter(todo => todo.complete);
        }
        </div>
    );
    }
}
