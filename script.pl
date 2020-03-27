#!/usr/bin/perl
use List::MoreUtils qw(uniq);

die "Need 3 arguments: $0 ['link'] ['filename'] ['Mod title']\n" if @ARGV != 3;

$a = "wget -O .temp.html " . $ARGV[0];
`$a`;

open F, "<.temp.html" or die;

$a = 0;

@array = ();
while (<F>) {
    if ($_ =~ /\"id\"\:\"(\d+)\"\,\"title\"\:\"([^\"]*)\"/) {
        push @array, "$1"." "."$2";
    }
}
close F;

@result = uniq @array;

$argv2 = $ARGV[2];

my $fi = <<"FINAL";
<?xml version="1.0" encoding="utf-8"?>
<html>
  <!--Created by Arma 3 Launcher: https://arma3.com-->
  <head>
    <meta name="arma:Type" content="list" />
    <meta name="generator" content="Arma 3 Launcher - https://arma3.com" />
    <title>Arma 3</title>
    <link href="https://fonts.googleapis.com/css?family=Roboto" rel="stylesheet" type="text/css" />
    <style>
body {
	margin: 0;
	padding: 0;
	color: #fff;
	background: #000;	
}
body, th, td {
	font: 95%/1.3 Roboto, Segoe UI, Tahoma, Arial, Helvetica, sans-serif;
}
td {
    padding: 3px 30px 3px 0;
}
h1 {
    padding: 20px 20px 0 20px;
    color: white;
    font-weight: 200;
    font-family: segoe ui;
    font-size: 3em;
    margin: 0;
}
em {
    font-variant: italic;
    color:silver;
}
.before-list {
    padding: 5px 20px 10px 20px;
}
.mod-list {
    background: #222222;
    padding: 20px;
}
.dlc-list {
    background: #222222;
    padding: 20px;
}
.footer {
    padding: 20px;
    color:gray;
}
.whups {
    color:gray;
}
a {
    color: #D18F21;
    text-decoration: underline;
}
a:hover {
    color:#F1AF41;
    text-decoration: none;
}
.from-steam {
    color: #449EBD;
}
.from-local {
    color: gray;
}
</style>
  </head>
  <body>
  <h1>$argv2</h1>
  <p class="before-list">
    <em>Drag this file or link to it to Arma 3 Launcher or open it Mods / Preset / Import.</em>
  </p>
  <div class="mod-list">
    <table>
FINAL

foreach my $fn (@result) {
    $fn =~ /(\d+)\s(.*)/;
    my $id = $1;
    my $name = $2;
    my $str = "
            <tr data-type=\"ModContainer\">
          <td data-type=\"DisplayName\">$name</td>
          <td>
            <span class=\"from-steam\">Steam</span>
          </td>
          <td>
            <a href=\"http://steamcommunity.com/sharedfiles/filedetails/?id=$id\" data-type=\"Link\">http://steamcommunity.com/sharedfiles/filedetails/?id=$id</a>
          </td>
        </tr>";
    $fi = $fi . $str;
}

my $other = "
      </table>
    </div>
    <div class=\"footer\">
      <span>Created by Arma 3 Launcher by Bohemia Interactive.</span>
    </div>
  </body>
</html>";

$fi = $fi . $other;

$argv1 = $ARGV[1];
open G, ">$argv1" or die;

print G $fi;
close G;

`rm .temp.html`;
