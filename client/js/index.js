////////////////////////////////////////////////////////////////////////////////
// FILE: index.js
// AUTHOR: David Ruvolo
// CREATED: 2020-01-26
// MODIFIED: 2020-01-26
// PURPOSE: fetch data from api
// DEPENDENCIES: NA
// STATUS: working
// COMMENTS: NA
////////////////////////////////////////////////////////////////////////////////
// BEGIN

// function that returns selected option
function getLimits() {
    const input = document.getElementById("limits");
    return input.options[input.selectedIndex].value
}

async function updateTable() {
    fetch("/data", {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
        },
        body: JSON.stringify({
            value: getLimits()
        })
    }).then(response => {
        if (response.ok) {
            return response.json();
        } else {
            throw response
        }
    }).then(text => {
        const elem = document.getElementById("table_output");
        if(elem.querySelector("table")) {
            const t = elem.querySelector("table");
            elem.removeChild(t);
        } 
        elem.insertAdjacentHTML("beforeend", text.html[0]);
    }).catch(error => {
        console.log(error)
    })
}

// init table on page load
document.addEventListener("DOMContentLoaded", function(){
    updateTable();
})

// update table when input changed
const input = document.getElementById("limits");
input.addEventListener("change", function(){
    updateTable();
})