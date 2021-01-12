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
        fetch("/html", {
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
                <p>R Plumber</p>
            </header>
            <main className="main">
                <section className="section">
                    <h1>R Plumber Example</h1>
                    <p>This application demonstrates how to integrate React and R using the Plumber package. This example app also builds on other tutorials and examples in the <a href="https://github.com/davidruvolo51/shinyAppTutorials">shinyAppTutorials</a> project. In the following section, select how many rows you would like to display from the <a href="https://github.com/allisonhorst/palmerpenguins">palmerpenguins</a> dataset. The response is a html generated table as described in the <a href="https://github.com/davidruvolo51/shinyAppTutorials/tree/main/responsive-datatables">responsive datatable example</a></p>
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
                            <option value="100">100</option>
                            {/* <option value="999">All</option> */}
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
