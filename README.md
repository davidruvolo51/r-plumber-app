# R Plumber Application

This repo provides a demo for creating interactive web applications using plumber. This app replicates the [responsive datatables](https://davidruvolo51.github.io/shinytutorials/tutorials/responsive-tables/) tutorial using plumber for the backend. 

## About

There are a few key files that are used in this application.

- `server.R`: creates a new app (via plumber)
- `server/api.R`: defines the api `/data`
- `client/js/index.js`: client-side processesing of the request and response

There is also the static page `index.html` which servers as the interface and loads other assets (css, js).

On the server side, the main file is `server.R`, this file creates a new app based on configurations in the file `server/api.R`. The server file also mounts static resources in `/client` (via `app$mount(...)`). In the file `api.R` creates an api `/data` which serves as a mechanism for rendering html tables server-side based on client-side variables. The api `/data` uses the variable `value` sent from the client. `value` is the number of rows to select from the sample dataset. This returns the a data table generated using the function defined in the [accessibleshiny](https://github.com/davidruvolo51/accessibleshiny)(in progress). The api returns a character string of the html structure of the datatable. In the `index.js` file, the function `updateTable()` processes the POST request and uses `insertAdjacentHTML` to render the table in the page.

## Usage

To run the app, clone the repository. You must have the following tools to run.

- [Nodejs and npm](https://nodejs.org/)
- [yarn](https://legacy.yarnpkg.com/lang/en/docs/install/)

Yarn isn't necssary, but I prefer it over npm for starting the dev server. (In this project anyways.)

You can check the installation of all of the tools by running the following commands (this returns the version numbers).

```bash
node -v
npm -v
yarn -v
```

Start the dev server using yarn or npm. If you have base-r installed, then this should work.

```bash
# with yarn
yarn dev

# or with npm
npm run dev
```

This example provides a minimal working application. From here, you can continue developing the client with/without a web framework (react, vue, angular, etc.) as well as create new api's. If you have any questions, feel free to open a new issue.