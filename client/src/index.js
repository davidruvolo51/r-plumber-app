////////////////////////////////////////////////////////////////////////////////
// FILE: index.js
// AUTHOR: David Ruvolo
// CREATED: 2020-02-10
// MODIFIED: 2020-02-11
// PURPOSE: create client using React, Hooks, and Fetch API
// DEPENDENCIES: react
// STATUS: working
// COMMENTS: 
//      This react application uses react hooks and fetch API to retrieve
//      data the API "/data" started by R Plumber. This example is fairly simple,
//      but it demonstrates the use of R plumber, React with Hooks, Fetch API,
//      and triggering events using input elements.
////////////////////////////////////////////////////////////////////////////////
import React, { useEffect, useState } from "react"
import ReactDOM from "react-dom"
import "./styles.css"

// define function component called <App />
function App() {

    // set state
    const [isLoading, setLoading] = useState(true)
    const [html, setHTML] = useState("")
    useEffect(() => {
        setHTML("Hello, world!")
    }, [isLoading])
    
    // get input values (default values)
    const [selection, setSelection] = useState(5)

    // send request based on selection status
    useEffect(() => {
        fetch("http://localhost/data", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
            },
            body: JSON.stringify({ value: selection })
        }).then(response => {
            // process response
            if (response.ok) {
                return response.json();
            } else {
                throw response
            }
        }).then(result => {
            // send result to state
            setHTML(result.html)
        }).catch(error => {
            // send error to state
            setHTML(error)
        });
    }, [selection]);

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
                        <select id="limits" name="limits" onChange={(e) => setSelection(e.target.value)}>
                            <option value="5">5</option>
                            <option value="10">10</option>
                            <option value="15">15</option>
                            <option value="25">25</option>
                            <option value="50">50</option>
                            <option value="all">All</option>
                        </select>
                    </form>
                    <div dangerouslySetInnerHTML={{__html: html}} />
                </section>
            </main>
        </>
    )
}

// render
ReactDOM.render(<App />, document.getElementById("root"));
