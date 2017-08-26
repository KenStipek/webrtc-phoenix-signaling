


<script src="<%= static_path(@conn, "/js/app.js") %>"></script>
tämä oli app.html.eex tiedostossa


käytä

heroku auth:token

siitä tulevaa salasanaa voit käyttää kun ajat
git push heroku master


vanha package.json

{
  "repository": {},
  "license": "MIT",
  "scripts": {
    "deploy": "brunch build --production",
    "watch": "brunch watch --stdin"
  },
  "dependencies": {
    "phoenix": "file:../deps/phoenix",
    "phoenix_html": "file:../deps/phoenix_html"
  },
  "devDependencies": {
    "babel-brunch": "6.1.1",
    "brunch": "2.10.9",
    "clean-css-brunch": "2.10.0",
    "uglify-js-brunch": "2.10.0"
  }
}
