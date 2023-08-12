import { useEffect, useState } from "react"

function App() {

  const [isLoading, setLoading] = useState(true)
  const [html, setHTML] = useState("")
  useEffect(() => {
    setHTML("Hello, world!")
  }, [isLoading])

  const [selection, setSelection] = useState(5)

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
      setHTML(result.html)
    }).catch(error => {
      throw new Error(error)
    });
  }, [selection]);

  return (
    <>
      <header className="header">
        <h1>R Plumber</h1>
      </header>
      <main className="main">
        <section className="section">
          <h2>R Plumber Example</h2>
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
          <div dangerouslySetInnerHTML={{ __html: html }} />
        </section>
      </main>
    </>
  )
}

export default App
