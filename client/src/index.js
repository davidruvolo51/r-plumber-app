////////////////////////////////////////////////////////////////////////////////
// FILE: index.js
// AUTHOR: David Ruvolo
// CREATED: 2020-02-10
// MODIFIED: 2020-02-10
// PURPOSE: create a react app
// DEPENDENCIES: react
// STATUS: in.progress
// COMMENTS: NA
////////////////////////////////////////////////////////////////////////////////
// import
import React, { Component } from "react"
import ReactDOM from "react-dom"

import "./styles.css"

// define app
class App extends Component {

    constructor(props) {
        super(props);
        this.state = {
            html: [],
        }
        this.__updateTable = this.__updateTable.bind(this);
    }

    // insert response
    __updateTable() {

        // get value and update state
        const input = document.getElementById("limits");
        const selection = input.options[input.selectedIndex].value;

        // send request 
        fetch("/data", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
            },
            body: JSON.stringify({ value: selection })
        }).then(response => {
            if (response.ok) {
                return response.json();
            } else {
                throw response
            }
        }).then(result => {
            
            // render table - remove existing table if applicable
            const elem = document.getElementById("table_output");
            if (elem.getElementsByTagName("table").length > 0) {
                const t = elem.querySelector("table");
                elem.removeChild(t);
            }
            elem.insertAdjacentHTML("beforeend", result.html[0])

        }).catch(error => {
            console.log(error)
        })
    }

    // lifecycles
    componentDidMount() {
        this.__updateTable()
    }

    // render
    render() {
        return (
            <>
                <header className="header">
                    <h1>R Plumber</h1>
                </header>
                <main className="main">
                    <section className="section">
                        <h2>About</h2>
                        <p>This application replicates a few applications - the <a href="https://davidruvolo51.github.io/shinytutorials/tutorials/sass-in-shiny/">sass in shiny tutorial</a> and the <a href="https://davidruvolo51.github.io/shinytutorials/tutorials/responsive-tables/">responsive datatables tutorial</a>. This application uses Rplumber as a backend instead of shiny and uses react as the client.</p>
                    </section>
                    <section className="section" id="table_output">
                        <h2>Generate Table</h2>
                        <form>
                            <label>Select Records to Display</label>
                            <select id="limits" name="limits" onChange={this.__updateTable}>
                                <option value="5">5</option>
                                <option value="10">10</option>
                                <option value="15">15</option>
                                <option value="25">25</option>
                                <option value="50">50</option>
                                <option value="100">100</option>
                                <option value="150">150</option>
                                <option value="all">All</option>
                            </select>
                        </form>
                    </section>
                </main>
            </>
        )
    }
}

// render
ReactDOM.render(<App />, document.getElementById("root"));
