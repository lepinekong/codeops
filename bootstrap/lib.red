Comment {
    Requirements: [
        Redlang: https://www.red-lang.org 
        {or paste this oneliner in powershell: https://gist.github.com/lepinekong/d895d64528ee85e6aac4b13bdf3437bc}
        VSCode: (optional) https://code.visualstudio.com/
        VSCode-Extension: (optional) https://marketplace.visualstudio.com/items?itemName=red-auto.red
    ]  

    Demo: {
        type in red console:
        do read https://gist.githubusercontent.com/lepinekong/31223dda30fd28fc61c686f7780c6962/raw/656b1fc727d12ae6381ca61252a513deb8deafc0/Bootstrap.Code.Generation.red
    }  
}

Red [
    Title: "Bootstrap.Navigation.red"
    Github-Url: https://gist.github.com/lepinekong/31223dda30fd28fc61c686f7780c6962
    History: [
        v0.8: {Nav-Bar component}
    ]
    TODO: [
        - Jumbotron
        - Background Image
        - ...
   

]

html5-template: {
<!doctype html>

<html lang="fr">
    <head>
    <meta charset="utf-8">

    <title>Hello World</title>
    <meta name="description" content="The HTML5 Herald">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="author" content="me">

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">

	<link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet" />
	<link href='http://fonts.googleapis.com/css?family=Abel|Open+Sans:400,600' rel='stylesheet'>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.0/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
    <!--[if lt IE 9]>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/html5shiv/3.7.3/html5shiv.js"></script>
    <![endif]-->
    </head>

    <body>
        <script src=""></script>
    </body>
</html>    
}

emit-nav: function[/inverse /rounded-corner][

    html: copy {}

    snippet: {<nav class="navbar navbar-default navbar-static-top">
    </nav>}

    if inverse [
        snippet: {<nav class="navbar navbar-inverse navbar-static-top">
    </nav>}        
    ]

    if rounded-corner [
        replace/all snippet " navbar-static-top" ""
    ]

    append html snippet
    return html
]

emit-container: function[html /fixed][
    container: {<div class="container-fluid">}
    if fixed [
        container: {<div class="container">}
    ]
    container: rejoin [newline tab container]
    append container {
    </div>}
    parse html [thru {<nav class="navbar} thru {>} mark: (insert mark container)]
    return html
]

emit-navbar-header: function[html .brand [word! string! block!]][
    either block? .brand [
        WebSiteName: .brand/1
        Url: .brand/2
    ][
        WebSiteName: form .brand
        Url: "#"
    ]
    navbar-header: {
        <div class="navbar-header">
            <a class="navbar-brand" href="%url%">%WebSiteName%</a>
        </div>} 
        replace/all navbar-header {%WebSiteName%} WebSiteName
        replace/all navbar-header {%url%} Url
    parse html [thru {<div class="container} thru {>} mark: (insert mark navbar-header)]    
    return html
]

emit-navbar-nav: function[html menu-options][
    navbar-nav: {
        <ul class="nav navbar-nav">
        </ul>}

    reverse menu-options
    forall menu-options [
        menu-option: menu-options/1
        menu-option-string: rejoin [newline tab tab
            {<li><a href="#">Page 1</a></li>}]
        replace/all menu-option-string "Page 1" menu-option/1
        replace/all menu-option-string "#" menu-option/2
        parse navbar-nav [
            thru {<ul class="nav navbar-nav">} mark:
            (insert mark menu-option-string)
        ]
    ] 

    parse html [thru {<div class="container} 
    thru {</div>} mark: (insert mark navbar-nav)]
    return html
]

emit-navbar-search: function[html][
    snippet: {            
        <form class="navbar-form navbar-left">
            	<div class="input-group">
                    <input type="text" class="form-control" placeholder="Search">
                    <span class="input-group-btn">
                        <button type="button" class="btn btn-default"><span class="glyphicon glyphicon-search"></span></button>
                    </span>
                </div>
            </form>
            }

    parse html [thru {<div class="container} 
    thru {</div>} to {</div>} mark: (insert mark snippet)]
    return html            
]

emit-navbar-dropdown-menu: function[html .dropdown-menu][

    title: .dropdown-menu/1/1
    link: .dropdown-menu/1/2

    navbar-nav: {<li class="dropdown">
        <a data-toggle="dropdown" class="dropdown-toggle" href="%link%">%title%<b class="caret"></b></a>
        <ul class="dropdown-menu">
        </ul>
        </li>}
    replace/all navbar-nav "%title%" title
    replace/all navbar-nav "%link%" link

    menu-options: reverse (skip .dropdown-menu 1)
    forall menu-options [
        menu-option: menu-options/1

        either menu-option = 'Divider [
            menu-option-string: rejoin [newline tab tab {<li class="divider"></li>}]
        ][
            menu-option-string: rejoin [newline tab tab
                {<li><a href="#">Page 1</a></li>}]
            replace/all menu-option-string "Page 1" menu-option/1
            replace/all menu-option-string "#" menu-option/2
        ]

        parse navbar-nav [
            thru {<ul class="dropdown-menu">} mark:
            (insert mark menu-option-string)
        ]
    ] 

    parse html [thru {<ul class="nav navbar-nav">} 
    to {</ul>} mark: (insert mark navbar-nav)]
    return html
]

Bootstrap.Nav.Gen: function [
    .brand [word! string! block!] 
    .menu-options [block!]
    /Dropdown-Menu .dropdown-menu [block!]
    /Search-Bar
    /rounded-corner
    /inverse
][  

    code: "emit-nav"
    if inverse [
        append code "/inverse"
    ]
    if rounded-corner [
        append code "/rounded-corner"
    ]
    html: do code ; white by default

    html: emit-container/fixed html ; fluid by default
    html: emit-navbar-header html .brand
    html: emit-navbar-nav html .menu-options
    if Dropdown-Menu [
        html: emit-navbar-dropdown-menu html .dropdown-menu
    ]    
    if Search-Bar [
        html: emit-navbar-search html
    ]
    append html newline
    return html
]

Bootstrap.Page.Gen: function[
        .html5 [string!]
        /title .title [string!]
        /nav-bar .nav-bar
        /insert-body .body [string!]
        /insert-head .head [string!]
    ][
    html5: .html5 

    if title [
        parse html5 [
            thru {<title} thru {>} start: to {</title>} end: (
                change/part start "" end
                insert start .title
            )
        ]
    ]

    if nav-bar [
        parse html5 [to {</body>} mark: (insert mark .nav-bar)]
    ]

    if insert-body [
        parse html5 [to {</body>} mark: (insert mark .body)]
    ]

    if insert-head [
        parse html5 [to {</head>} mark: (insert mark .head)]
    ]

    return html5

]

html.compose: function [
    .html5 [string!] 
    /insert .html 
    /insert-div .div-class 
    /within-div .within-div
    /tab .ntab
    ][

    tab-refinement: tab
    tab: system/words/tab 
    insert-refinement: insert
    insert: get in system/words 'insert

    html5: .html5 

    ntabs: copy ""
    if tab-refinement [
        loop .ntab [append ntabs tab]
    ]    

    if insert-div [

        div-class: rejoin [newline ntabs {<div class="} .div-class {">} newline ntabs {</div>}]

        either within-div [
            within-div-partial: rejoin [{<div class="} .within-div]
            parse html5 [
                thru within-div-partial thru ">" start: (
                    insert start div-class 
                ) 
            ]

        ][
            append html5 div-class
        ]
        return html5
    ]

    if insert-refinement [
        
        if within-div [
            within-div-partial: rejoin [{<div class="} .within-div]
            parse html5 [
                thru within-div-partial thru ">" start: (
                    insert start .html
                ) 
            ]  
            return html5      
        ]
    ]

]

; demo:
; html-content: {<h1 class="margin-base-vertical">Subscribe:</h1>
; 				<form class="margin-base-vertical">
; 					<p class="input-group">
; 						<span class="input-group-addon"><span class="fa fa-envelope"></span></span>
; 						<input type="text" class="form-control input-lg" name="email" placeholder="jonsnow@knowsnothi.ng" />
; 					</p>
; 					<p class="help-block text-center"><small>We won't send you spam. Unsubscribe at any time.</small></p>
; 					<p class="text-center">
; 						<button type="submit" class="btn btn-success btn-lg">Keep me posted</button>
; 					</p>
; 					</span>
; 				</form>}

; css-style: {
; 	<style>
; 		body {padding-top: 0px; font-size: 16px; font-family: "Open Sans",serif;}
; 		h1 {font-family: "Abel", Arial, sans-serif; font-weight: 400; font-size: 40px;}
; 		.margin-base-vertical {margin: 40px 0;}
; 	</style>   
; }

; ; Data in ReAdABLE Human Format (see https://lepinekong.github.io)
; brand: ["Navbar with Search-Bar" https://getbootstrap.com/]
; menu-options: [ [Home "#"] ["Page 1" "#"] ["Page 2" "#"] ["Page 3" "#"] ]
; dropdown-menu: [ ["More Info" "#"] ["Info 1" "#"] ["Info 2" "#"] Divider ["Info 3" "#"] ]

; Bootstrap-Nav: Bootstrap.Nav.Gen/Search-Bar/Dropdown-Menu ; also available: /inverse /rounded-corner
; brand menu-options dropdown-menu; Search-Bar and dropdown list data parameters

; html-body: {}
; html-body: html.compose/insert-div/tab html-body "container" 1
; html-body: html.compose/insert-div/within-div/tab html-body "row" "container" 2
; html-body: html.compose/insert-div/within-div/tab html-body "col-md-6 col-md-offset-3" "row" 3
; html-body: html.compose/insert/within-div html-body html-content "col-md-6 col-md-offset-3"

; Bootstrap-Page: Bootstrap.Page.Gen/title/nav-bar html5-template "Bootstrap Page" Bootstrap-Nav
; Bootstrap-Page: Bootstrap.Page.Gen/title html5-template "Bootstrap Page"
; Bootstrap-Page: Bootstrap.Page.Gen/insert-body Bootstrap-Page html-body
; Bootstrap-Page: Bootstrap.Page.Gen/insert-head Bootstrap-Page css-style

; delete %index.html
; print "Output to %index.html"
; write %index.html Bootstrap-Page
